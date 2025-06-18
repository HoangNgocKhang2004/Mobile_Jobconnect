using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using HuitWorks.AdminWeb.Models.ViewModels;

namespace HuitWorks.AdminWeb.Controllers
{
    public class CompanyController : Controller
    {
        private readonly HttpClient _httpClient;

        public CompanyController()
        {
            _httpClient = new HttpClient();
            _httpClient.BaseAddress = new Uri("http://localhost:5281"); // Link API base
        }
        public async Task<IActionResult> Index(int page = 1, int pageSize = 7)
        {
            var response = await _httpClient.GetAsync("/api/Companies");
            if (!response.IsSuccessStatusCode)
            {
                ViewBag.Error = "Không lấy được dữ liệu công ty!";
                return View(new List<CompanyViewModel>());
            }

            var json = await response.Content.ReadAsStringAsync();
            var companies = JsonConvert
                .DeserializeObject<List<CompanyViewModel>>(json)
              ?? new List<CompanyViewModel>();

            // ── Tính số liệu cho các card ─────────────────────────────────────────
            ViewBag.TotalAccounts = companies.Count;
            ViewBag.PendingAccounts = companies.Count(c =>
                                           string.Equals(c.Status, "inactive", StringComparison.OrdinalIgnoreCase));
            ViewBag.EmployersCount = companies.Count(c =>
                                           string.Equals(c.Status, "active", StringComparison.OrdinalIgnoreCase));
            ViewBag.ServicesUsedCount = companies.Count(c => c.IsFeatured == 1);

            // ── Phân trang ────────────────────────────────────────────────────────
            int totalItems = companies.Count;
            int totalPages = (int)Math.Ceiling((double)totalItems / pageSize);

            var pagedCompanies = companies
                .OrderByDescending(c => c.IsFeatured)  // Nổi bật lên đầu
                .ThenBy(c => c.CompanyName)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToList();

            ViewBag.CurrentPage = page;
            ViewBag.TotalPages = totalPages;
            ViewBag.PageSize = pageSize;

            return View(pagedCompanies);
        }

        // GET: Edit company
        [HttpGet]
        public async Task<IActionResult> Edit(string id)
        {
            var res = await _httpClient.GetAsync($"/api/Companies/{id}");
            if (!res.IsSuccessStatusCode) return NotFound();
            var json = await res.Content.ReadAsStringAsync();
            var model = JsonConvert.DeserializeObject<CompanyViewModel>(json);
            return View(model);
        }

        // POST: Edit company
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(CompanyViewModel model)
        {
            if (!ModelState.IsValid) return View(model);

            var res = await _httpClient.PutAsJsonAsync($"/api/Companies/{model.IdCompany}", model);
            if (res.IsSuccessStatusCode)
                return RedirectToAction("Index");

            ModelState.AddModelError("", "Không thể cập nhật công ty.");
            return View(model);
        }

        // POST: Company/Suspend/{id}
        [HttpPost]
        public async Task<IActionResult> Suspend(string id)
        {
            // Lấy chi tiết company
            var res = await _httpClient.GetAsync($"/api/Companies/{id}");
            if (!res.IsSuccessStatusCode) return NotFound();
            var json = await res.Content.ReadAsStringAsync();
            var company = JsonConvert.DeserializeObject<CompanyViewModel>(json);
            if (company == null) return NotFound();

            // Đổi trạng thái và gửi lại bằng PUT
            company.Status = "inactive";
            var putRes = await _httpClient.PutAsJsonAsync($"/api/Companies/{id}", company);
            return RedirectToAction("Index");
        }

        // POST: Company/Activate/{id}
        [HttpPost]
        public async Task<IActionResult> Activate(string id)
        {
            var res = await _httpClient.GetAsync($"/api/Companies/{id}");
            if (!res.IsSuccessStatusCode) return NotFound();
            var json = await res.Content.ReadAsStringAsync();
            var company = JsonConvert.DeserializeObject<CompanyViewModel>(json);
            if (company == null) return NotFound();

            company.Status = "active";
            var putRes = await _httpClient.PutAsJsonAsync($"/api/Companies/{id}", company);
            return RedirectToAction("Index");
        }

    }
}
