using HuitWorks.AdminWeb.Models.ViewModels;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System.Text;

namespace HuitWorks.AdminWeb.Controllers
{
    public class HRController : Controller
    {
        private readonly HttpClient _httpClient;

        public HRController()
        {
            _httpClient = new HttpClient();
            _httpClient.BaseAddress = new Uri("http://localhost:5281"); // Link API base
        }

        public async Task<IActionResult> Index(int page = 1, int pageSize = 6)
        {
            var hrCompanies = new List<HRCompanyViewModel>();

            List<RecruiterInfoViewModel> recruiters = new();
            List<UserViewModel> users = new();
            List<CompanyViewModel> companies = new();

            try
            {
                // 1) Gọi API
                var recruiterRes = await _httpClient.GetAsync("api/RecruiterInfo");
                var userRes = await _httpClient.GetAsync("api/User");
                var companyRes = await _httpClient.GetAsync("api/Companies");

                if (recruiterRes.IsSuccessStatusCode)
                    recruiters = JsonConvert
                        .DeserializeObject<List<RecruiterInfoViewModel>>(await recruiterRes.Content.ReadAsStringAsync())
                        ?? new();

                if (userRes.IsSuccessStatusCode)
                    users = JsonConvert
                        .DeserializeObject<List<UserViewModel>>(await userRes.Content.ReadAsStringAsync())
                        ?? new();

                if (companyRes.IsSuccessStatusCode)
                    companies = JsonConvert
                        .DeserializeObject<List<CompanyViewModel>>(await companyRes.Content.ReadAsStringAsync())
                        ?? new();

                // 2) Map vào HRCompanyViewModel
#pragma warning disable CS8619
                hrCompanies = recruiters
                    .Select(r =>
                    {
                        var u = users.FirstOrDefault(x => x.IdUser == r.IdUser && x.IdRole == "role1");
                        var c = companies.FirstOrDefault(x => x.IdCompany == r.IdCompany);
                        if (u == null || c == null) return null;
                        return new HRCompanyViewModel
                        {
                            IdUser = u.IdUser,
                            UserName = u.UserName,
                            Email = u.Email,
                            PhoneNumber = u.PhoneNumber,
                            AvatarUrl = u.AvatarUrl,

                            IdCompany = c.IdCompany,
                            CompanyName = c.CompanyName,
                            Address = c.Address,
                            LogoCompany = c.LogoCompany,
                            WebsiteUrl = c.WebsiteUrl,
                            Scale = c.Scale,
                            Description = c.Description,

                            Title = r.Title,
                            Department = r.Department,

                            // Thêm AccountStatus vào VM nếu cần
                            AccountStatus = u.AccountStatus
                        };
                    })
                    .Where(x => x != null)
                    .ToList();
#pragma warning restore CS8619
            }
            catch (Exception ex)
            {
                Console.WriteLine("Lỗi load HR Companies: " + ex.Message);
            }

            // 3) Tính chỉ số cho các card
            ViewBag.TotalAccounts = hrCompanies.Count;
            ViewBag.PendingAccounts = hrCompanies.Count(x =>
                !string.Equals(x.AccountStatus, "active", StringComparison.OrdinalIgnoreCase));
            ViewBag.EmployersCount = hrCompanies.Count(x =>
                string.Equals(x.AccountStatus, "active", StringComparison.OrdinalIgnoreCase));
            ViewBag.ServicesUsedCount = hrCompanies
                .Select(x => x.IdCompany)
                .Distinct()
                .Count();

            // 4) Phân trang
            int totalItems = hrCompanies.Count;
            int totalPages = (int)Math.Ceiling((double)totalItems / pageSize);
            page = Math.Clamp(page, 1, totalPages == 0 ? 1 : totalPages);

            var paged = hrCompanies
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToList();

            ViewBag.CurrentPage = page;
            ViewBag.TotalPages = totalPages;
            ViewBag.PageSize = pageSize;
            ViewBag.TotalItems = totalItems;

            return View(paged);
        }


        public IActionResult UserManagement()
        {
            return View();
        }

        public IActionResult VerificationRequests()
        {
            return View();
        }

        public IActionResult ManageRoles()
        {
            return View();
        }

        [HttpGet]
        public async Task<IActionResult> Details(string id)
        {
            var _httpClient = new HttpClient
            {
                BaseAddress = new Uri("http://localhost:5281/")
            };

            var companyResponse = await _httpClient.GetAsync($"/api/Companies/{id}");
            if (!companyResponse.IsSuccessStatusCode)
            {
                return NotFound();
            }
            var companyJson = await companyResponse.Content.ReadAsStringAsync();
            var company = JsonConvert.DeserializeObject<HRCompanyViewModel>(companyJson);

            var recruiterResponse = await _httpClient.GetAsync($"/api/RecruiterInfo");
            var recruitersJson = await recruiterResponse.Content.ReadAsStringAsync();
            var recruiters = JsonConvert.DeserializeObject<List<RecruiterInfoViewModel>>(recruitersJson);

            var recruiter = recruiters.FirstOrDefault(r => r.IdCompany == id);

            if (recruiter != null)
            {
                var userResponse = await _httpClient.GetAsync($"/api/User/{recruiter.IdUser}");
                if (userResponse.IsSuccessStatusCode)
                {
                    var userJson = await userResponse.Content.ReadAsStringAsync();
                    var user = JsonConvert.DeserializeObject<UserViewModel>(userJson);

                    company.Recruiter = recruiter;
                    company.User = user;
                }
            }

            return View(company);
        }

        [HttpGet]
        public async Task<IActionResult> Edit(string id)
        {
            var recruiterRes = await _httpClient.GetAsync($"/api/RecruiterInfo/{id}");
            var userRes = await _httpClient.GetAsync($"/api/User/{id}");

            if (!recruiterRes.IsSuccessStatusCode || !userRes.IsSuccessStatusCode)
                return NotFound();

            var recruiter = JsonConvert.DeserializeObject<RecruiterInfoViewModel>(await recruiterRes.Content.ReadAsStringAsync());
            var user = JsonConvert.DeserializeObject<UserViewModel>(await userRes.Content.ReadAsStringAsync());

            var company = recruiter.Company;

            var model = new HRViewModel
            {
                IdUser = recruiter.IdUser,
                UserName = user.UserName,
                Email = user.Email,
                IdCompany = recruiter.IdCompany,
                Department = recruiter.Department,
                Title = recruiter.Title,
                Description = recruiter.Description ?? " "
            };

            return View(model);
        }

        [HttpPost]
        public async Task<IActionResult> Edit(HRViewModel model)
        {
            var recruiterModel = new
            {
                //idUser = model.IdUser,
                title = model.Title,
                idCompany = model.IdCompany,
                department = model.Department,
                description = model.Description
            };

            var recruiterContent = new StringContent(
                JsonConvert.SerializeObject(recruiterModel), Encoding.UTF8, "application/json");

            var recruiterRes = await _httpClient.PutAsync($"/api/RecruiterInfo/{model.IdUser}", recruiterContent);

            if (recruiterRes.IsSuccessStatusCode /* && userRes.IsSuccessStatusCode nếu có update user*/)
                return RedirectToAction("Index");

            ModelState.AddModelError("", "Lỗi khi cập nhật thông tin HR.");
            return View(model);
        }


    }
}
