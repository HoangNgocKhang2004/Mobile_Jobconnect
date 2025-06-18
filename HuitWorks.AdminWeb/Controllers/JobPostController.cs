using HuitWorks.AdminWeb.Models;
using HuitWorks.AdminWeb.Models.ViewModels;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System.Text;

namespace HuitWorks.AdminWeb.Controllers
{
    public class JobPostController : Controller
    {
        private readonly HttpClient _httpClient;

        public JobPostController()
        {
            _httpClient = new HttpClient();
            _httpClient.BaseAddress = new Uri("http://localhost:5281");
        }

        public async Task<IActionResult> Index(int page = 1, int pageSize = 6)
        {
            List<JobPostingVM> jobs = new();
            List<JobApplicationDto> applications = new();

            try
            {
                // 1) Lấy tất cả job postings
                var jobResponse = await _httpClient.GetAsync("/api/JobPosting/all");
                if (jobResponse.IsSuccessStatusCode)
                {
                    var jobJson = await jobResponse.Content.ReadAsStringAsync();
                    jobs = JsonConvert
                        .DeserializeObject<List<JobPostingVM>>(jobJson)
                       ?? new List<JobPostingVM>();
                }

                // 2) Tự động đóng các tin quá hạn
                foreach (var job in jobs
                    .Where(j => j.ApplicationDeadline < DateTime.Now
                             && !j.PostStatus.Equals("Closed", StringComparison.OrdinalIgnoreCase)))
                {
                    var dto = new { postStatus = "Closed" };
                    var content = new StringContent(
                        JsonConvert.SerializeObject(dto),
                        Encoding.UTF8,
                        "application/json");

                    var patchReq = new HttpRequestMessage(HttpMethod.Patch,
                        $"/api/JobPosting/{job.IdJobPost}/status")
                    { Content = content };

                    var patchResp = await _httpClient.SendAsync(patchReq);
                    if (patchResp.IsSuccessStatusCode)
                        job.PostStatus = "Closed";
                }

                // 3) Lấy applications
                var appResponse = await _httpClient.GetAsync("/api/JobApplication");
                if (appResponse.IsSuccessStatusCode)
                {
                    var appJson = await appResponse.Content.ReadAsStringAsync();
                    applications = JsonConvert
                        .DeserializeObject<List<JobApplicationDto>>(appJson)
                       ?? new List<JobApplicationDto>();
                }
                ViewBag.Applications = applications;

                // ─── Tính số liệu cho card ───────────────────────────────
                int totalPosts = jobs.Count;
                int closedPosts = jobs.Count(j => j.PostStatus.Equals("Closed", StringComparison.OrdinalIgnoreCase));
                int pendingPosts = jobs.Count(j => j.PostStatus.Equals("Pending", StringComparison.OrdinalIgnoreCase));
                int activePosts = totalPosts - closedPosts - pendingPosts;

                ViewBag.TotalPosts = totalPosts;
                ViewBag.ActivePosts = activePosts;    // Đang hiển thị
                ViewBag.PendingPosts = pendingPosts;   // Chờ duyệt
                ViewBag.ClosedPosts = closedPosts;    // Tạm dừng / Từ chối

                // 4) Sắp xếp, phân trang
                var paginatedJobs = jobs
                    .OrderByDescending(j => j.CreatedAt)
                    .Skip((page - 1) * pageSize)
                    .Take(pageSize)
                    .ToList();

                int totalItems = jobs.Count;
                int totalPages = (int)Math.Ceiling((double)totalItems / pageSize);

                ViewBag.CurrentPage = page;
                ViewBag.TotalPages = totalPages;

                return View(paginatedJobs);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error fetching data: " + ex.Message);
                return View(new List<JobPostingVM>());
            }
        }


        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ChangeStatus(string idJobPost, string newStatus, int page = 1)
        {
            // Gọi API lấy job hiện tại
            var res = await _httpClient.GetAsync($"/api/JobPosting/{idJobPost}");
            if (!res.IsSuccessStatusCode)
            {
                TempData["Error"] = "Không tìm thấy bài đăng!";
                return RedirectToAction("Index", new { page });
            }
            var job = await res.Content.ReadFromJsonAsync<JobPostingVM>();
            if (job == null)
            {
                TempData["Error"] = "Không tìm thấy bài đăng!";
                return RedirectToAction("Index", new { page });
            }

            // Cập nhật trạng thái
            job.PostStatus = newStatus;
            // Gửi API cập nhật
            var updateRes = await _httpClient.PutAsJsonAsync($"/api/JobPosting/{idJobPost}", job);
            if (updateRes.IsSuccessStatusCode)
            {
                TempData["Success"] = "Cập nhật trạng thái thành công!";
            }
            else
            {
                TempData["Error"] = "Cập nhật trạng thái thất bại!";
            }

            return RedirectToAction("Index", new { page });
        }


        public async Task<IActionResult> Details(string id)
        {
            if (string.IsNullOrEmpty(id))
                return NotFound();

            JobPostingViewModel jobPost = null;

            try
            {
                var response = await _httpClient.GetAsync($"api/jobposting/{id}");
                if (response.IsSuccessStatusCode)
                {
                    var json = await response.Content.ReadAsStringAsync();
                    jobPost = JsonConvert.DeserializeObject<JobPostingViewModel>(json);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error fetching job post: " + ex.Message);
            }

            if (jobPost == null)
                return NotFound();

            return View(jobPost);
        }
    }
}
