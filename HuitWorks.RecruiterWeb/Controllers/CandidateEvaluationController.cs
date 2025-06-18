using HuitWorks.RecruiterWeb.Models;
using HuitWorks.RecruiterWeb.Models.ViewModel;
using HuitWorks.RecruiterWeb.Service;
using Microsoft.AspNetCore.Mvc;
using System.Net;
using System.Security.Claims;

namespace HuitWorks.RecruiterWeb.Controllers
{
    public class CandidateEvaluationController : Controller
    {
        private readonly IHttpClientFactory _httpClientFactory;
        public CandidateEvaluationController(IHttpClientFactory httpClientFactory)
        {
            _httpClientFactory = httpClientFactory;
        }

        // GET: /CandidateEvaluation
        [HttpGet]
        public async Task<IActionResult> Index()
        {
            var recruiterId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var client = _httpClientFactory.CreateClient("ApiClient");
            var allEvals = await client
                .GetFromJsonAsync<List<CandidateEvaluationDto>>("api/CandidateEvaluation");
            var myEvals = allEvals
                ?.Where(e => e.IdRecruiter == recruiterId)
                .OrderByDescending(e => e.CreatedAt)
                .ToList();

            var criteria = await client.GetFromJsonAsync<List<EvaluationCriteriaDto>>("api/EvaluationCriteria");
            int totalCriteria = criteria.Count;

            var summaryList = new List<EvaluateSummaryViewModel>();
            foreach (var eval in myEvals)
            {
                var urlDetail = $"api/EvaluationDetail?evaluationId={WebUtility.UrlEncode(eval.EvaluationId)}";
                var details = await client
                    .GetFromJsonAsync<List<EvaluationDetailDto>>(urlDetail);

                int nonZeroCount = details.Count(d => d.Score > 0);
                string status;
                if (nonZeroCount == 0)
                    status = "Chưa đánh giá";
                else if (nonZeroCount >= totalCriteria)
                    status = "Đã đánh giá";
                else
                    status = "Chưa xong";

                var model = new EvaluateSummaryViewModel
                {
                    EvaluationId = eval.EvaluationId,
                    IdJobPost = eval.IdJobPost,
                    IdCandidate = eval.IdCandidate,
                    CreatedAt = eval.CreatedAt,
                    Status = status
                };

                try
                {
                    var jobDto = await client.GetFromJsonAsync<JobPostingDto>($"api/JobPosting/{eval.IdJobPost}");
                    if (jobDto != null)
                        model.JobTitle = jobDto.Title;
                }
                catch
                {
                    model.JobTitle = "[Không tìm thấy]";
                }

                try
                {
                    var userDto = await client.GetFromJsonAsync<UserDto>($"api/User/{eval.IdCandidate}");
                    if (userDto != null)
                        model.CandidateName = userDto.UserName;
                }
                catch
                {
                    model.CandidateName = "[Không tìm thấy]";
                }
                try
                {
                    var candidateInfoDto = await client.GetFromJsonAsync<CandidateInfoDto>($"api/CandidateInfo/{eval.IdCandidate}");
                    if (candidateInfoDto != null)
                        model.UniversityName = candidateInfoDto.UniversityName;
                }
                catch
                {
                    model.UniversityName = "[Không tìm thấy]";
                }


                summaryList.Add(model);
            }

            return View(summaryList);
        }

        // GET: /CandidateEvaluation/Evaluate?idJobPost=...&idCandidate=...
        [HttpGet]
        public async Task<IActionResult> Evaluate(string idJobPost, string idCandidate)
        {
            var recruiterId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var client = _httpClientFactory.CreateClient("ApiClient");

            var criteria = await client.GetFromJsonAsync<List<EvaluationCriteriaDto>>("/api/EvaluationCriteria");

            var urlEval = $"api/CandidateEvaluation?" +
                          $"idJobPost={WebUtility.UrlEncode(idJobPost)}&" +
                          $"idCandidate={WebUtility.UrlEncode(idCandidate)}&" +
                          $"idRecruiter={WebUtility.UrlEncode(recruiterId)}";
            var filteredEvals = await client.GetFromJsonAsync<List<CandidateEvaluationDto>>(urlEval);
            var evalHeader = filteredEvals.FirstOrDefault();
            var evaluationId = evalHeader?.EvaluationId;

            List<EvaluationDetailDto> existingDetails = new();
            if (!string.IsNullOrEmpty(evaluationId))
            {
                var urlDetail = $"api/EvaluationDetail?evaluationId={WebUtility.UrlEncode(evaluationId)}";
                existingDetails = await client.GetFromJsonAsync<List<EvaluationDetailDto>>(urlDetail);
            }

            var items = criteria.Select(c => {
                var d = existingDetails.FirstOrDefault(x => x.CriterionId == c.CriterionId);
                return new EvaluateCandidateItem
                {
                    CriterionId = c.CriterionId,
                    Name = c.Name,
                    Description = c.Description,
                    EvaluationDetailId = d?.EvaluationDetailId,
                    Score = d?.Score ?? 0,
                    Comments = d?.Comments ?? string.Empty
                };
            }).ToList();

            var vm = new EvaluateCandidateViewModel
            {
                EvaluationId = evaluationId,
                IdJobPost = idJobPost,
                IdCandidate = idCandidate,
                IdRecruiter = recruiterId,
                Items = items
            };

            return View(vm);
        }


        // POST: /CandidateEvaluation/Evaluate
        [HttpPost, ValidateAntiForgeryToken]
        public async Task<IActionResult> Evaluate(EvaluateCandidateViewModel vm)
        {
            var client = _httpClientFactory.CreateClient("ApiClient");

            if (string.IsNullOrEmpty(vm.EvaluationId))
            {
                var header = new
                {
                    evaluationId = Guid.NewGuid().ToString(),
                    idJobPost = vm.IdJobPost,
                    idCandidate = vm.IdCandidate,
                    idRecruiter = vm.IdRecruiter,
                    createdAt = DateTime.UtcNow.ToString("o")
                };
                var postHeader = await client.PostAsJsonAsync("/api/CandidateEvaluation", header);
                postHeader.EnsureSuccessStatusCode();

                var created = await postHeader.Content.ReadFromJsonAsync<CandidateEvaluationDto>();
                vm.EvaluationId = created.EvaluationId;
            }

            foreach (var item in vm.Items)
            {
                if (string.IsNullOrEmpty(item.EvaluationDetailId))
                {
                    var newDetail = new
                    {
                        evaluationDetailId = Guid.NewGuid().ToString(),
                        evaluationId = vm.EvaluationId,
                        criterionId = item.CriterionId,
                        score = item.Score,
                        comments = item.Comments
                    };
                    await client.PostAsJsonAsync("/api/EvaluationDetail", newDetail);
                }
                else
                {
                    var updateDetail = new
                    {
                        evaluationDetailId = item.EvaluationDetailId,
                        evaluationId = vm.EvaluationId,
                        criterionId = item.CriterionId,
                        score = item.Score,
                        comments = item.Comments
                    };
                    await client.PutAsJsonAsync($"/api/EvaluationDetail/{item.EvaluationDetailId}", updateDetail);
                }
            }
            return RedirectToAction("Index");
        }
    }
}
