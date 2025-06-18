// File: Controllers/ResumesController.cs
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http.Headers;
using System.Text.Json;
using System.Threading.Tasks;
using HuitWorks.RecruiterWeb.Models.ViewModel;
using HuitWorks.RecruiterWeb.Service;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using HuitWorks.RecruiterWeb.Models.Dtos;

namespace HuitWorks.RecruiterWeb.Controllers
{
    [Route("Jobs/[controller]")]
    public class ResumesController : Controller
    {
        private readonly IHttpClientFactory _httpClientFactory;
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IQuotaService _quotaService;

        public ResumesController(
            IHttpClientFactory httpClientFactory,
            IHttpContextAccessor httpContextAccessor,
            IQuotaService quotaService)
        {
            _httpClientFactory = httpClientFactory;
            _httpContextAccessor = httpContextAccessor;
            _quotaService = quotaService;
        }

        // GET: /Resumes/ViewCv/{userId}
        public async Task<IActionResult> ViewCv(string userId)
        {
            if (string.IsNullOrEmpty(userId))
                return BadRequest("User ID không hợp lệ.");

            var client = _httpClientFactory.CreateClient("ApiClient");
            var token = HttpContext.Session.GetString("JwtToken");
            if (!string.IsNullOrEmpty(token))
            {
                client.DefaultRequestHeaders.Authorization =
                    new AuthenticationHeaderValue("Bearer", token);
            }
            else
            {
                return RedirectToAction("Login", "Auth");
            }

            var candRes = await client.GetAsync($"/api/CandidateInfo/{userId}");
            if (!candRes.IsSuccessStatusCode)
                return RedirectToAction("Index", "Candidates");

            var candJson = await candRes.Content.ReadAsStringAsync();
            var candidateDto = JsonSerializer.Deserialize<CandidateInfoDto>(
                candJson,
                new JsonSerializerOptions { PropertyNameCaseInsensitive = true }
            );
            if (candidateDto == null)
                return RedirectToAction("Index", "Candidates");

            var userRes = await client.GetAsync($"/api/User/{userId}");
            string userName = "(Không có tên)";
            string userEmail = "(Không có email)";
            if (userRes.IsSuccessStatusCode)
            {
                var userJson = await userRes.Content.ReadAsStringAsync();
                try
                {
                    var userDto = JsonSerializer.Deserialize<UserResumeDto>(
                        userJson,
                        new JsonSerializerOptions { PropertyNameCaseInsensitive = true }
                    );
                    if (userDto != null)
                    {
                        userName = userDto.UserName;
                        userEmail = userDto.Email;
                    }
                }
                catch
                {
                }
            }

            var resumeRes = await client.GetAsync($"/api/Resume/by-user/{userId}");
            if (!resumeRes.IsSuccessStatusCode)
                return RedirectToAction("RequirePackage", "Jobs");

            var resumeJson = await resumeRes.Content.ReadAsStringAsync();
            var resumeDto = JsonSerializer.Deserialize<ResumeDto>(
                resumeJson,
                new JsonSerializerOptions { PropertyNameCaseInsensitive = true }
            );
            if (resumeDto == null)
                return RedirectToAction("Index", "Candidates");

            List<ResumeSkillDto> skillDetails = new();
            var skillRes = await client.GetAsync($"/api/ResumeSkill/{resumeDto.IdResume}");
            if (skillRes.IsSuccessStatusCode)
            {
                var skillJson = await skillRes.Content.ReadAsStringAsync();
                try
                {
                    skillDetails = JsonSerializer.Deserialize<List<ResumeSkillDto>>(
                        skillJson,
                        new JsonSerializerOptions { PropertyNameCaseInsensitive = true }
                    ) ?? new List<ResumeSkillDto>();
                }
                catch
                {
                    skillDetails = new List<ResumeSkillDto>();
                }
            }

            var vm = new CandidateResumeViewModel
            {
                IdUser = candidateDto.IdUser,
                UserName = userName,
                Email = userEmail,
                WorkPosition = candidateDto.WorkPosition,
                ExperienceYears = candidateDto.ExperienceYears,
                EducationLevel = candidateDto.EducationLevel,
                UniversityName = candidateDto.UniversityName,
                Skills = candidateDto.Skills,

                IdResume = resumeDto.IdResume,
                FileName = resumeDto.FileName,
                FileUrl = resumeDto.FileUrl,
                FileSizeKB = resumeDto.FileSizeKB,
                SkillDetails = skillDetails
            };

            return View(vm);
        }
    }
}
