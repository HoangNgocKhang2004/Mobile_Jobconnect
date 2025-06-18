using HuitWorks.RecruiterWeb.Models;
using HuitWorks.RecruiterWeb.Models.ViewModel;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System.Net.Http;
using System.Security.Claims;

namespace HuitWorks.RecruiterWeb.Controllers
{
    public class CandidatesController : Controller
    {
        private readonly HttpClient _httpClient;
        //private readonly IHttpContextAccessor _httpContextAccessor;

        public CandidatesController()
        {
            _httpClient = new HttpClient
            {
                BaseAddress = new Uri("http://localhost:5281/")
            };
        }

        public async Task<IActionResult> Index(
            string keyword,
            string position,
            string skill,
            int page = 1,
            int pageSize = 6)
        {
            var recruiterId = User.FindFirstValue(ClaimTypes.NameIdentifier);

            var candidateResp = await _httpClient.GetAsync("/api/CandidateInfo");
            if (!candidateResp.IsSuccessStatusCode)
            {
                return StatusCode((int)candidateResp.StatusCode, "Không thể lấy danh sách ứng viên.");
            }
            var candidateJson = await candidateResp.Content.ReadAsStringAsync();
            var candidates = JsonConvert.DeserializeObject<List<CandidateInfoViewModel>>(candidateJson)
                             ?? new List<CandidateInfoViewModel>();

            var userResp = await _httpClient.GetAsync("/api/User");
            userResp.EnsureSuccessStatusCode();
            var userJson = await userResp.Content.ReadAsStringAsync();
            var users = JsonConvert.DeserializeObject<List<UserViewModel>>(userJson)
                        ?? new List<UserViewModel>();

            var resumeResp = await _httpClient.GetAsync("/api/Resume");
            resumeResp.EnsureSuccessStatusCode();
            var resumeJson = await resumeResp.Content.ReadAsStringAsync();
            var allResumes = JsonConvert.DeserializeObject<List<ResumeFromApiViewModel>>(resumeJson)
                             ?? new List<ResumeFromApiViewModel>();

            var savedResp = await _httpClient.GetAsync("/api/SavedResume");
            savedResp.EnsureSuccessStatusCode();
            var savedJson = await savedResp.Content.ReadAsStringAsync();
            var savedResumes = JsonConvert.DeserializeObject<List<SavedResumeViewModel>>(savedJson)
                               ?? new List<SavedResumeViewModel>();

            var recruiterSavedIds = savedResumes
                .Where(s => s.IdRecruiter == recruiterId)
                .Select(s => s.CandidateId)
                .ToHashSet();

            var viewModelAll = candidates.Select(c =>
            {
                var user = users.FirstOrDefault(u => u.IdUser == c.IdUser);

                var resumeOfThisUser = allResumes
                    .Where(r => r.IdUser == c.IdUser)
                    .OrderByDescending(r => r.IsDefault)
                    .FirstOrDefault();

                return new CandidateViewModel
                {
                    IdUser = c.IdUser,
                    UserName = user?.UserName ?? "Không rõ",
                    Email = user?.Email ?? "",
                    WorkPosition = c.WorkPosition,
                    ExperienceYears = c.ExperienceYears,
                    EducationLevel = c.EducationLevel,
                    UniversityName = c.UniversityName,
                    Skills = c.Skills,
                    RatingScore = c.RatingScore,
                    IsSaved = recruiterSavedIds.Contains(c.IdUser),
                    ResumeId = resumeOfThisUser?.IdResume
                };
            }).ToList();

            if (!string.IsNullOrEmpty(keyword))
            {
                var kw = keyword.ToLower();
                viewModelAll = viewModelAll
                    .Where(c =>
                        (c.UserName?.ToLower().Contains(kw) ?? false)
                        || (c.Email?.ToLower().Contains(kw) ?? false))
                    .ToList();
            }

            if (!string.IsNullOrEmpty(position))
            {
                var pos = position.ToLower();
                viewModelAll = viewModelAll
                    .Where(c => (c.WorkPosition?.ToLower().Contains(pos) ?? false))
                    .ToList();
            }

            if (!string.IsNullOrEmpty(skill))
            {
                var sk = skill.ToLower();
                viewModelAll = viewModelAll
                    .Where(c => (c.Skills?.ToLower().Contains(sk) ?? false))
                    .ToList();
            }

            var totalItems = viewModelAll.Count;
            var totalPages = (int)Math.Ceiling(totalItems / (double)pageSize);

            var pagedCandidates = viewModelAll
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToList();

            ViewBag.CurrentPage = page;
            ViewBag.TotalPages = totalPages;
            ViewBag.SavedCandidateIds = recruiterSavedIds;
            ViewBag.CurrentFilters = new { keyword, position, skill };
            ViewBag.TotalCandidates = totalItems;

            return View(pagedCandidates);
        }

        public async Task<IActionResult> Applied(int page = 1)
        {
            var recruiterId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (string.IsNullOrEmpty(recruiterId))
                return Challenge();

            var recRes = await _httpClient.GetAsync($"/api/RecruiterInfo/{recruiterId}");
            if (!recRes.IsSuccessStatusCode) return View(new List<CandidateInfoViewModel>());

            var recruiter = await recRes.Content.ReadFromJsonAsync<RecruiterInfoViewModel>();
            if (recruiter == null || string.IsNullOrEmpty(recruiter.IdCompany))
                return View(new List<CandidateInfoViewModel>());

            var companyId = recruiter.IdCompany;

            var postsRes = await _httpClient.GetAsync("/api/JobPosting");
            postsRes.EnsureSuccessStatusCode();
            var allPosts = await postsRes.Content.ReadFromJsonAsync<List<JobPostingViewModel>>() ?? new List<JobPostingViewModel>();
            var myPostIds = new HashSet<string>(
                allPosts.Where(p => p.Company?.IdCompany == companyId)
                        .Select(p => p.IdJobPost)
            );

            var appsRes = await _httpClient.GetAsync("/api/JobApplication");
            appsRes.EnsureSuccessStatusCode();
            var allApps = await appsRes.Content.ReadFromJsonAsync<List<JobApplicationViewModel>>() ?? new List<JobApplicationViewModel>();
            var myApps = allApps.Where(a => myPostIds.Contains(a.IdJobPost)).ToList();

            var candList = await _httpClient.GetFromJsonAsync<List<CandidateInfoViewModel>>("/api/CandidateInfo") ?? new List<CandidateInfoViewModel>();
            var users = await _httpClient.GetFromJsonAsync<List<UserViewModel>>("/api/User") ?? new List<UserViewModel>();

            var candidateIds = myApps.Select(a => a.IdUser).Distinct().ToHashSet();
            var allResult = candList
                .Where(c => candidateIds.Contains(c.IdUser))
                .Select(c =>
                {
                    c.User = users.FirstOrDefault(u => u.IdUser == c.IdUser);
                    c.Applications = myApps
                        .Where(a => a.IdUser == c.IdUser)
                        .Select(a => new CandidateApplicationViewModel
                        {
                            JobPostId = a.IdJobPost,
                            JobTitle = allPosts.FirstOrDefault(p => p.IdJobPost == a.IdJobPost)?.Title ?? "–",
                            Status = a.ApplicationStatus,
                            SubmittedAt = a.SubmittedAt
                        })
                        .ToList();
                    return c;
                })
                .ToList();

            //// PHÂN TRANG
            //var totalItems = allResult.Count;
            //var totalPages = (int)Math.Ceiling((double)totalItems / pageSize);
            //var pagedResult = allResult.Skip((page - 1) * pageSize).Take(pageSize).ToList();

            //// Truyền thông tin phân trang sang ViewBag hoặc ViewData
            //ViewBag.Page = page;
            //ViewBag.PageSize = pageSize;
            //ViewBag.TotalItems = totalItems;
            //ViewBag.TotalPages = totalPages;

            return View(allResult);
        }

        [HttpGet]
        public async Task<IActionResult> Interviews()
        {
            var recruiterId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (string.IsNullOrEmpty(recruiterId))
                return Challenge();

            var recruiterResponse = await _httpClient.GetAsync($"/api/RecruiterInfo/{recruiterId}");
            if (!recruiterResponse.IsSuccessStatusCode)
                return Unauthorized();

            var recruiter = await recruiterResponse.Content.ReadFromJsonAsync<RecruiterInfoDto>();
            if (recruiter == null)
                return Unauthorized();

            var companyId = recruiter.IdCompany;

            var schedules = await _httpClient
                .GetFromJsonAsync<List<InterviewScheduleDto>>("/api/InterviewSchedule")
                ?? new List<InterviewScheduleDto>();

            var existingEvals = await _httpClient
                .GetFromJsonAsync<List<CandidateEvaluationDto>>("api/CandidateEvaluation")
                ?? new List<CandidateEvaluationDto>();

            foreach (var schedule in schedules)
            {
                var jobResponse = await _httpClient.GetAsync($"/api/JobPosting/{schedule.IdJobPost}");
                if (!jobResponse.IsSuccessStatusCode)
                    continue;

                var jobPost = await jobResponse.Content.ReadFromJsonAsync<JobPostingDto>();
                if (jobPost == null || jobPost.IdCompany != companyId)
                    continue;

                if (schedule.InterviewDate < DateTime.Now)
                {
                    bool alreadyEvaluated = existingEvals.Any(e =>
                        e.IdJobPost == schedule.IdJobPost &&
                        e.IdCandidate == schedule.IdUser);

                    if (!alreadyEvaluated)
                    {
                        var newEval = new CandidateEvaluationCreateDto
                        {
                            EvaluationId = Guid.NewGuid().ToString(),
                            IdRecruiter = recruiterId,
                            IdJobPost = schedule.IdJobPost,
                            IdCandidate = schedule.IdUser,
                            CreatedAt = DateTime.Now
                        };

                        var postResp = await _httpClient.PostAsJsonAsync("api/CandidateEvaluation", newEval);
                        if (postResp.IsSuccessStatusCode)
                        {
                            existingEvals.Add(new CandidateEvaluationDto
                            {
                                EvaluationId = newEval.EvaluationId,
                                IdRecruiter = newEval.IdRecruiter,
                                IdJobPost = newEval.IdJobPost,
                                IdCandidate = newEval.IdCandidate,
                                CreatedAt = newEval.CreatedAt
                            });
                        }
                    }
                }
            }

            var viewModelList = new List<InterviewViewModel>();
            foreach (var schedule in schedules)
            {
                var jobRes = await _httpClient.GetAsync($"/api/JobPosting/{schedule.IdJobPost}");
                if (!jobRes.IsSuccessStatusCode) 
                    continue;

                var job = await jobRes.Content.ReadFromJsonAsync<JobPostingDto>();
                if (job == null || job.IdCompany != companyId)
                    continue;

                var userRes = await _httpClient.GetAsync($"/api/User/{schedule.IdUser}");
                var user = userRes.IsSuccessStatusCode
                    ? await userRes.Content.ReadFromJsonAsync<UserDto>()
                    : null;

                bool hasPassed = schedule.InterviewDate < DateTime.Now;

                viewModelList.Add(new InterviewViewModel
                {
                    Id = schedule.IdSchedule,
                    CandidateName = user?.UserName ?? "Không xác định",
                    CandidateEmail = user?.Email,
                    PositionTitle = job.Title ?? "Không xác định",
                    InterviewDateTime = schedule.InterviewDate,
                    Mode = schedule.InterviewMode,
                    Location = schedule.Location,
                    Interviewer = schedule.Interviewer,
                    Note = schedule.Note,
                    HasPassed = hasPassed
                });
            }

            return View(viewModelList);
        }

        public async Task<IActionResult> DetailsInterview(string id)
        {
            if (string.IsNullOrEmpty(id))
                return NotFound();

            var interviewResp = await _httpClient.GetAsync($"/api/InterviewSchedule/{id}");
            if (!interviewResp.IsSuccessStatusCode)
                return NotFound();

            var interviewJson = await interviewResp.Content.ReadAsStringAsync();
            var interview = JsonConvert.DeserializeObject<InterviewScheduleViewModel>(interviewJson);
            if (interview == null)
                return NotFound();

            var candidateResp = await _httpClient.GetAsync($"/api/CandidateInfo/{interview.IdUser}");
            if (!candidateResp.IsSuccessStatusCode)
                return NotFound();
            var candidateJson = await candidateResp.Content.ReadAsStringAsync();
            var candidate = JsonConvert.DeserializeObject<CandidateInfoViewModel>(candidateJson);

            var userResp = await _httpClient.GetAsync($"/api/User/{interview.IdUser}");
            var userJson = await userResp.Content.ReadAsStringAsync();
            var user = JsonConvert.DeserializeObject<UserViewModel>(userJson);

            UserViewModel interviewer = null;
            if (!string.IsNullOrEmpty(interview.Interviewer))
            {
                var interviewerResp = await _httpClient.GetAsync($"/api/User/{interview.Interviewer}");
                if (interviewerResp.IsSuccessStatusCode)
                {
                    var interviewerJson = await interviewerResp.Content.ReadAsStringAsync();
                    interviewer = JsonConvert.DeserializeObject<UserViewModel>(interviewerJson);
                }
            }

            string jobTitle = "";
            var jobPostResp = await _httpClient.GetAsync($"/api/JobPosting/{interview.IdJobPost}");
            if (jobPostResp.IsSuccessStatusCode)
            {
                var jobPostJson = await jobPostResp.Content.ReadAsStringAsync();
                var jobPost = JsonConvert.DeserializeObject<JobPostingViewModel>(jobPostJson);
                jobTitle = jobPost?.Title ?? "";
            }

            var vm = new InterviewDetailViewModel
            {
                IdSchedule = interview.IdSchedule,
                CandidateId = interview.IdUser,
                CandidateName = user?.UserName ?? "",
                CandidateEmail = user?.Email ?? "",
                CandidatePhone = user?.PhoneNumber ?? "",
                WorkPosition = candidate?.WorkPosition,
                UniversityName = candidate?.UniversityName,
                EducationLevel = candidate?.EducationLevel,
                ExperienceYears = candidate?.ExperienceYears ?? 0,
                Skills = candidate?.Skills,
                IdJobPost = interview.IdJobPost,
                JobTitle = jobTitle,
                InterviewDate = interview.InterviewDate,
                InterviewMode = interview.InterviewMode,
                Location = interview.Location,
                Note = interview.Note,
                InterviewerId = interview.Interviewer,
                //InterviewerName = interviewer?.UserName
            };

            return View(vm);
        }

        [HttpGet]
        public async Task<IActionResult> EditInterview(string id)
        {
            if (string.IsNullOrEmpty(id))
                return NotFound();

            var interview = await _httpClient.GetFromJsonAsync<InterviewScheduleDto>($"/api/InterviewSchedule/{id}");
            if (interview == null)
                return NotFound();

            //var candidate = await _httpClient.GetFromJsonAsync<CandidateInfoViewModel>($"/api/CandidateInfo/{interview.IdUser}");
            CandidateInfoViewModel candidate = null;
            try
            {
                candidate = await _httpClient.GetFromJsonAsync<CandidateInfoViewModel>($"/api/CandidateInfo/{interview.IdUser}");
            }
            catch (HttpRequestException ex)
            {
                TempData["Error"] = "Không tìm thấy thông tin ứng viên!";
                //return View("ErrorNotFound");
                return RedirectToAction("Interviews");
            }

            var user = await _httpClient.GetFromJsonAsync<UserViewModel>($"/api/User/{interview.IdUser}");
            var jobPost = await _httpClient.GetFromJsonAsync<JobPostingViewModel>($"/api/JobPosting/{interview.IdJobPost}");
            //UserViewModel interviewer = null;
            //if (!string.IsNullOrEmpty(interview.Interviewer))
            //    interviewer = await _httpClient.GetFromJsonAsync<UserViewModel>($"/api/User/{interview.Interviewer}");

            var vm = new InterviewDetailViewModel
            {
                IdSchedule = interview.IdSchedule,
                CandidateId = interview.IdUser,
                IdJobPost = interview.IdJobPost,
                InterviewDate = interview.InterviewDate,
                InterviewMode = interview.InterviewMode,
                Location = interview.Location,
                Note = interview.Note,
                InterviewerId = interview.Interviewer,
                //InterviewerName = interview.,
                CandidateName = user?.UserName ?? "",
                CandidateEmail = user?.Email ?? "",
                CandidatePhone = user?.PhoneNumber ?? "",
                WorkPosition = candidate?.WorkPosition,
                UniversityName = candidate?.UniversityName,
                EducationLevel = candidate?.EducationLevel,
                ExperienceYears = candidate?.ExperienceYears ?? 0,
                Skills = candidate?.Skills,
                JobTitle = jobPost?.Title
            };

            return View(vm);
        }


        [HttpPost]
        public async Task<IActionResult> EditInterview(InterviewDetailViewModel model)
        {
            if (!ModelState.IsValid)
                return View(model);

            var payload = new
            {
                idSchedule = model.IdSchedule,
                idJobPost = model.IdJobPost,
                idUser = model.CandidateId,
                interviewDate = model.InterviewDate,
                interviewMode = model.InterviewMode,
                location = model.Location,
                interviewer = model.InterviewerId,
                note = model.Note
            };

            var resp = await _httpClient.PutAsJsonAsync($"/api/InterviewSchedule/{model.IdSchedule}", payload);

            if (resp.IsSuccessStatusCode)
            {
                TempData["Success"] = "Cập nhật lịch phỏng vấn thành công!";
                return RedirectToAction("DetailsInterview", new { id = model.IdSchedule });
            }
            TempData["Error"] = "Cập nhật thất bại.";
            return View(model);
        }


        [HttpPost]
        public async Task<IActionResult> Save(string candidateId)
        {
            var recruiterId = User.FindFirstValue(ClaimTypes.NameIdentifier);

            var payload = new
            {
                idRecruiter = recruiterId,
                idCandidate = candidateId,
                savedAt = DateTime.UtcNow
            };

            var response = await _httpClient.PostAsJsonAsync("/api/SavedResume", payload);

            return Json(new { success = response.IsSuccessStatusCode });
        }

        // GET /Candidates/Details/{id}
        public async Task<IActionResult> DetailCandidate(string id)
        {
            if (string.IsNullOrEmpty(id))
                return BadRequest();

            var userResp = await _httpClient.GetAsync($"/api/User/{id}");
            if (!userResp.IsSuccessStatusCode)
                return NotFound();
            var user = await userResp.Content.ReadFromJsonAsync<UserViewModel>();
            if (user == null)
                return NotFound();

            var candResp = await _httpClient.GetAsync($"/api/CandidateInfo/{id}");
            if (!candResp.IsSuccessStatusCode)
                return NotFound();
            var candInfo = await candResp.Content.ReadFromJsonAsync<CandidateInfoViewModel>();
            if (candInfo == null)
                return NotFound();

            var vm = new CandidateDetailViewModel
            {
                IdUser = id,
                UserName = user.UserName,
                Email = user.Email,
                PhoneNumber = user.PhoneNumber,
                Address = user.Address,

                WorkPosition = candInfo.WorkPosition,
                RatingScore = candInfo.RatingScore,
                UniversityName = candInfo.UniversityName,
                EducationLevel = candInfo.EducationLevel,
                ExperienceYears = candInfo.ExperienceYears,
                Skills = candInfo.Skills ?? ""
            };

            return View(vm);
        }

        // GET: /Candidates/InviteInterview/userId?jobPostId=jobId
        [HttpGet]
        public async Task<IActionResult> InviteInterview(string idUser, string idJobPost)
        {
            if (string.IsNullOrEmpty(idUser) || string.IsNullOrEmpty(idJobPost))
                return BadRequest("Thiếu thông tin ứng viên hoặc bài đăng tuyển.");

            var userResp = await _httpClient.GetAsync($"/api/User/{idUser}");
            if (!userResp.IsSuccessStatusCode)
            {
                TempData["Error"] = "Không thể lấy thông tin ứng viên.";
                return RedirectToAction("Applied");
            }

            var userJson = await userResp.Content.ReadAsStringAsync();
            if (string.IsNullOrEmpty(userJson) || !userJson.TrimStart().StartsWith("{"))
            {
                TempData["Error"] = "Dữ liệu ứng viên không hợp lệ.";
                return RedirectToAction("Applied");
            }

            var user = JsonConvert.DeserializeObject<UserViewModel>(userJson);
            if (user == null)
            {
                TempData["Error"] = "Ứng viên không tồn tại.";
                return RedirectToAction("Applied");
            }

            var jobResp = await _httpClient.GetAsync($"/api/JobPosting/{idJobPost}");
            if (!jobResp.IsSuccessStatusCode)
            {
                TempData["Error"] = "Không thể lấy thông tin vị trí tuyển dụng.";
                return RedirectToAction("Applied");
            }

            var jobJson = await jobResp.Content.ReadAsStringAsync();
            if (string.IsNullOrEmpty(jobJson) || !jobJson.TrimStart().StartsWith("{"))
            {
                TempData["Error"] = "Dữ liệu vị trí tuyển dụng không hợp lệ.";
                return RedirectToAction("Applied");
            }

            var jobPost = JsonConvert.DeserializeObject<JobPostingViewModel>(jobJson);
            if (jobPost == null)
            {
                TempData["Error"] = "Vị trí tuyển dụng không tồn tại.";
                return RedirectToAction("Applied");
            }

            var model = new InterviewSchedViewModel
            {
                IdUser = idUser,
                IdJobPost = idJobPost,
                CandidateName = user.UserName,
                PositionTitle = jobPost.Title
            };

            return View(model);
        }


        // POST: /Candidates/InviteInterview
        [HttpPost]
        public async Task<IActionResult> InviteInterview(InterviewSchedViewModel model)
        {
            if (!ModelState.IsValid)
            {
                TempData["Error"] = "Vui lòng nhập đầy đủ thông tin.";
                return View(model);
            }

            var recruiterId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (string.IsNullOrEmpty(recruiterId))
                return Challenge();

            // 1. Parse thời gian
            var interviewDateTime = DateTime.Parse($"{model.InterviewDate}T{model.InterviewTime}");

            // 2. Lưu lịch phỏng vấn
            var schedulePayload = new
            {
                idSchedule = Guid.NewGuid().ToString(),
                idJobPost = model.IdJobPost,
                idUser = model.IdUser,
                interviewDate = interviewDateTime,
                interviewMode = model.InterviewMode,
                location = model.Location,
                note = model.Note,
                interviewer = model.Interviewer
            };
            var resp = await _httpClient.PostAsJsonAsync("/api/InterviewSchedule", schedulePayload);
            if (!resp.IsSuccessStatusCode)
            {
                TempData["Error"] = "Gửi lời mời phỏng vấn thất bại.";
                return View(model);
            }

            // 3. Cập nhật trạng thái ứng dụng
            var statusPayload = new { applicationStatus = "interview" };
            await _httpClient.PutAsJsonAsync($"/api/JobApplication/{model.IdJobPost}/{model.IdUser}", statusPayload);

            // 4. Tạo notification
            var notifDto = new CreateNotificationDto
            {
                IdUser = model.IdUser,
                Title =
                    $"Bạn được mời phỏng vấn “{model.PositionTitle}” vào {interviewDateTime:dd/MM/yyyy HH:mm} tại {model.Location}" +
                    (string.IsNullOrWhiteSpace(model.InterviewMode) ? "" : $" (Hình thức: {model.InterviewMode})"),
                Type = "Phỏng vấn",
                DateTime = interviewDateTime,
                Status = "Đã gửi",
                ActionUrl = $"/candidate/interview/{model.IdJobPost}",
                IsRead = 0
            };

            var notifResp = await _httpClient.PostAsJsonAsync("/api/Notification", notifDto);
            if (!notifResp.IsSuccessStatusCode)
            {
                // đọc thêm lỗi từ API
                var err = await notifResp.Content.ReadAsStringAsync();
                TempData["Error"] = $"Phỏng vấn đã gửi nhưng tạo thông báo thất bại: {notifResp.StatusCode} – {err}";
            }
            else
            {
                TempData["Success"] = "Đã gửi lời mời và tạo thông báo chi tiết cho ứng viên.";
            }

            return RedirectToAction("Applied");
        }


        // GET: /Candidates/RejectCandidate/userId?jobPostId=jobId
        [HttpPost]
        public async Task<IActionResult> RejectCandidate(string idUser, string idJobPost)
        {
            var payload = new { applicationStatus = "rejected" };
            var response = await _httpClient.PutAsJsonAsync($"/api/JobApplication/{idJobPost}/{idUser}", payload);
            if (!response.IsSuccessStatusCode)
                return RedirectToAction("Applied");

            var schedules = await _httpClient.GetFromJsonAsync<List<InterviewScheduleDto>>("/api/InterviewSchedule")
                             ?? new List<InterviewScheduleDto>();

            var toDelete = schedules
                .Where(s => s.IdJobPost == idJobPost && s.IdUser == idUser)
                .Select(s => s.IdSchedule)
                .ToList();

            foreach (var scheduleId in toDelete)
            {
                await _httpClient.DeleteAsync($"/api/InterviewSchedule/{scheduleId}");
            }

            TempData["Success"] = "Đã từ chối ứng viên và xóa lịch phỏng vấn (nếu có).";

            return RedirectToAction("Applied");
        }

        [HttpPost]
        public async Task<IActionResult> UndoRejectCandidate(string idUser, string idJobPost)
        {
            var payload = new { applicationStatus = "viewed" };
            var response = await _httpClient.PutAsJsonAsync($"/api/JobApplication/{idJobPost}/{idUser}", payload);
            if (response.IsSuccessStatusCode)
                return RedirectToAction("Applied");

            TempData["Error"] = "Hủy từ chối ứng viên thất bại.";
            return RedirectToAction("Applied");
        }

        // CandidatesController.cs

        [HttpPost]
        public async Task<IActionResult> DeleteInterview(string id)
        {
            if (string.IsNullOrEmpty(id))
                return Json(new { success = false, message = "Không xác định lịch phỏng vấn." });

            var response = await _httpClient.DeleteAsync($"/api/InterviewSchedule/{id}");

            if (response.IsSuccessStatusCode)
            {
                return Json(new { success = true, message = "Xóa thành công!" });
            }

            return Json(new { success = false, message = "Xóa thất bại. Vui lòng thử lại!" });
        }

        public async Task<IActionResult> Details(string idUser, string idJobPost)
        {
            if (string.IsNullOrEmpty(idUser) || string.IsNullOrEmpty(idJobPost))
                return NotFound();

            var candidateResp = await _httpClient.GetAsync($"/api/CandidateInfo/{idUser}");
            if (!candidateResp.IsSuccessStatusCode)
                return NotFound();

            var candidate = await candidateResp.Content.ReadFromJsonAsync<CandidateInfoViewModel>();
            if (candidate == null)
                return NotFound();

            var userResp = await _httpClient.GetAsync($"/api/User/{idUser}");
            var user = await userResp.Content.ReadFromJsonAsync<UserViewModel>();

            var appResp = await _httpClient.GetAsync($"/api/JobApplication/{idJobPost}/{idUser}");
            if (appResp.IsSuccessStatusCode)
            {
                var app = await appResp.Content.ReadFromJsonAsync<JobApplicationViewModel>();
                if (app != null && app.ApplicationStatus == "pending")
                {
                    var payload = new { applicationStatus = "viewed" };
                    await _httpClient.PutAsJsonAsync($"/api/JobApplication/{idJobPost}/{idUser}", payload);
                }
            }

            var viewModel = new CandidateViewModel
            {
                IdUser = candidate.IdUser,
                UserName = user?.UserName ?? "Không rõ",
                Email = user?.Email ?? "-",
                WorkPosition = candidate.WorkPosition,
                ExperienceYears = candidate.ExperienceYears,
                EducationLevel = candidate.EducationLevel,
                UniversityName = candidate.UniversityName,
                Skills = candidate.Skills,
                RatingScore = candidate.RatingScore
            };

            return View(viewModel);
        }

        [HttpPost]
        public async Task<IActionResult> ConfirmInterviewSuccess(string idUser, string idJobPost)
        {
            var getResp = await _httpClient.GetAsync($"/api/JobApplication/{idJobPost}/{idUser}");
            getResp.EnsureSuccessStatusCode();
            var app = await getResp.Content.ReadFromJsonAsync<JobApplicationDto>();

            app.ApplicationStatus = "accepted";
            app.UpdatedAt = DateTime.UtcNow;
            var putResp = await _httpClient.PutAsJsonAsync(
                $"/api/JobApplication/{app.IdJobPost}/{app.IdUser}",
                new { ApplicationStatus = "accepted" }
            );
            putResp.EnsureSuccessStatusCode();

            var recruiterId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var evaluation = new CandidateEvaluationDto
            {
                EvaluationId = Guid.NewGuid().ToString(),
                IdJobPost = idJobPost,
                IdCandidate = idUser,
                IdRecruiter = recruiterId,
                CreatedAt = DateTime.UtcNow
            };
            var evalResp = await _httpClient.PostAsJsonAsync("/api/CandidateEvaluation", evaluation);
            evalResp.EnsureSuccessStatusCode();

            var critResp = await _httpClient.GetAsync("/api/EvaluationCriteria");
            critResp.EnsureSuccessStatusCode();
            var criteria = await critResp.Content.ReadFromJsonAsync<List<EvaluationCriteriaDto>>();

            foreach (var crit in criteria)
            {
                var detail = new EvaluationDetailDto
                {
                    EvaluationDetailId = Guid.NewGuid().ToString(),
                    EvaluationId = evaluation.EvaluationId,
                    CriterionId = crit.CriterionId,
                    Score = 0,
                    Comments = ""
                };
                var detailResp = await _httpClient.PostAsJsonAsync("/api/EvaluationDetail", detail);
            }

            return RedirectToAction("Applied");
        }

        [HttpPost]
        public async Task<IActionResult> ConfirmInterviewFail(string idUser, string idJobPost)
        {
            var getResp = await _httpClient.GetAsync($"/api/JobApplication/{idJobPost}/{idUser}");
            getResp.EnsureSuccessStatusCode();
            var application = await getResp.Content.ReadFromJsonAsync<JobApplicationDto>();

            var updateResp = await _httpClient.PutAsJsonAsync(
                $"/api/JobApplication/{application.IdJobPost}/{application.IdUser}",
                new { ApplicationStatus = "rejected" }
            );
            updateResp.EnsureSuccessStatusCode();

            var schedules = await _httpClient.GetFromJsonAsync<List<InterviewScheduleDto>>("/api/InterviewSchedule")
                             ?? new List<InterviewScheduleDto>();

            var toDelete = schedules
                .Where(s => s.IdJobPost == idJobPost && s.IdUser == idUser)
                .Select(s => s.IdSchedule)
                .ToList();

            foreach (var scheduleId in toDelete)
            {
                await _httpClient.DeleteAsync($"/api/InterviewSchedule/{scheduleId}");
            }

            TempData["Success"] = "Đã từ chối ứng viên và xóa lịch phỏng vấn (nếu có).";
            return RedirectToAction("Applied");
        }

        // DTOs để deserialize/serialize JSON từ API
        private class JobApplicationDto
        {
            public string IdJobPost { get; set; }
            public string IdUser { get; set; }
            public string CvFileUrl { get; set; }
            public string CoverLetter { get; set; }
            public string ApplicationStatus { get; set; }
            public DateTime SubmittedAt { get; set; }
            public DateTime UpdatedAt { get; set; }
        }
        public class UpdateJobApplicationDto
        {
            public string CvFileUrl { get; set; }
            public string CoverLetter { get; set; }
            public string ApplicationStatus { get; set; }
        }
        private class CandidateEvaluationDto
        {
            public string EvaluationId { get; set; }
            public string IdJobPost { get; set; }
            public string IdCandidate { get; set; }
            public string IdRecruiter { get; set; }
            public DateTime CreatedAt { get; set; }
        }
        // DTO helper
        public class EvaluationCriteriaDto
        {
            public string CriterionId { get; set; }
            public string Name { get; set; }
            public string Description { get; set; }
            public DateTime CreatedAt { get; set; }
        }

        public class EvaluationDetailDto
        {
            public string EvaluationDetailId { get; set; }
            public string EvaluationId { get; set; }
            public string CriterionId { get; set; }
            public int Score { get; set; }
            public string Comments { get; set; }
        }
    }
    public class CandidateEvaluationCreateDto
    {
        public string EvaluationId { get; set; }
        public string IdRecruiter { get; set; }
        public string IdJobPost { get; set; }
        public string IdCandidate { get; set; }
        public DateTime CreatedAt { get; set; }
    }
    public class CreateNotificationDto
    {
        public string IdUser { get; set; }
        public string Title { get; set; }
        public string Type { get; set; }
        public DateTime DateTime { get; set; }
        public string Status { get; set; }
        public string ActionUrl { get; set; }
        public int IsRead { get; set; }
    }

}
