using Microsoft.AspNetCore.Mvc;
using HuitWorks.RecruiterWeb.Models;
using HuitWorks.RecruiterWeb.Models.ViewModel;
using Newtonsoft.Json;
using System.Security.Claims;

namespace HuitWorks.RecruiterWeb.Controllers
{
    public class NotificationController : Controller
    {
        private readonly HttpClient _httpClient;

        public NotificationController()
        {
            _httpClient = new HttpClient
            {
                BaseAddress = new Uri("http://localhost:5281/")
            };
        }
        // GET: Notification
        public async Task<IActionResult> Index(string type = "all", int page = 1, int pageSize = 10)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (string.IsNullOrEmpty(userId))
                return RedirectToAction("Login", "Auth");

            var response = await _httpClient.GetAsync("/api/Notification");
            if (!response.IsSuccessStatusCode)
                return View(new List<NotificationViewModel>());

            var json = await response.Content.ReadAsStringAsync();
            var allNotifications = JsonConvert.DeserializeObject<List<NotificationViewModel>>(json) ?? new List<NotificationViewModel>();

            var notifications = allNotifications.Where(n => n.IdUser == userId).ToList();

            if (!string.IsNullOrEmpty(type) && type.ToLower() != "all")
            {
                notifications = notifications.Where(n => n.Type.ToLower().Contains(type.ToLower())).ToList();
            }

            var totalItems = notifications.Count();
            var totalPages = (int)Math.Ceiling(totalItems / (double)pageSize);

            var pagedNotifications = notifications
                .OrderByDescending(n => n.CreatedAt)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToList();

            ViewBag.CurrentPage = page;
            ViewBag.TotalPages = totalPages;
            ViewBag.Type = type;
            ViewBag.PageSize = pageSize;

            return View(pagedNotifications);
        }

        // Phương thức để lấy dữ liệu mẫu
        private List<Notification> GetSampleNotifications()
        {
            return new List<Notification>
            {
                new Notification
                {
                    Id = 1,
                    Title = "Cập nhật tính năng mới",
                    Message = "Chúng tôi vừa cập nhật tính năng phân tích CV ứng viên bằng AI. Giờ đây, bạn có thể nhận được đề xuất ứng viên phù hợp nhất với yêu cầu tuyển dụng của mình.",
                    CreatedAt = DateTime.Now,
                    Type = "System",
                    Status = NotificationStatus.Unread,
                    ActionUrl = "/features/ai-analysis"
                },
                new Notification
                {
                    Id = 2,
                    Title = "Tin tuyển dụng đã được duyệt",
                    Message = "Tin tuyển dụng \"Senior Full-stack Developer\" của bạn đã được phê duyệt và đăng công khai. Tin tuyển dụng sẽ được hiển thị trong 30 ngày.",
                    CreatedAt = DateTime.Now.AddDays(-1),
                    Type = "Job",
                    Status = NotificationStatus.Unread,
                    ActionUrl = "/jobs/details/123"
                },
                new Notification
                {
                    Id = 3,
                    Title = "Gói dịch vụ sắp hết hạn",
                    Message = "Gói Premium của bạn sẽ hết hạn sau 3 ngày nữa. Vui lòng gia hạn để tiếp tục sử dụng đầy đủ các tính năng dành cho nhà tuyển dụng.",
                    CreatedAt = DateTime.Now.AddDays(-3),
                    Type = "Payment",
                    Status = NotificationStatus.Read,
                    ActionUrl = "/subscription/renew"
                },
                new Notification
                {
                    Id = 4,
                    Title = "Thanh toán không thành công",
                    Message = "Thanh toán cho đơn hàng #25689 không thành công. Vui lòng kiểm tra lại thông tin thanh toán của bạn và thử lại.",
                    CreatedAt = DateTime.Now.AddDays(-6),
                    Type = "Payment",
                    Status = NotificationStatus.Read,
                    ActionUrl = "/payment/retry/25689"
                },
                // Thêm nhiều thông báo mẫu khác nếu cần
            };
        }

        // Đánh dấu thông báo đã đọc
        [HttpPost]
        public IActionResult MarkAsRead(int id)
        {
            // TODO: Cập nhật trạng thái đã đọc cho thông báo trong cơ sở dữ liệu

            return RedirectToAction(nameof(Index));
        }

        // Xóa thông báo
        [HttpPost]
        public IActionResult Delete(int id)
        {
            // TODO: Xóa thông báo khỏi cơ sở dữ liệu

            return RedirectToAction(nameof(Index));
        }
    }
}
