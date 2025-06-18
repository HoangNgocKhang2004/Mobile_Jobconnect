using Microsoft.AspNetCore.Mvc;
using HuitWorks.AdminWeb.Models.ViewModels;
using Newtonsoft.Json;
using System.Text;
using Microsoft.AspNetCore.Http.HttpResults;

namespace HuitWorks.AdminWeb.Controllers
{
    public class CandidatesController : Controller
    {
        private readonly HttpClient _httpClient;

        public CandidatesController()
        {
            _httpClient = new HttpClient();
            _httpClient.BaseAddress = new Uri("http://localhost:5281");
        }

        // Controller: CandidateController.cs
        public async Task<IActionResult> ListCandidate(int page = 1, int pageSize = 6)
        {
            var candidates = new List<CandidateInfoViewModel>();
            try
            {
                var candTask = _httpClient.GetAsync("api/CandidateInfo");
                var userTask = _httpClient.GetAsync("api/User");
                var appTask = _httpClient.GetAsync("api/JobApplication");
                var schedTask = _httpClient.GetAsync("api/InterviewSchedule");
                var postTask = _httpClient.GetAsync("api/JobPosting");

                await Task.WhenAll(candTask, userTask, appTask, schedTask, postTask);

                if (!candTask.Result.IsSuccessStatusCode
                 || !userTask.Result.IsSuccessStatusCode
                 || !appTask.Result.IsSuccessStatusCode
                 || !schedTask.Result.IsSuccessStatusCode
                 || !postTask.Result.IsSuccessStatusCode)
                {
                    return View(candidates);
                }

                var candList = JsonConvert.DeserializeObject<List<CandidateInfoViewModel>>(
                    await candTask.Result.Content.ReadAsStringAsync()) ?? new();
                var users = JsonConvert.DeserializeObject<List<UserViewModel>>(
                    await userTask.Result.Content.ReadAsStringAsync()) ?? new();
                var apps = JsonConvert.DeserializeObject<List<JobApplicationViewModel>>(
                    await appTask.Result.Content.ReadAsStringAsync()) ?? new();
                var schedules = JsonConvert.DeserializeObject<List<InterviewScheduleViewModel>>(
                    await schedTask.Result.Content.ReadAsStringAsync()) ?? new();
                var posts = JsonConvert.DeserializeObject<List<JobPostingViewModel>>(
                    await postTask.Result.Content.ReadAsStringAsync()) ?? new();

                foreach (var a in apps)
                {
                    a.JobTitle = posts
                        .FirstOrDefault(p => p.IdJobPost == a.IdJobPost)?
                        .Title ?? "Không xác định";
                }

                candidates = candList
                    .Where(c => users.Any(u => u.IdUser == c.IdUser && u.IdRole == "role2"))
                    .Select(c =>
                    {
                        c.User = users.First(u => u.IdUser == c.IdUser);
                        var myApps = apps.Where(a => a.IdUser == c.IdUser).ToList();
                        c.InterviewSchedules = schedules
                            .Where(s => myApps.Any(a => a.IdJobPost == s.IdJobPost))
                            .Select(s =>
                            {
                                var app = myApps.First(a => a.IdJobPost == s.IdJobPost);
                                return new InterviewScheduleViewModel
                                {
                                    IdSchedule = s.IdSchedule,
                                    IdJobPost = s.IdJobPost,
                                    IdUser = s.IdUser,
                                    InterviewDate = s.InterviewDate,
                                    InterviewMode = s.InterviewMode,
                                    Location = s.Location,
                                    Interviewer = s.Interviewer,
                                    Note = s.Note,
                                    ApplicationStatus = app.ApplicationStatus,
                                    CandidateName = c.User.UserName,
                                    CandidateEmail = c.User.Email,
                                    JobTitle = app.JobTitle
                                };
                            })
                            .ToList();
                        return c;
                    })
                    .ToList();

                var appsRole2 = candList
                    .Where(a => users.Any(u => u.IdUser == a.IdUser && u.IdRole == "role2"))
                    .ToList();
                ViewBag.TotalApplications = appsRole2.Count;
                ViewBag.PendingApplications = appsRole2.Count(a => a.User.AccountStatus.Equals("suspended", StringComparison.OrdinalIgnoreCase));
                ViewBag.AcceptedApplications = appsRole2.Count(a => a.User.AccountStatus.Equals("active", StringComparison.OrdinalIgnoreCase));
                ViewBag.RejectedApplications = appsRole2.Count(a => a.User.AccountStatus.Equals("inactive", StringComparison.OrdinalIgnoreCase));
            }
            catch (Exception ex)
            {
                Console.WriteLine("Lỗi khi lấy danh sách ứng viên: " + ex.Message);
            }

            int totalItems = candidates.Count;
            int totalPages = (int)Math.Ceiling((double)totalItems / pageSize);
            page = Math.Clamp(page, 1, totalPages == 0 ? 1 : totalPages);

            var paginatedCandidates = candidates
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToList();

            ViewBag.CurrentPage = page;
            ViewBag.TotalPages = totalPages;

            return View(paginatedCandidates);
        }


        public async Task<IActionResult> Applications(int page = 1, int pageSize = 10)
        {
            List<JobApplicationViewModel> applications = new();
            List<UserViewModel> users = new();
            List<JobPostingViewModel> jobPosts = new();

            try
            {
                var appResponse = await _httpClient.GetAsync("api/JobApplication");
                var userResponse = await _httpClient.GetAsync("api/User");
                var jobResponse = await _httpClient.GetAsync("api/JobPosting");

                if (appResponse.IsSuccessStatusCode)
                {
                    var json = await appResponse.Content.ReadAsStringAsync();
                    applications = JsonConvert.DeserializeObject<List<JobApplicationViewModel>>(json) ?? new();
                }

                if (userResponse.IsSuccessStatusCode)
                {
                    var userJson = await userResponse.Content.ReadAsStringAsync();
                    users = JsonConvert.DeserializeObject<List<UserViewModel>>(userJson) ?? new();
                }

                if (jobResponse.IsSuccessStatusCode)
                {
                    var jobJson = await jobResponse.Content.ReadAsStringAsync();
                    jobPosts = JsonConvert.DeserializeObject<List<JobPostingViewModel>>(jobJson) ?? new();
                }

                foreach (var app in applications)
                {
                    var user = users.FirstOrDefault(u => u.IdUser == app.IdUser);
                    var job = jobPosts.FirstOrDefault(j => j.IdJobPost == app.IdJobPost);

                    app.CandidateName = user?.UserName ?? "Không rõ";
                    app.JobTitle = job?.Title ?? "Không rõ";
                    app.CompanyName = job?.Company?.CompanyName ?? "Không rõ";
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Lỗi lấy danh sách ứng tuyển: " + ex.Message);
            }

            int totalItems = applications.Count;
            int totalPages = (int)Math.Ceiling((double)totalItems / pageSize);

            var paginatedApps = applications
                .OrderByDescending(a => a.SubmittedAt)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToList();

            ViewBag.CurrentPage = page;
            ViewBag.TotalPages = totalPages;

            return View(paginatedApps);

        }

        [HttpGet]
        public async Task<IActionResult> Edit(string idUser, string idJobPost)
        {
            if (string.IsNullOrEmpty(idUser) || string.IsNullOrEmpty(idJobPost))
                return NotFound();

            var appResponse = await _httpClient.GetAsync($"api/JobApplication/{idJobPost}/{idUser}");
            if (!appResponse.IsSuccessStatusCode)
                return NotFound();

            var appJson = await appResponse.Content.ReadAsStringAsync();
            var app = JsonConvert.DeserializeObject<JobAppViewModel>(appJson);
            if (app == null)
                return NotFound();

            var userResponse = await _httpClient.GetAsync($"api/User/{idUser}");
            var user = userResponse.IsSuccessStatusCode
                ? JsonConvert.DeserializeObject<UserViewModel>(await userResponse.Content.ReadAsStringAsync())
                : null;

            var jobResponse = await _httpClient.GetAsync($"api/JobPosting/{idJobPost}");
            var job = jobResponse.IsSuccessStatusCode
                ? JsonConvert.DeserializeObject<JobPostingViewModel>(await jobResponse.Content.ReadAsStringAsync())
                : null;

            app.CandidateName = user?.UserName ?? "Không rõ";
            app.JobTitle = job?.Title ?? "Không rõ";
            app.CompanyName = job?.Company?.CompanyName ?? "Không rõ";
            app.JobDescription = job?.Description ?? "Không rõ";
            app.CandidateEmail = user?.Email ?? "Không rõ";
            app.CandidatePhone = user?.PhoneNumber ?? "Không rõ";

            return View(app);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(JobAppViewModel model)
        {
            if (!ModelState.IsValid)
                return View(model);

            var payload = new
            {
                applicationStatus = model.ApplicationStatus,
                //note = model.Note
            };

            var resp = await _httpClient.PutAsJsonAsync(
                $"/api/JobApplication/{model.IdJobPost}/{model.IdUser}", payload);

            if (resp.IsSuccessStatusCode)
            {
                TempData["Success"] = "Cập nhật thành công!";
                return RedirectToAction("Applications");
            }

            TempData["Error"] = "Cập nhật thất bại!";
            return View(model);
        }

        [HttpPost]
        public async Task<IActionResult> DeleteApplication(string idUser, string idJobPost)
        {
            if (string.IsNullOrEmpty(idUser) || string.IsNullOrEmpty(idJobPost))
                return Json(new { success = false, message = "Thiếu thông tin." });

            var resp = await _httpClient.DeleteAsync($"/api/JobApplication/{idJobPost}/{idUser}");

            if (resp.IsSuccessStatusCode)
                return Json(new { success = true, message = "Xóa thành công!" });

            return Json(new { success = false, message = "Xóa thất bại!" });
        }


        [HttpGet]
        public async Task<IActionResult> DetailsApplication(string idUser, string idJobPost)
        {
            if (string.IsNullOrEmpty(idJobPost))
                return NotFound();

            var appResponse = await _httpClient.GetAsync($"api/JobApplication/jobposting/{idJobPost}");
            if (!appResponse.IsSuccessStatusCode)
                return NotFound();

            var appJson = await appResponse.Content.ReadAsStringAsync();
            JobAppViewModel app;

            if (appJson.TrimStart().StartsWith("["))
            {
                var apps = JsonConvert.DeserializeObject<List<JobAppViewModel>>(appJson);
                app = apps?.FirstOrDefault();
            }
            else
            {
                app = JsonConvert.DeserializeObject<JobAppViewModel>(appJson);
            }

            if (app == null)
                return NotFound();

            var candidateResp = await _httpClient.GetAsync($"api/CandidateInfo/{idUser}");
            if (!candidateResp.IsSuccessStatusCode)
                return NotFound();

            var candidateJson = await candidateResp.Content.ReadAsStringAsync();
            CandidateInfoViewModel candidate;

            if (candidateJson.TrimStart().StartsWith("["))
            {
                var candidates = JsonConvert.DeserializeObject<List<CandidateInfoViewModel>>(candidateJson);
                candidate = candidates?.FirstOrDefault();
            }
            else
            {
                candidate = JsonConvert.DeserializeObject<CandidateInfoViewModel>(candidateJson);
            }

            var userResponse = await _httpClient.GetAsync($"api/User/{idUser}");
            UserViewModel user = null;
            if (userResponse.IsSuccessStatusCode)
            {
                var userJson = await userResponse.Content.ReadAsStringAsync();
                user = JsonConvert.DeserializeObject<UserViewModel>(userJson);
            }

            var jobResponse = await _httpClient.GetAsync($"api/JobPosting/{idJobPost}");
            JobPostingViewModel job = null;
            if (jobResponse.IsSuccessStatusCode)
            {
                var jobJson = await jobResponse.Content.ReadAsStringAsync();
                job = JsonConvert.DeserializeObject<JobPostingViewModel>(jobJson);
            }

            app.CandidateName = user?.UserName ?? "Không rõ";
            app.JobTitle = job?.Title ?? "Không rõ";
            app.CompanyName = job?.Company?.CompanyName ?? "Không rõ";
            app.JobDescription = job?.Description ?? "Không rõ";
            app.CandidateEmail = user?.Email ?? "Không rõ";
            app.CandidatePhone = user?.PhoneNumber ?? "Không rõ";

            return View(app);
        }

        public IActionResult TopCandidates()
        {
            return View();
        }

        [HttpGet]
        public async Task<IActionResult> Details(string id)
        {
            if (string.IsNullOrEmpty(id))
                return BadRequest();

            var httpClient = new HttpClient();
            httpClient.BaseAddress = new Uri("http://localhost:5281/");

            var candidateResponse = await httpClient.GetAsync($"api/CandidateInfo/{id}");
            if (!candidateResponse.IsSuccessStatusCode)
                return NotFound();

            var candidateJson = await candidateResponse.Content.ReadAsStringAsync();
            var candidate = JsonConvert.DeserializeObject<CandidateInfoViewModel>(candidateJson);
            if (candidate == null || candidate.IdUser != id)
                return NotFound();

            var userResponse = await httpClient.GetAsync($"api/User/{id}");
            if (userResponse.IsSuccessStatusCode)
            {
                var userJson = await userResponse.Content.ReadAsStringAsync();
                var user = JsonConvert.DeserializeObject<UserViewModel>(userJson);
                candidate.User = user;
            }

            var resumeResponse = await httpClient.GetAsync($"api/Resume/{id}");
            if (resumeResponse.IsSuccessStatusCode)
            {
                var resumeListJson = await resumeResponse.Content.ReadAsStringAsync();

                var resumes = JsonConvert.DeserializeObject<List<ResumeViewModel>>(resumeListJson);
                if (resumes != null && resumes.Any())
                {
                    var defaultResume = resumes
                        .FirstOrDefault(r => r.IsDefault.HasValue && r.IsDefault.Value == 1)
                        ?? resumes.First();

                    candidate.ResumeUrl = defaultResume.FileUrl;
                }
            }
            return View(candidate);
        }

        [HttpGet]
        public async Task<IActionResult> Update(string id)
        {
            var candidateRes = await _httpClient.GetAsync($"api/CandidateInfo/{id}");
            var userRes = await _httpClient.GetAsync($"api/User/{id}");

            if (!candidateRes.IsSuccessStatusCode || !userRes.IsSuccessStatusCode)
                return NotFound();

            var candidateJson = await candidateRes.Content.ReadAsStringAsync();
            var userJson = await userRes.Content.ReadAsStringAsync();

            var model = JsonConvert.DeserializeObject<CandidateInfoUpdateViewModel>(candidateJson);
            var user = JsonConvert.DeserializeObject<UserViewModel>(userJson);

            model.User = user;

            if (string.IsNullOrEmpty(model.User.RoleName))
            {
                if (model.User.IdRole == "role2")
                    model.User.RoleName = "Candidate";
                else if (model.User.IdRole == "role1")
                    model.User.RoleName = "Recruiter";
            }

            return View(model);
        }


        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Update(CandidateInfoUpdateViewModel model)
        {
            // Validate role cho User nếu thiếu
            if (string.IsNullOrEmpty(model.User.RoleName))
            {
                if (model.User.IdRole == "role2") model.User.RoleName = "Candidate";
                else if (model.User.IdRole == "role1") model.User.RoleName = "Recruiter";
            }

            if (!ModelState.IsValid)
            {
                return View(model);
            }

            // 1. Serialize đúng object CandidateInfo
            var candidateInfo = new
            {
                idUser = model.IdUser,
                workPosition = model.WorkPosition,
                ratingScore = model.RatingScore,
                universityName = model.UniversityName,
                educationLevel = model.EducationLevel,
                experienceYears = model.ExperienceYears,
                skills = model.Skills
            };
            var candidateContent = new StringContent(JsonConvert.SerializeObject(candidateInfo), Encoding.UTF8, "application/json");
            var candidateRes = await _httpClient.PutAsync($"/api/CandidateInfo/{model.IdUser}", candidateContent);

            // 2. Serialize đúng object User (không gửi role object nếu API không cần)
            var userInfo = new
            {
                idUser = model.User.IdUser,
                userName = model.User.UserName,
                email = model.User.Email,
                phoneNumber = model.User.PhoneNumber,
                idRole = model.User.IdRole,
                roleName = model.User.RoleName,
                accountStatus = model.User.AccountStatus,
                avatarUrl = model.User.AvatarUrl,
                address = model.User.Address,
                createdAt = model.User.CreatedAt,
                // Thêm các trường cần thiết khác nếu API yêu cầu
            };
            var userContent = new StringContent(JsonConvert.SerializeObject(userInfo), Encoding.UTF8, "application/json");
            var userRes = await _httpClient.PutAsync($"/api/User/{model.IdUser}", userContent);

            return RedirectToAction("ListCandidate");
        }


    }
}
