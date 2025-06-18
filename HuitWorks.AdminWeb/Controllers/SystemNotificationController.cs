using HuitWorks.AdminWeb.Models.ViewModels;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;

namespace HuitWorks.AdminWeb.Controllers
{
    public class SystemNotificationController : Controller
    {
        private readonly HttpClient _httpClient;

        public SystemNotificationController()
        {
            _httpClient = new HttpClient();
            _httpClient.BaseAddress = new Uri("http://localhost:5281");
        }

        public async Task<IActionResult> Index(int page = 1, int pageSize = 6)
        {
            List<NotificationViewModel> notifications = new();
            List<UserViewModel> users = new();

            try
            {
                var notiRes = await _httpClient.GetAsync("/api/Notification");
                var userRes = await _httpClient.GetAsync("/api/User");

                if (notiRes.IsSuccessStatusCode && userRes.IsSuccessStatusCode)
                {
                    var notiJson = await notiRes.Content.ReadAsStringAsync();
                    var userJson = await userRes.Content.ReadAsStringAsync();

                    notifications = JsonConvert.DeserializeObject<List<NotificationViewModel>>(notiJson) ?? new();

                    if (userJson.TrimStart().StartsWith("["))
                    {
                        users = JsonConvert.DeserializeObject<List<UserViewModel>>(userJson) ?? new();
                    }
                    else
                    {
                        var singleUser = JsonConvert.DeserializeObject<UserViewModel>(userJson);
                        if (singleUser != null)
                            users.Add(singleUser);
                    }

                    foreach (var noti in notifications)
                    {
                        var user = users.FirstOrDefault(u => u.IdUser == noti.IdUser);
                        noti.TargetName = user?.UserName ?? "Không rõ";
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("❌ Lỗi load notifications: " + ex.Message);
            }

            // Phân trang
            int totalItems = notifications.Count;
            int totalPages = (int)Math.Ceiling((double)totalItems / pageSize);
            page = Math.Max(1, Math.Min(page, totalPages > 0 ? totalPages : 1));

            var paginated = notifications
                .OrderByDescending(n => n.CreatedAt)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToList();

            ViewBag.CurrentPage = page;
            ViewBag.TotalPages = totalPages;
            ViewBag.PageSize = pageSize;
            ViewBag.TotalItems = totalItems;

            return View(paginated);
        }


        // GET: /SystemNotification/Create
        [HttpGet]
        public async Task<IActionResult> Create()
        {
            ViewBag.Users = await LoadUsersAsync();
            return View(new NotificationViewModel
            {
                DateTime = DateTime.Now  // đặt mặc định ngày giờ
            });
        }

        // POST: /SystemNotification/Create
        [HttpPost, ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(NotificationViewModel model)
        {
            ModelState.Remove(nameof(model.IdNotification));
            ModelState.Remove(nameof(model.TargetName));

            // 1. Gán các trường hệ thống từ đầu (trước khi check ModelState)
            if (string.IsNullOrEmpty(model.IdNotification))
                model.IdNotification = Guid.NewGuid().ToString();
            if (model.CreatedAt == default)
                model.CreatedAt = DateTime.UtcNow;
            model.IsRead = 0;

            // 2. Load users, gán TargetName
            var users = await LoadUsersAsync();
            model.TargetName = users.FirstOrDefault(u => u.IdUser == model.IdUser)?.UserName;
            ViewBag.Users = users;

            // 3. Nếu form có lỗi, trả lại view luôn với model đã gán
            if (!ModelState.IsValid)
            {
                return View(model);
            }

            // 4. Gửi POST lên API
            var response = await _httpClient.PostAsJsonAsync("/api/Notification", model);
            if (response.IsSuccessStatusCode)
            {
                // sau khi tạo thành công, quay về Index
                return RedirectToAction(nameof(Index));
            }

            // 5. Nếu API lỗi, show message và trả view
            ModelState.AddModelError("", "Tạo thông báo thất bại, vui lòng thử lại.");
            return View(model);
        }

        // Các action khác (Index, Edit, Delete…)…

        // Helper để load user list
        private async Task<List<UserViewModel>> LoadUsersAsync()
        {
            var list = new List<UserViewModel>();
            var res = await _httpClient.GetAsync("/api/User");
            if (res.IsSuccessStatusCode)
            {
                var json = await res.Content.ReadAsStringAsync();
                if (json.TrimStart().StartsWith("["))
                    list = JsonConvert.DeserializeObject<List<UserViewModel>>(json);
                else
                {
                    var single = JsonConvert.DeserializeObject<UserViewModel>(json);
                    if (single != null) list.Add(single);
                }
            }
            return list ?? new List<UserViewModel>();
        }

    }

}
