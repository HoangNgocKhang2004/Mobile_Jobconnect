using System.Diagnostics;
using HuitWorks.AdminWeb.Models;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using HuitWorks.AdminWeb.Models.ViewModels;

namespace HuitWorks.AdminWeb.Controllers
{
    public class HomeController : Controller
    {
        //private readonly ILogger<HomeController> _logger;

        //public HomeController(ILogger<HomeController> logger)
        //{
        //    _logger = logger;
        //}
        private readonly HttpClient _httpClient;

        public HomeController()
        {
            _httpClient = new HttpClient();
            _httpClient.BaseAddress = new Uri("http://localhost:5281");
        }

        public async Task<IActionResult> Index(int page = 1, int pageSize = 15)
        {
            List<JobPostingViewModel> jobs = new List<JobPostingViewModel>();
            List<JobApplicationDto> applications = new List<JobApplicationDto>();

            try
            {
                var jobResponse = await _httpClient.GetAsync("/api/JobPosting");
                if (jobResponse.IsSuccessStatusCode)
                {
                    var jobJson = await jobResponse.Content.ReadAsStringAsync();
                    jobs = JsonConvert.DeserializeObject<List<JobPostingViewModel>>(jobJson) ?? new List<JobPostingViewModel>();
                }

                var appResponse = await _httpClient.GetAsync("/api/JobApplication");
                if (appResponse.IsSuccessStatusCode)
                {
                    var appJson = await appResponse.Content.ReadAsStringAsync();
                    applications = JsonConvert.DeserializeObject<List<JobApplicationDto>>(appJson) ?? new List<JobApplicationDto>();
                }

                ViewBag.Applications = applications;

                // Phân trang
                int totalItems = jobs.Count;
                int totalPages = (int)Math.Ceiling((double)totalItems / pageSize);
                var paginatedJobs = jobs
                    .OrderByDescending(j => j.CreatedAt)
                    .Skip((page - 1) * pageSize)
                    .Take(pageSize)
                    .ToList();

                ViewBag.CurrentPage = page;
                ViewBag.TotalPages = totalPages;

                // Lấy danh sách phỏng vấn sắp tới
                var interviewList = new List<InterviewScheduleViewModel>();
                var intvRes = await _httpClient.GetAsync("/api/InterviewSchedule");
                if (intvRes.IsSuccessStatusCode)
                {
                    var intvJson = await intvRes.Content.ReadAsStringAsync();
                    interviewList = JsonConvert.DeserializeObject<List<InterviewScheduleViewModel>>(intvJson)
                        ?? new List<InterviewScheduleViewModel>();
                }

                // Lọc các phỏng vấn SẮP TỚI (>= hiện tại)
                var upcomingInterviews = interviewList
                    .Where(i => i.InterviewDate >= DateTime.Now)
                    .OrderBy(i => i.InterviewDate)
                    .Take(3) // lấy 3 lịch gần nhất
                    .ToList();

                ViewBag.UpcomingInterviews = upcomingInterviews;

                return View(paginatedJobs);
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error fetching data: " + ex.Message);
                return View(new List<JobPostingViewModel>());
            }
        }

        public IActionResult Privacy()
        {
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }

        public IActionResult Help()
        {
            return View();
        }
    }
}
