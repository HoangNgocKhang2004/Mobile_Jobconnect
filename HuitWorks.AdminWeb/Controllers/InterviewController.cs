using HuitWorks.AdminWeb.Models;
using HuitWorks.AdminWeb.Models.ViewModels;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Routing.Matching;
using System.Net.Http;

namespace HuitWorks.AdminWeb.Controllers
{
    public class InterviewController : Controller
    {
        private readonly HttpClient _httpClient;

        public InterviewController()
        {
            _httpClient = new HttpClient { BaseAddress = new Uri("http://localhost:5281") };
        }

        // GET: Hiển thị danh sách lịch phỏng vấn
        public async Task<IActionResult> Index(int page = 1, int pageSize = 6)
        {
            // 1) Lấy tất cả lịch
            var schedulesResponse = await _httpClient.GetAsync("api/InterviewSchedule");
            if (!schedulesResponse.IsSuccessStatusCode)
                return View(new List<InterviewScheduleViewModel>());

            var schedules = await schedulesResponse.Content
                .ReadFromJsonAsync<List<InterviewScheduleViewModel>>();

            // 2) Enrich từng schedule với application, candidate, job, recruiter…
            var listViewModels = new List<InterviewScheduleViewModel>();
            foreach (var sch in schedules)
            {
                // JobApplication
                var appResp = await _httpClient.GetAsync(
                    $"api/JobApplication/{sch.IdJobPost}/{sch.IdUser}");
                if (!appResp.IsSuccessStatusCode) continue;
                var jobApp = await appResp.Content.ReadFromJsonAsync<JobApplicationViewModel>();

                // Candidate
                var candResp = await _httpClient.GetAsync($"api/User/{jobApp.IdUser}");
                if (!candResp.IsSuccessStatusCode) continue;
                var candidate = await candResp.Content.ReadFromJsonAsync<UserViewModel>();

                // JobPosting
                var jobResp = await _httpClient.GetAsync($"api/JobPosting/{jobApp.IdJobPost}");
                if (!jobResp.IsSuccessStatusCode) continue;
                var job = await jobResp.Content.ReadFromJsonAsync<JobPostingViewModel>();

                // RecruiterInfo
                var recInfoResp = await _httpClient.GetAsync($"api/RecruiterInfo/{job.IdCompany}");
                string recruiterName = "Không xác định";
                if (recInfoResp.IsSuccessStatusCode)
                {
                    var recInfo = await recInfoResp.Content
                        .ReadFromJsonAsync<RecruiterInfoViewModel>();
                    recruiterName = recInfo?.Title ?? recruiterName;
                }

                // Build enriched VM
                listViewModels.Add(new InterviewScheduleViewModel
                {
                    IdSchedule = sch.IdSchedule,
                    InterviewDate = sch.InterviewDate,
                    InterviewMode = sch.InterviewMode,
                    Location = sch.Location,
                    Interviewer = sch.Interviewer,
                    Note = sch.Note,

                    ApplicationStatus = jobApp.ApplicationStatus,
                    CandidateName = candidate.UserName,
                    CandidateEmail = candidate.Email,

                    JobTitle = job.Title,
                    JobDescription = job.Description,

                    RecruiterName = recruiterName
                });
            }

            // 3) Tính các chỉ số cho card
            ViewBag.TotalSchedules = listViewModels.Count;
            ViewBag.InterviewedCount = listViewModels
                .Count(x => string.Equals(x.ApplicationStatus, "Đã phỏng vấn", StringComparison.OrdinalIgnoreCase)
                          || string.Equals(x.ApplicationStatus, "Interviewed", StringComparison.OrdinalIgnoreCase));
            ViewBag.AcceptedCount = listViewModels
                .Count(x => string.Equals(x.ApplicationStatus, "Đã chấp nhận", StringComparison.OrdinalIgnoreCase)
                          || string.Equals(x.ApplicationStatus, "Accepted", StringComparison.OrdinalIgnoreCase));
            ViewBag.RejectedCount = listViewModels
                .Count(x => string.Equals(x.ApplicationStatus, "Bị từ chối", StringComparison.OrdinalIgnoreCase)
                          || string.Equals(x.ApplicationStatus, "Rejected", StringComparison.OrdinalIgnoreCase));

            // 4) Phân trang trên list đã enrich
            int totalItems = listViewModels.Count;
            int totalPages = (int)Math.Ceiling((double)totalItems / pageSize);
            var paginatedSchedules = listViewModels
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToList();

            ViewBag.CurrentPage = page;
            ViewBag.TotalPages = totalPages;

            return View(paginatedSchedules);
        }


        // GET: Interview/Edit/{id}
        public async Task<IActionResult> Edit(string id)
        {
            var response = await _httpClient.GetAsync($"/api/InterviewSchedule/{id}");
            if (!response.IsSuccessStatusCode) return NotFound();

            var schedule = await response.Content.ReadFromJsonAsync<InterviewSchedViewModel>();
            if (schedule == null) return NotFound();

            var vm = new InterviewSchedViewModel
            {
                IdSchedule = schedule.IdSchedule,
                //IdJobApp = schedule.IdJobApp,
                InterviewDate = schedule.InterviewDate,
                InterviewMode = schedule.InterviewMode,
                Location = schedule.Location,
                Interviewer = schedule.Interviewer,
                Note = schedule.Note
            };

            return View(vm);
        }

        // POST: Interview/Edit/{id}
        [HttpPost]
        public async Task<IActionResult> Edit(InterviewSchedViewModel model)
        {
            if (!ModelState.IsValid)
                return View(model);

            var dto = new InterviewSchedViewModel
            {
                IdSchedule = model.IdSchedule,
                //IdJobApp = model.IdJobApp, 
                InterviewDate = model.InterviewDate,
                InterviewMode = model.InterviewMode,
                Location = model.Location,
                Interviewer = model.Interviewer,
                Note = model.Note
            };

            var response = await _httpClient.PutAsJsonAsync($"/api/InterviewSchedule/{model.IdSchedule}", dto);
            if (response.IsSuccessStatusCode)
            {
                TempData["SuccessMessage"] = "Cập nhật lịch phỏng vấn thành công!";
                return RedirectToAction("Index");
            }

            ModelState.AddModelError(string.Empty, "Lỗi cập nhật lịch phỏng vấn.");
            return View(model);
        }

        [HttpGet]
        public async Task<IActionResult> Details(string id)
        {
            var scheduleRes = await _httpClient.GetAsync($"/api/InterviewSchedule/{id}");
            if (!scheduleRes.IsSuccessStatusCode)
                return NotFound();

            var schedule = await scheduleRes.Content
                .ReadFromJsonAsync<InterviewScheduleViewModel>();
            if (schedule == null)
                return NotFound();

            var appRes = await _httpClient.GetAsync(
                $"/api/JobApplication/{schedule.IdJobPost}/{schedule.IdUser}");
            if (!appRes.IsSuccessStatusCode)
                return NotFound();

            var jobApp = await appRes.Content
                .ReadFromJsonAsync<JobApplicationViewModel>();
            if (jobApp == null)
                return NotFound();

            var userRes = await _httpClient.GetAsync($"/api/User/{jobApp.IdUser}");
            var user = userRes.IsSuccessStatusCode
                ? await userRes.Content.ReadFromJsonAsync<UserViewModel>()
                : null;

            var jobRes = await _httpClient.GetAsync($"/api/JobPosting/{jobApp.IdJobPost}");
            var job = jobRes.IsSuccessStatusCode
                ? await jobRes.Content.ReadFromJsonAsync<JobPostingViewModel>()
                : null;

            string recruiterName = "Không xác định";
            if (job != null)
            {
                var recRes = await _httpClient.GetAsync($"/api/RecruiterInfo/{job.IdCompany}");
                if (recRes.IsSuccessStatusCode)
                {
                    var rec = await recRes.Content
                        .ReadFromJsonAsync<RecruiterInfoViewModel>();
                    recruiterName = rec?.Title ?? recruiterName;
                }
            }

            var vm = new InterviewScheduleViewModel
            {
                IdSchedule = schedule.IdSchedule,
                IdJobPost = schedule.IdJobPost,
                IdUser = schedule.IdUser,
                InterviewDate = schedule.InterviewDate,
                InterviewMode = schedule.InterviewMode,
                Location = schedule.Location,
                Interviewer = schedule.Interviewer,
                Note = schedule.Note,

                ApplicationStatus = jobApp.ApplicationStatus,
                CandidateName = user?.UserName,
                CandidateEmail = user?.Email,

                JobTitle = job?.Title,
                JobDescription = job?.Description,

                RecruiterName = recruiterName
            };

            return View(vm);
        }


        [HttpPost]
        public async Task<IActionResult> Create([FromBody] InterviewScheduleViewModel schedule)
        {
            var response = await _httpClient.PostAsJsonAsync("/api/InterviewSchedule", schedule);
            if (response.IsSuccessStatusCode)
            {
                TempData["SuccessMessage"] = "Thêm lịch phỏng vấn thành công!";
                return RedirectToAction("Index");
            }

            return BadRequest(await response.Content.ReadAsStringAsync());
        }

        // DELETE
        [HttpPost]
        public async Task<IActionResult> Delete(string id)
        {
            var response = await _httpClient.DeleteAsync($"/api/InterviewSchedule/{id}");
            if (response.IsSuccessStatusCode)
            {
                TempData["SuccessMessage"] = "Xóa lịch phỏng vấn thành công!";
                return RedirectToAction("Index");
            }

            return BadRequest(await response.Content.ReadAsStringAsync());
        }
    }
}
