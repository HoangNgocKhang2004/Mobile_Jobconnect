using HuitWorks.RecruiterWeb.Models.ViewModel;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using HuitWorks.RecruiterWeb.Models.Dtos;

namespace HuitWorks.RecruiterWeb.Controllers
{
    public class ContactController : Controller
    {
        private readonly HttpClient _httpClient;
        public ContactController()
        {
            _httpClient = new HttpClient
            {
                BaseAddress = new Uri("http://localhost:5281/")
            };
        }

        // GET: /Contact/Index
        public async Task<IActionResult> Index()
        {
            var model = new ContactViewModel();

            // Lấy danh sách ReportTypes để hiển thị dropdown
            try
            {
                var respTypes = await _httpClient.GetAsync("api/ReportType");
                if (respTypes.IsSuccessStatusCode)
                {
                    model.ReportTypes = await respTypes.Content.ReadFromJsonAsync<List<ReportTypeDto>>()
                                        ?? new List<ReportTypeDto>();
                }
            }
            catch
            {
                model.ReportTypes = new List<ReportTypeDto>();
            }

            return View(model);
        }

        // POST: /Contact/Index
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Index(ContactViewModel model)
        {
            try
            {
                var respTypes = await _httpClient.GetAsync("api/ReportType");
                if (respTypes.IsSuccessStatusCode)
                {
                    model.ReportTypes = await respTypes.Content
                                              .ReadFromJsonAsync<List<ReportTypeDto>>()
                                         ?? new List<ReportTypeDto>();
                }
                else
                {
                    model.ReportTypes = new List<ReportTypeDto>();
                }
            }
            catch
            {
                model.ReportTypes = new List<ReportTypeDto>();
            }

            if (!ModelState.IsValid)
            {
                return View(model);
            }

            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (string.IsNullOrEmpty(userId))
                return RedirectToAction("Login", "Auth");

            var createReportPayload = new
            {
                UserId = userId,
                ReportTypeId = model.SelectedReportTypeId,
                Title = model.Title,
                Content = model.Content
            };

            try
            {
                var postResp = await _httpClient.PostAsJsonAsync("api/Report", createReportPayload);
                if (postResp.IsSuccessStatusCode)
                {
                    model.IsSuccess = true;
                    model.Message = "Cảm ơn bạn đã gửi báo cáo! Chúng tôi sẽ xử lý sớm nhất.";
                    // ModelState.Clear();
                    // model.Title = string.Empty;
                    // model.Content = string.Empty;
                    // model.SelectedReportTypeId = 0;
                }
                else
                {
                    model.IsSuccess = false;
                    model.Message = "Gửi báo cáo thất bại. Vui lòng thử lại sau.";
                }
            }
            catch
            {
                model.IsSuccess = false;
                model.Message = "Không thể kết nối tới máy chủ. Vui lòng thử lại sau.";
            }

            return View(model);
        }

    }
}
