using HuitWorks.AdminWeb.Models.ViewModels;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System.Text;
using HuitWorks.AdminWeb.Models;

namespace HuitWorks.AdminWeb.Controllers
{
    public class UsersController : Controller
    {
        private readonly HttpClient _httpClient;

        public UsersController()
        {
            _httpClient = new HttpClient();
            _httpClient.BaseAddress = new Uri("http://localhost:5281");
        }

        public async Task<IActionResult> Index(int page = 1, int pageSize = 6)
        {
            var users = new List<UserViewModel>();

            try
            {
                // 1) Lấy users và roles
                var usersResponse = await _httpClient.GetAsync("/api/User");
                var rolesResponse = await _httpClient.GetAsync("/api/Roles");

                if (usersResponse.IsSuccessStatusCode && rolesResponse.IsSuccessStatusCode)
                {
                    var usersJson = await usersResponse.Content.ReadAsStringAsync();
                    var rolesJson = await rolesResponse.Content.ReadAsStringAsync();

                    users = JsonConvert
                        .DeserializeObject<List<UserViewModel>>(usersJson)
                           ?? new List<UserViewModel>();
                    var roles = JsonConvert
                        .DeserializeObject<List<RoleViewModel>>(rolesJson)
                           ?? new List<RoleViewModel>();

                    // 2) Gán RoleName
                    foreach (var u in users)
                    {
                        var r = roles.FirstOrDefault(x => x.IdRole == u.IdRole);
                        u.RoleName = r?.RoleName ?? "Không rõ";
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error fetching users: " + ex.Message);
            }

            // ─── 3) Tính số liệu cho 4 card ────────────────────────────────

            ViewBag.TotalUser = users.Count;
            ViewBag.CandidateCount = users.Count(u =>
                u.RoleName.Equals("Candidate", StringComparison.OrdinalIgnoreCase));
            ViewBag.RecruiterCount = users.Count(u =>
                u.RoleName.Equals("Recruiter", StringComparison.OrdinalIgnoreCase));
            ViewBag.PendingCount = users.Count(u =>
                !u.AccountStatus.Equals("active", StringComparison.OrdinalIgnoreCase));

            // ─── 4) Phân trang ─────────────────────────────────────────────

            int totalItems = users.Count;
            int totalPages = (int)Math.Ceiling((double)totalItems / pageSize);
            page = Math.Clamp(page, 1, totalPages == 0 ? 1 : totalPages);

            var paginatedUsers = users
                .OrderByDescending(u => u.AccountStatus) // hoặc tùy bạn sắp xếp
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToList();

            ViewBag.CurrentPage = page;
            ViewBag.TotalPages = totalPages;

            return View(paginatedUsers);
        }


        public class UpdateStatusDto
        {
            public string status { get; set; }
        }

        [HttpPost, ValidateAntiForgeryToken]
        public async Task<IActionResult> ToggleStatus(string id, bool isActive)
        {
            var dto = new { status = isActive ? "active" : "inactive" };
            var req = new HttpRequestMessage(HttpMethod.Patch, $"/api/User/{id}/status")
            {
                Content = new StringContent(
                    JsonConvert.SerializeObject(dto),
                    Encoding.UTF8,
                    "application/json")
            };
            var resp = await _httpClient.SendAsync(req);
            if (resp.IsSuccessStatusCode)
                TempData["Success"] = "Cập nhật thành công";
            else
                TempData["Error"] = await resp.Content.ReadAsStringAsync();
            return RedirectToAction(nameof(Index));
        }

        public async Task<IActionResult> Details(string id)
        {
            if (string.IsNullOrEmpty(id)) return BadRequest();

            UserViewModel? user = null;

            try
            {
                var response = await _httpClient.GetAsync($"/api/User/{id}");
                if (response.IsSuccessStatusCode)
                {
                    var json = await response.Content.ReadAsStringAsync();
                    user = JsonConvert.DeserializeObject<UserViewModel>(json);

                    var roleResponse = await _httpClient.GetAsync($"/api/Roles/{user.IdRole}");
                    if (roleResponse.IsSuccessStatusCode)
                    {
                        var roleJson = await roleResponse.Content.ReadAsStringAsync();
                        var role = JsonConvert.DeserializeObject<RoleViewModel>(roleJson);
                        user.RoleName = role?.RoleName;
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error fetching user details: " + ex.Message);
            }

            if (user == null) return NotFound();

            return View(user);
        }

        // GET: /Users/ConfirmSuspend/{id}
        [HttpGet]
        public async Task<IActionResult> ConfirmSuspend(string id)
        {
            if (string.IsNullOrEmpty(id))
                return BadRequest();

            var resp = await _httpClient.GetAsync($"/api/User/{id}");
            if (!resp.IsSuccessStatusCode)
                return NotFound();

            var user = await resp.Content.ReadFromJsonAsync<UserVM>();
            if (user == null)
                return NotFound();

            return View(user);
        }

        // POST: /Users/Suspend
        [HttpPost, ValidateAntiForgeryToken]
        public async Task<IActionResult> Suspend(string id)
        {
            var getResp = await _httpClient.GetAsync($"/api/User/{id}");
            if (!getResp.IsSuccessStatusCode)
            {
                TempData["Error"] = "Tài khoản không tồn tại.";
                return RedirectToAction(nameof(Index));
            }
            var user = await getResp.Content.ReadFromJsonAsync<UserVM>();
            if (user == null)
            {
                TempData["Error"] = "Lỗi khi đọc dữ liệu tài khoản.";
                return RedirectToAction(nameof(Index));
            }

            if (user.Email == null) user.Email = "";
            if (user.UserName == null) user.UserName = "";
            if (user.IdRole == null) user.IdRole = "";
            if (user.AccountStatus == null) user.AccountStatus = "";
            if (user.Address == null) user.Address = "";

            user.AccountStatus = "suspended";

            var putResp = await _httpClient.PutAsJsonAsync($"/api/User/{id}", user);
            if (putResp.IsSuccessStatusCode)
            {
                TempData["Success"] = "Tài khoản đã được khoá.";
            }
            else
            {
                var content = await putResp.Content.ReadAsStringAsync();
                TempData["Error"] = "Khóa tài khoản thất bại. " + content;
            }

            return RedirectToAction(nameof(Index));
        }



        [HttpGet]
        public async Task<IActionResult> Delete(string id)
        {
            var response = await _httpClient.GetAsync($"api/Users/{id}");
            if (!response.IsSuccessStatusCode) return NotFound();

            var json = await response.Content.ReadAsStringAsync();
            var user = JsonConvert.DeserializeObject<UserViewModel>(json);

            return View(user);
        }

        [HttpPost, ActionName("Delete")]
        public async Task<IActionResult> DeleteConfirmed(string id)
        {
            var response = await _httpClient.DeleteAsync($"api/Users/{id}");
            if (response.IsSuccessStatusCode)
            {
                return RedirectToAction(nameof(Index));
            }

            return BadRequest();
        }

        // GET: /Report
        public async Task<IActionResult> Report(int? page)
        {
            var response = await _httpClient.GetAsync("api/Report");
            List<ReportDto> reportList = new();

            if (response.IsSuccessStatusCode)
            {
                reportList = await response.Content
                    .ReadFromJsonAsync<List<ReportDto>>()
                    ?? new List<ReportDto>();
            }
            else
            {
                TempData["Error"] = "Không thể lấy danh sách báo cáo từ API.";
            }

            reportList = reportList
                .OrderByDescending(r => r.CreatedAt)
                .ToList();

            const int pageSize = 10;
            int pageNumber = page ?? 1;
            int totalItems = reportList.Count;
            int totalPages = (int)Math.Ceiling(totalItems / (double)pageSize);

            var items = reportList.Skip((pageNumber - 1) * pageSize).Take(pageSize).ToList();

            ViewData["CurrentPage"] = pageNumber;
            ViewData["TotalPages"] = totalPages;

            return View(items);
        }

        // GET: /Details/{id}
        public async Task<IActionResult> ReportDetail(string id)
        {
            var resp = await _httpClient.GetAsync($"api/Report/{id}");
            if (!resp.IsSuccessStatusCode)
            {
                TempData["Error"] = "Không tìm thấy báo cáo.";
                return RedirectToAction("Report");
            }

            var report = await resp.Content.ReadFromJsonAsync<ReportDto>();
            if (report == null)
            {
                TempData["Error"] = "Dữ liệu báo cáo không hợp lệ.";
                return RedirectToAction("Report");
            }

            return View(report);
        }

    }
}
