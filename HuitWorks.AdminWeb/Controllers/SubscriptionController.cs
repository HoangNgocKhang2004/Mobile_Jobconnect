using Microsoft.AspNetCore.Mvc;
using HuitWorks.AdminWeb.Models.ViewModels;
using HuitWorks.AdminWeb.Models;

namespace HuitWorks.AdminWeb.Controllers
{
    public class SubscriptionController : Controller
    {
        private readonly HttpClient _httpClient;

        public SubscriptionController()
        {
            _httpClient = new HttpClient { BaseAddress = new Uri("http://localhost:5281") };
        }

        // GET: /Subscription
        public async Task<IActionResult> Index(int page = 1, int pageSize = 6)
        {
            var response = await _httpClient.GetAsync("/api/SubscriptionPackage");
            if (!response.IsSuccessStatusCode)
                return View(new ServicePackageViewModel { ServicePackages = new List<ServicePackage>(), NewPackage = new ServicePackage() });

            var apiPackages = await response.Content.ReadFromJsonAsync<List<ApiSubscriptionPackage>>();
            var servicePackages = apiPackages.Select(p => new ServicePackage
            {
                Id = p.idPackage,
                Name = p.packageName,
                Description = p.description,
                Price = p.price,
                Duration = p.durationDays,
                JobPostLimit = p.jobPostLimit,
                CVViewLimit = p.cvViewLimit,
                CreatedDate = p.createdAt,
                IsActive = p.isActive
            }).ToList();

            // Phân trang
            int totalItems = servicePackages.Count;
            int totalPages = (int)Math.Ceiling((double)totalItems / pageSize);
            page = Math.Max(1, Math.Min(page, totalPages > 0 ? totalPages : 1));

            var paginatedPackages = servicePackages
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToList();

            // Truyền thông tin phân trang sang ViewBag
            ViewBag.CurrentPage = page;
            ViewBag.TotalPages = totalPages;
            ViewBag.PageSize = pageSize;
            ViewBag.TotalItems = totalItems;

            return View(new ServicePackageViewModel
            {
                ServicePackages = paginatedPackages,
                NewPackage = new ServicePackage()
            });
        }


        // GET: /Subscription/Create
        public IActionResult Create()
        {
            var id = "pack" + DateTimeOffset.UtcNow.ToUnixTimeSeconds();
            ViewBag.GeneratedId = id;

            return View(new ServicePackage
            {
                CreatedDate = DateTime.Now,
                IsActive = true
            });
        }

        // POST: /Subscription/Create
        [HttpPost]
        public async Task<IActionResult> Create(ServicePackage model)
        {
            if (!ModelState.IsValid)
            {
                if (Request.Headers["X-Requested-With"] == "XMLHttpRequest")
                {
                    return Json(new
                    {
                        success = false,
                        message = "Dữ liệu không hợp lệ!",
                        errors = ModelState.ToDictionary(
                            kvp => kvp.Key,
                            kvp => kvp.Value.Errors.Select(e => e.ErrorMessage).ToArray()
                        )
                    });
                }

                TempData["ErrorMessage"] = "Dữ liệu không hợp lệ!";
                return RedirectToAction(nameof(Index));
            }

            var payload = new
            {
                idPackage = model.Id,
                packageName = model.Name,
                description = model.Description,
                price = model.Price,
                durationDays = model.Duration,
                jobPostLimit = model.JobPostLimit,
                cvViewLimit = model.CVViewLimit,
                createdAt = DateTime.Now,
                isActive = model.IsActive
            };

            var response = await _httpClient.PostAsJsonAsync("/api/SubscriptionPackage", payload);

            if (response.IsSuccessStatusCode)
            {
                var successMessage = "Thêm gói dịch vụ thành công!";
                TempData["SuccessMessage"] = successMessage;

                if (Request.Headers["X-Requested-With"] == "XMLHttpRequest")
                {
                    return Json(new { success = true, message = successMessage });
                }
            }
            else
            {
                var errorMessage = "Thêm thất bại!";
                TempData["ErrorMessage"] = errorMessage;

                if (Request.Headers["X-Requested-With"] == "XMLHttpRequest")
                {
                    return Json(new { success = false, message = errorMessage });
                }
            }

            return RedirectToAction(nameof(Index));
        }

        // GET: /Subscription/Edit/{id}
        public async Task<IActionResult> Edit(string id)
        {
            var response = await _httpClient.GetAsync($"/api/SubscriptionPackage/{id}");
            if (!response.IsSuccessStatusCode) return NotFound();

            var package = await response.Content.ReadFromJsonAsync<ApiSubscriptionPackage>();
            var model = new ServicePackage
            {
                Id = package.idPackage,
                Name = package.packageName,
                Description = package.description,
                Price = package.price,
                Duration = package.durationDays,
                JobPostLimit = package.jobPostLimit,
                CVViewLimit = package.cvViewLimit,
                CreatedDate = package.createdAt,
                IsActive = package.isActive
            };

            return View(model);
        }

        // POST: /Subscription/Edit/{id}
        [HttpPost]
        public async Task<IActionResult> Edit(ServicePackage model)
        {
            if (!ModelState.IsValid)
            {
                if (Request.Headers["X-Requested-With"] == "XMLHttpRequest")
                {
                    return Json(new
                    {
                        success = false,
                        message = "Dữ liệu không hợp lệ!",
                        errors = ModelState.ToDictionary(
                            kvp => kvp.Key,
                            kvp => kvp.Value.Errors.Select(e => e.ErrorMessage).ToArray()
                        )
                    });
                }

                TempData["ErrorMessage"] = "Dữ liệu không hợp lệ!";
                return View(model);
            }

            var payload = new
            {
                idPackage = model.Id,
                packageName = model.Name,
                description = model.Description,
                price = model.Price,
                durationDays = model.Duration,
                jobPostLimit = model.JobPostLimit,
                cvViewLimit = model.CVViewLimit,
                createdAt = model.CreatedDate,
                isActive = model.IsActive
            };

            var response = await _httpClient.PutAsJsonAsync($"/api/SubscriptionPackage/{model.Id}", payload);

            if (response.IsSuccessStatusCode)
            {
                var successMessage = "Cập nhật thành công!";
                TempData["SuccessMessage"] = successMessage;

                if (Request.Headers["X-Requested-With"] == "XMLHttpRequest")
                {
                    return Json(new { success = true, message = successMessage });
                }
            }
            else
            {
                var errorMessage = "Cập nhật thất bại!";
                TempData["ErrorMessage"] = errorMessage;

                if (Request.Headers["X-Requested-With"] == "XMLHttpRequest")
                {
                    return Json(new { success = false, message = errorMessage });
                }
            }

            return RedirectToAction(nameof(Index));
        }

        // POST: /Subscription/ToggleStatus
        [HttpPost]
        public async Task<IActionResult> ToggleStatus(string id)
        {
            var response = await _httpClient.GetAsync($"/api/SubscriptionPackage/{id}");
            if (!response.IsSuccessStatusCode)
            {
                if (Request.Headers["X-Requested-With"] == "XMLHttpRequest")
                {
                    return Json(new { success = false, message = "Không tìm thấy gói dịch vụ!" });
                }
                return NotFound();
            }

            var package = await response.Content.ReadFromJsonAsync<ApiSubscriptionPackage>();

            var payload = new
            {
                idPackage = package.idPackage,
                packageName = package.packageName,
                description = package.description,
                price = package.price,
                durationDays = package.durationDays,
                jobPostLimit = package.jobPostLimit,
                cvViewLimit = package.cvViewLimit,
                createdAt = package.createdAt,
                isActive = !package.isActive
            };

            var putResponse = await _httpClient.PutAsJsonAsync($"/api/SubscriptionPackage/{id}", payload);

            if (putResponse.IsSuccessStatusCode)
            {
                var successMessage = "Thay đổi trạng thái thành công!";
                TempData["SuccessMessage"] = successMessage;

                if (Request.Headers["X-Requested-With"] == "XMLHttpRequest")
                {
                    return Json(new
                    {
                        success = true,
                        message = successMessage,
                        isActive = !package.isActive
                    });
                }
            }
            else
            {
                var errorMessage = "Thay đổi thất bại!";
                TempData["ErrorMessage"] = errorMessage;

                if (Request.Headers["X-Requested-With"] == "XMLHttpRequest")
                {
                    return Json(new { success = false, message = errorMessage });
                }
            }

            return RedirectToAction(nameof(Index));
        }
    }

    public class ApiSubscriptionPackage
    {
        public string idPackage { get; set; }
        public string packageName { get; set; }
        public decimal price { get; set; }
        public int durationDays { get; set; }
        public string description { get; set; }
        public int jobPostLimit { get; set; }
        public int cvViewLimit { get; set; }
        public DateTime createdAt { get; set; }
        public bool isActive { get; set; }
    }
}