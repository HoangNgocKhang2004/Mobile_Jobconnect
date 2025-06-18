using Microsoft.AspNetCore.Mvc;
using HuitWorks.AdminWeb.Models;
using HuitWorks.AdminWeb.Models.ViewModels;
using System.Text.Json;

namespace HuitWorks.AdminWeb.Controllers
{
    public class PaymentController : Controller
    {
        private readonly HttpClient _httpClient;

        public PaymentController()
        {
            _httpClient = new HttpClient { BaseAddress = new Uri("http://localhost:5281") };
        }
        // GET: /Payment
        public async Task<IActionResult> Index(int page = 1, int pageSize = 6)
        {
            // 1) Đọc toàn bộ transactions, users, packages
            var transactions = await _httpClient
                .GetFromJsonAsync<List<JobTransaction>>("/api/JobTransaction")
              ?? new List<JobTransaction>();

            var users = await _httpClient
                .GetFromJsonAsync<List<UserViewModel>>("/api/User")
              ?? new List<UserViewModel>();

            var packagesResponse = await _httpClient.GetAsync("/api/SubscriptionPackage");
            var packages = new List<SubscriptionPackage>();
            if (packagesResponse.IsSuccessStatusCode)
            {
                var json = await packagesResponse.Content.ReadAsStringAsync();
                packages = JsonSerializer.Deserialize<List<SubscriptionPackage>>(json,
                    new JsonSerializerOptions { PropertyNameCaseInsensitive = true })
                  ?? new List<SubscriptionPackage>();
            }

            // 2) Enrich tên user & package
            foreach (var t in transactions)
            {
                t.UserName = users.FirstOrDefault(u => u.IdUser == t.IdUser)?.UserName ?? "Không xác định";
                t.PackageName = packages.FirstOrDefault(p => p.IdPackage == t.IdPackage)?.PackageName
                               ?? "Không xác định";
            }

            // ─── 3) Tính các chỉ số cho 4 card ───────────────────────────

            // Tổng doanh thu (giả sử JobTransaction.Amount là decimal)
            decimal totalRevenue = transactions.Sum(t => t.Amount);

            // Giao dịch trong tháng (theo giờ máy chủ hoặc .ToLocalTime())
            var now = DateTime.Now;
            int monthlyCount = transactions.Count(t =>
                t.TransactionDate.ToLocalTime().Year == now.Year &&
                t.TransactionDate.ToLocalTime().Month == now.Month);

            // Dịch vụ đang hoạt động (giả sử Status == "Completed" nghĩa active)
            int activeServices = transactions.Count(t =>
                t.Status.Equals("Completed", StringComparison.OrdinalIgnoreCase));

            // Dịch vụ ngừng hoạt động = tổng - active
            int inactiveServices = transactions.Count - activeServices;

            ViewBag.TotalRevenue = totalRevenue;
            ViewBag.MonthlyTransactions = monthlyCount;
            ViewBag.ActiveServices = activeServices;
            ViewBag.InactiveServices = inactiveServices;

            // ─── 4) Phân trang & trả View ─────────────────────────────────

            int totalItems = transactions.Count;
            int totalPages = (int)Math.Ceiling((double)totalItems / pageSize);
            page = Math.Clamp(page, 1, totalPages == 0 ? 1 : totalPages);

            var paged = transactions
                .OrderByDescending(t => t.TransactionDate)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToList();

            ViewBag.CurrentPage = page;
            ViewBag.TotalPages = totalPages;
            ViewBag.PageSize = pageSize;
            ViewBag.TotalItems = totalItems;

            return View(paged);
        }


        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Confirm(string id)
        {
            if (string.IsNullOrEmpty(id))
                return RedirectToAction("Index");

            var res = await _httpClient.GetAsync($"/api/JobTransaction/{id}");
            if (!res.IsSuccessStatusCode)
            {
                TempData["Error"] = "Không tìm thấy giao dịch!";
                return RedirectToAction("Index");
            }
            var tran = await res.Content.ReadFromJsonAsync<JobTransaction>();
            if (tran == null)
            {
                TempData["Error"] = "Không tìm thấy giao dịch!";
                return RedirectToAction("Index");
            }

            tran.Status = "Completed";

            var putRes = await _httpClient.PutAsJsonAsync($"/api/JobTransaction/{id}", tran);
            if (putRes.IsSuccessStatusCode)
                TempData["Success"] = "Giao dịch đã được xác nhận!";
            else
                TempData["Error"] = "Xác nhận giao dịch thất bại!";

            return RedirectToAction("Index");
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Reject(string id)
        {
            if (string.IsNullOrEmpty(id))
                return RedirectToAction("Index");

            var res = await _httpClient.GetAsync($"/api/JobTransaction/{id}");
            if (!res.IsSuccessStatusCode)
            {
                TempData["Error"] = "Không tìm thấy giao dịch!";
                return RedirectToAction("Index");
            }
            var tran = await res.Content.ReadFromJsonAsync<JobTransaction>();
            if (tran == null)
            {
                TempData["Error"] = "Không tìm thấy giao dịch!";
                return RedirectToAction("Index");
            }

            tran.Status = "Rejected";

            var putRes = await _httpClient.PutAsJsonAsync($"/api/JobTransaction/{id}", tran);
            if (putRes.IsSuccessStatusCode)
                TempData["Success"] = "Giao dịch đã bị từ chối!";
            else
                TempData["Error"] = "Từ chối giao dịch thất bại!";

            return RedirectToAction("Index");
        }


        // GET: /Payment/Details/{id}
        public async Task<IActionResult> Details(string id)
        {
            var transaction = await _httpClient.GetFromJsonAsync<JobTransaction>($"/api/JobTransaction/{id}");
            if (transaction == null) return NotFound();
            return View(transaction);
        }

        // GET: /Payment/Create
        public async Task<IActionResult> Create()
        {
            var packages = await _httpClient.GetFromJsonAsync<List<ServicePackageViewModel>>("/api/SubscriptionPackage");
            var users = await _httpClient.GetFromJsonAsync<List<UserViewModel>>("/api/User");
            ViewBag.Packages = packages;
            ViewBag.Users = users;
            return View(new JobTransaction());
        }

        // POST: /Payment/Create
        [HttpPost]
        public async Task<IActionResult> Create(JobTransaction model)
        {
            model.IdTransaction = Guid.NewGuid().ToString();
            model.TransactionDate = DateTime.Now;
            var response = await _httpClient.PostAsJsonAsync("/api/JobTransaction", model);
            if (response.IsSuccessStatusCode)
            {
                TempData["SuccessMessage"] = "Thêm giao dịch thành công!";
                return RedirectToAction(nameof(Index));
            }
            TempData["ErrorMessage"] = "Thêm giao dịch thất bại!";
            return RedirectToAction(nameof(Index));
        }
    }
}
