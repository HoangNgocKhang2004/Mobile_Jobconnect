using HuitWorks.RecruiterWeb.Models;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using HuitWorks.RecruiterWeb.Models.ViewModel;
using Newtonsoft.Json;
using System.Net.Http;
using System.Security.Claims;
using HuitWorks.RecruiterWeb.Service;
using System.Text;
using System.Net.Http.Headers;
using System.Text.Json;

namespace HuitWorks.RecruiterWeb.Controllers
{
    public class JobsController : Controller
    {
        private readonly IHttpClientFactory _httpClientFactory;
        private readonly IEmailService _emailService;
        private readonly IQuotaService _quotaService;
        private readonly IHttpContextAccessor _httpContextAccessor;
        public JobsController(IHttpClientFactory httpClientFactory, IEmailService emailService, IQuotaService quotaService,
        IHttpContextAccessor httpContextAccessor)
        {
            _httpClientFactory = httpClientFactory;
            _emailService = emailService;
            _quotaService = quotaService;
            _httpContextAccessor = httpContextAccessor;
        }

        // GET: Jobs
        public async Task<IActionResult> Index(int page = 1,int pageSize = 5,string status = "all",string location = "all")
        {
            var recruiterId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (string.IsNullOrEmpty(recruiterId))
                return RedirectToAction("Login", "Auth");

            var client = _httpClientFactory.CreateClient("ApiClient");

            var recResp = await client.GetAsync("/api/RecruiterInfo");
            recResp.EnsureSuccessStatusCode();
            var recJson = await recResp.Content.ReadAsStringAsync();
            var recruiters = JsonConvert.DeserializeObject<List<RecruiterInfoViewModel>>(recJson) ?? new List<RecruiterInfoViewModel>();

            var recruiter = recruiters.FirstOrDefault(r => r.IdUser == recruiterId);
            if (recruiter == null)
                return View(new List<JobPostingViewModel>());

            var companyId = recruiter.IdCompany;

            var postResp = await client.GetAsync("/api/JobPosting/all");
            postResp.EnsureSuccessStatusCode();
            var postJson = await postResp.Content.ReadAsStringAsync();
            var allPosts = JsonConvert.DeserializeObject<List<JobPostingViewModel>>(postJson) ?? new List<JobPostingViewModel>();

            var myPosts = allPosts.Where(p => p.Company?.IdCompany == companyId);

            var totalJob = myPosts.Count();
            var isActive = myPosts.Count(j => j.PostStatus != null && j.PostStatus.ToLower() == "open");
            var saphethan = myPosts.Count(j => j.PostStatus != null && j.PostStatus.ToLower() == "open"
                && (j.ApplicationDeadline - DateTime.Now).TotalDays <= 7
                && (j.ApplicationDeadline - DateTime.Now).TotalDays >= 0
            );

            if (status != "all")
            {
                if (status == "active")
                    myPosts = myPosts.Where(j => j.PostStatus != null && j.PostStatus.ToLower() == "open");
                else if (status == "inactive")
                    myPosts = myPosts.Where(j => j.PostStatus != null && j.PostStatus.ToLower() == "closed");
            }

            if (location != "all")
            {
                myPosts = myPosts.Where(j => j.Location == location);
            }

            var postsList = myPosts.OrderByDescending(j => j.CreatedAt).ToList();
            ViewBag.Location = myPosts.Select(j => j.Location).Where(l => !string.IsNullOrEmpty(l)).Distinct();

            // Phân trang
            int totalItems = postsList.Count;
            int totalPages = (int)Math.Ceiling((double)totalItems / pageSize);
            page = Math.Max(1, Math.Min(page, totalPages > 0 ? totalPages : 1));

            var paginatedPosts = postsList
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToList();

            ViewBag.TotalJob = totalJob;
            ViewBag.IsActive = isActive;
            ViewBag.Saphethan = saphethan;
            ViewBag.CurrentStatus = status;
            ViewBag.CurrentLocation = location;
            ViewBag.CurrentPage = page;
            ViewBag.TotalPages = totalPages;
            ViewBag.PageSize = pageSize;
            ViewBag.TotalItems = totalItems;

            return View(paginatedPosts);
        }



        // GET: /Jobs/Details/job1
        public async Task<IActionResult> Details(string id)
        {
            if (string.IsNullOrEmpty(id))
                return BadRequest();

            var client = _httpClientFactory.CreateClient("ApiClient");

            var resp = await client.GetAsync($"api/JobPosting/{id}");
            if (!resp.IsSuccessStatusCode)
                return NotFound();

            var json = await resp.Content.ReadAsStringAsync();
            var job = JsonConvert.DeserializeObject<JobPostingViewModel>(json);
            if (job == null)
                return NotFound();

            var recruiterId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (!string.IsNullOrEmpty(recruiterId))
            {
            }

            return View(job);
        }

        // POST: /Jobs/ToggleStatus
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ToggleStatus(string id)
        {
            var client = _httpClientFactory.CreateClient("ApiClient");
            var jobRes = await client.GetAsync($"/api/JobPosting/{id}");
            if (!jobRes.IsSuccessStatusCode)
                return Json(new { success = false, message = "Không tìm thấy bài đăng" });

            var jobJson = await jobRes.Content.ReadAsStringAsync();
            var job = JsonConvert.DeserializeObject<JobPostingVM>(jobJson);
            if (job == null)
                return Json(new { success = false, message = "Không parse được dữ liệu job" });

            job.postStatus = (job.postStatus?.ToLower() == "open" || job.postStatus?.ToLower() == "waiting") ? "closed" : "waiting";


            var putRes = await client.PutAsJsonAsync($"/api/JobPosting/{id}", job);
            var putText = await putRes.Content.ReadAsStringAsync();

            if (putRes.IsSuccessStatusCode)
                return Json(new { success = true, newStatus = job.postStatus });
            else
                return Json(new { success = false, message = putText });
        }

        [HttpGet]
        public async Task<IActionResult> Delete(string id)
        {
            var client = _httpClientFactory.CreateClient("ApiClient");
            if (string.IsNullOrEmpty(id))
                return BadRequest();

            var resp = await client.GetAsync($"/api/JobPosting/{id}");
            if (!resp.IsSuccessStatusCode)
                return NotFound();

            var job = await resp.Content.ReadFromJsonAsync<JobPostingViewModel>();
            if (job == null)
                return NotFound();

            return View(job);
        }

        // POST: /JobPostings/Delete/{id}
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(string id)
        {
            var client = _httpClientFactory.CreateClient("ApiClient");
            if (string.IsNullOrEmpty(id))
                return BadRequest();

            var resp = await client.DeleteAsync($"/api/JobPosting/{id}");
            if (resp.IsSuccessStatusCode)
            {
                TempData["Success"] = "Xóa tin tuyển dụng thành công.";
                return RedirectToAction(nameof(Index));
            }

            TempData["Error"] = "Xóa thất bại, vui lòng thử lại.";
            var job = await client.GetFromJsonAsync<JobPostingViewModel>($"/api/JobPosting/{id}");
            return View(job);
        }

        // GET: /Jobs/Create
        [HttpGet]
        public async Task<IActionResult> Create()
        {
            var recruiterId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (string.IsNullOrEmpty(recruiterId))
                return Challenge();

            var activeTx = await _quotaService.GetActiveTransactionAsync(recruiterId);
            if (activeTx == null)
            {
                TempData["Error"] = "Bạn chưa có gói đã thanh toán hoàn tất hoặc đã hết hạn/quota đã hết. Vui lòng mua gói mới.";
                return RedirectToAction("RequirePackage", "Jobs");
            }

            var client = _httpClientFactory.CreateClient("ApiClient");
            var token = HttpContext.Session.GetString("JwtToken");
            if (!string.IsNullOrEmpty(token))
            {
                client.DefaultRequestHeaders.Authorization =
                    new AuthenticationHeaderValue("Bearer", token);
            }
            else
            {
                return Challenge();
            }

            var recRes = await client.GetAsync($"/api/RecruiterInfo/{recruiterId}");
            string companyId = null;
            if (recRes.IsSuccessStatusCode)
            {
                var rec = await recRes.Content.ReadFromJsonAsync<RecruiterInfoViewModel>();
                companyId = rec.IdCompany;
            }

            var vm = new JobPostViewModel
            {
                IdJobPost = Guid.NewGuid().ToString(),
                IdCompany = companyId,
                ApplicationDeadline = DateTime.Today.AddDays(30),
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow
            };

            return View(vm);
        }

        // POST: /Jobs/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(JobPostViewModel model)
        {
            if (!ModelState.IsValid)
                return View(model);

            var recruiterId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (string.IsNullOrEmpty(recruiterId))
                return Challenge();

            var activeTx = await _quotaService.GetActiveTransactionAsync(recruiterId);
            if (activeTx == null)
            {
                ModelState.AddModelError(string.Empty, "Bạn đã hết lượt đăng tin hoặc không có gói đăng tin hợp lệ.");
                return View(model);
            }

            var client = _httpClientFactory.CreateClient("ApiClient");
            var token = HttpContext.Session.GetString("JwtToken");
            if (!string.IsNullOrEmpty(token))
            {
                client.DefaultRequestHeaders.Authorization =
                    new AuthenticationHeaderValue("Bearer", token);
            }
            else
            {
                return Challenge();
            }

            var useJobpostResponse = await client.PutAsync(
                $"/api/JobTransaction/{activeTx.IdTransaction}/use-jobpost",
                null);
            if (!useJobpostResponse.IsSuccessStatusCode)
            {
                var errJson = await useJobpostResponse.Content.ReadAsStringAsync();
                string message;
                try
                {
                    using var doc = System.Text.Json.JsonDocument.Parse(errJson);
                    if (doc.RootElement.TryGetProperty("message", out var prop))
                        message = prop.GetString()!;
                    else
                        message = errJson;
                }
                catch
                {
                    message = errJson;
                }

                ModelState.AddModelError(string.Empty, $"Không thể trừ lượt đăng tin: {message}");
                return View(model);
            }

            model.IdJobPost = Guid.NewGuid().ToString();
            model.CreatedAt = DateTime.UtcNow;
            model.UpdatedAt = DateTime.UtcNow;
            model.PostStatus = "waiting";

            var payload = new
            {
                idJobPost = model.IdJobPost,
                title = model.Title,
                description = model.Description,
                requirements = model.Requirements,
                salary = model.Salary,
                location = model.Location,
                latitude = model.Latitude,
                longitude = model.Longitude,
                workType = model.WorkType,
                experienceLevel = model.ExperienceLevel,
                idCompany = model.IdCompany,
                applicationDeadline = model.ApplicationDeadline,
                benefits = model.Benefits,
                createdAt = model.CreatedAt,
                updatedAt = model.UpdatedAt,
                isFeatured = model.IsFeatured ? 1 : 0,
                postStatus = model.PostStatus
            };

            var createJobRes = await client.PostAsJsonAsync("/api/JobPosting", payload);
            if (createJobRes.IsSuccessStatusCode)
            {
                TempData["Success"] = "Tạo tin tuyển dụng thành công!";
                return RedirectToAction("Index");
            }
            else
            {
                try
                {
                    await client.PutAsJsonAsync(
                        $"/api/JobTransaction/{activeTx.IdTransaction}",
                        new { remainingJobPosts = activeTx.RemainingJobPosts });
                }
                catch
                {
                }

                var errJson = await createJobRes.Content.ReadAsStringAsync();
                string message;
                try
                {
                    using var doc = System.Text.Json.JsonDocument.Parse(errJson);
                    if (doc.RootElement.TryGetProperty("message", out var prop))
                        message = prop.GetString()!;
                    else
                        message = errJson;
                }
                catch
                {
                    message = errJson;
                }

                ModelState.AddModelError(string.Empty, $"Đã có lỗi khi tạo tin tuyển dụng: {message}");
                return View(model);
            }
        }

        [HttpGet]
        public async Task<IActionResult> Edit(string id)
        {
            if (string.IsNullOrEmpty(id)) return BadRequest();
            var client = _httpClientFactory.CreateClient("ApiClient");
            var resp = await client.GetAsync($"/api/JobPosting/{id}");
            if (!resp.IsSuccessStatusCode) return NotFound();

            var json = await resp.Content.ReadAsStringAsync();
            var job = JsonConvert.DeserializeObject<JobPosting1ViewModel>(json);
            if (job == null) return NotFound();

            return View(job);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(string id, JobPosting1ViewModel model)
        {
            if (id != model.IdJobPost) return BadRequest();
            if (!ModelState.IsValid) return View(model);

            var client = _httpClientFactory.CreateClient("ApiClient");

            var updateDto = new
            {
                title = model.Title,
                description = model.Description,
                requirements = model.Requirements,
                salary = model.Salary,
                location = model.Location,
                applicationDeadline = model.ApplicationDeadline,
                postStatus = "waiting"
            };

            var putResp = await client.PutAsJsonAsync($"api/JobPosting/{id}", updateDto);
            if (!putResp.IsSuccessStatusCode)
            {
                var body = await putResp.Content.ReadAsStringAsync();
                ModelState.AddModelError("", $"Cập nhật thất bại: {body}");
                return View(model);
            }

            TempData["SuccessMessage"] = "Bài tuyển dụng đã được cập nhật thành công.";
            return RedirectToAction(nameof(Index));
        }


        public IActionResult Applications()
        {
            return View();
        }

        public async Task<IActionResult> SavedApplications()
        {
            var recruiterId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (string.IsNullOrEmpty(recruiterId))
                return Challenge();

            var client = _httpClientFactory.CreateClient("ApiClient");

            var savedResumes = await client.GetFromJsonAsync<List<SavedResumeDto>>("/api/SavedResume")
                                ?? new List<SavedResumeDto>();

            var mySavedResumes = savedResumes.Where(s => s.IdRecruiter == recruiterId).ToList();

            if (!mySavedResumes.Any())
                return View(new List<SavedResumeViewModel>());

            var candidates = await client.GetFromJsonAsync<List<CandidateInfoViewModel>>("/api/CandidateInfo")
                             ?? new List<CandidateInfoViewModel>();
            var users = await client.GetFromJsonAsync<List<UserViewModel>>("/api/User")
                         ?? new List<UserViewModel>();

            var viewModelList = mySavedResumes.Select(save =>
            {
                var candidateInfo = candidates.FirstOrDefault(c => c.IdUser == save.IdCandidate);
                var userInfo = users.FirstOrDefault(u => u.IdUser == save.IdCandidate);

                return new SavedResumeViewModel
                {
                    IdSave = save.IdSave,
                    CandidateId = save.IdCandidate,
                    CandidateName = userInfo?.UserName ?? "Không xác định",
                    CandidateEmail = userInfo?.Email ?? "",
                    SavedAt = save.SavedAt,
                    WorkPosition = candidateInfo?.WorkPosition,
                    ExperienceYears = candidateInfo?.ExperienceYears ?? 0,
                    Education = candidateInfo?.EducationLevel,
                    Skills = candidateInfo?.Skills
                };
            }).ToList();

            return View(viewModelList);
        }

        [HttpDelete]
        public async Task<IActionResult> Remove(string idSave)
        {
            var client = _httpClientFactory.CreateClient("ApiClient");
            var response = await client.DeleteAsync($"/api/SavedResume/{idSave}");

            if (response.IsSuccessStatusCode)
                return Json(new { success = true });
            else
                return Json(new { success = false });
        }


        [HttpGet]
        public async Task<IActionResult> ContactCandidate(string id)
        {
            var client = _httpClientFactory.CreateClient("ApiClient");
            var user = await client.GetFromJsonAsync<UserViewModel>($"/api/User/{id}");
            if (user == null) return NotFound();

            var model = new ContactCandidateViewModel
            {
                CandidateId = id,
                CandidateName = user.UserName,
                CandidateEmail = user.Email
            };
            return View(model);
        }


        [HttpPost]
        public async Task<IActionResult> ContactCandidate(ContactCandidateViewModel model)
        {
            if (!ModelState.IsValid)
                return View(model);

            var companyName = User.Identity.Name;
            var currentDate = DateTime.Now.ToString("dd/MM/yyyy");

            var emailBody = $@"
            <!DOCTYPE html>
            <html lang='vi'>
            <head>
                <meta charset='UTF-8'>
                <meta name='viewport' content='width=device-width, initial-scale=1.0'>
                <title>{model.Subject}</title>
                <style>
                    body {{
                        font-family: 'Segoe UI', Arial, sans-serif;
                        line-height: 1.6;
                        color: #333333;
                        margin: 0;
                        padding: 0;
                    }}
                    .email-container {{
                        max-width: 600px;
                        margin: 0 auto;
                        padding: 20px;
                        background-color: #ffffff;
                    }}
                    .email-header {{
                        background-color: #0066cc;
                        padding: 20px;
                        text-align: center;
                        border-radius: 5px 5px 0 0;
                    }}
                    .email-header h1 {{
                        color: #ffffff;
                        margin: 0;
                        font-size: 24px;
                    }}
                    .email-content {{
                        padding: 20px;
                        background-color: #f9f9f9;
                        border-left: 1px solid #dddddd;
                        border-right: 1px solid #dddddd;
                    }}
                    .email-footer {{
                        background-color: #f2f2f2;
                        padding: 15px 20px;
                        font-size: 12px;
                        text-align: center;
                        color: #666666;
                        border-radius: 0 0 5px 5px;
                        border: 1px solid #dddddd;
                    }}
                    .candidate-name {{
                        font-weight: bold;
                        color: #0066cc;
                    }}
                    .signature {{
                        margin-top: 30px;
                        padding-top: 15px;
                        border-top: 1px solid #eeeeee;
                    }}
                    .company-name {{
                        font-weight: bold;
                        color: #0066cc;
                    }}
                    .button {{
                        display: inline-block;
                        padding: 10px 20px;
                        margin: 15px 0;
                        background-color: #0066cc;
                        color: #ffffff;
                        text-decoration: none;
                        border-radius: 5px;
                    }}
                </style>
            </head>
            <body>
                <div class='email-container'>
                    <div class='email-header'>
                        <h1>Thông Báo Tuyển Dụng</h1>
                    </div>
        
                    <div class='email-content'>
                        <p>Ngày: {currentDate}</p>
                        <p>Kính gửi <span class='candidate-name'>{model.CandidateName}</span>,</p>
            
                        <p>{model.Content}</p>
            
                        <div class='signature'>
                            <p>Trân trọng,</p>
                            <p class='company-name'>{companyName}</p>
                            <p>Phòng Nhân sự</p>
                        </div>
                    </div>
        
                    <div class='email-footer'>
                        <p>Đây là email tự động, vui lòng không trả lời email này.</p>
                        <p>&copy; {DateTime.Now.Year} {companyName}. Tất cả các quyền được bảo lưu.</p>
                    </div>
                </div>
            </body>
            </html>";

            await _emailService.SendEmailAsync(model.CandidateEmail, model.Subject, emailBody);
            TempData["Success"] = "Email đã được gửi thành công!";
            return RedirectToAction("SavedApplications");
        }

        [HttpGet]
        public async Task<IActionResult> RequirePackage()
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (string.IsNullOrEmpty(userId))
            {
                return RedirectToAction("Login", "Auth");
            }
            var client = _httpClientFactory.CreateClient("ApiClient");
            string activePackageId = null;
            var txResponse = await client.GetAsync($"api/JobTransaction/latest/{userId}");
            if (txResponse.IsSuccessStatusCode)
            {
                dynamic txObj = JsonConvert.DeserializeObject(await txResponse.Content.ReadAsStringAsync());
                activePackageId = txObj.idPackage;
            }
            if (!string.IsNullOrEmpty(activePackageId))
            {
                return RedirectToAction("Index", "Home");
            }
            return View();
        }
    }
}