using HuitWorks.AdminWeb.Models;
using Microsoft.AspNetCore.Mvc;

namespace HuitWorks.AdminWeb.Controllers
{
    public class EvaluationCriteriaController : Controller
    {
        private readonly IHttpClientFactory _httpClientFactory;
        private HttpClient Client => _httpClientFactory.CreateClient("ApiClient");

        public EvaluationCriteriaController(IHttpClientFactory httpClientFactory)
        {
            _httpClientFactory = httpClientFactory;
        }

        // GET: /AdminEvaluationCriteria
        public async Task<IActionResult> Index(int page = 1, int pageSize = 10)
        {
            var all = await Client
                .GetFromJsonAsync<List<EvaluationCriteriaDto>>("/api/EvaluationCriteria");
            var sorted = all
                .OrderByDescending(c => c.CreatedAt)
                .ToList();

            int totalItems = sorted.Count;
            int totalPages = (int)Math.Ceiling((double)totalItems / pageSize);

            page = Math.Max(1, Math.Min(page, totalPages));

            var paged = sorted
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToList();

            ViewBag.CurrentPage = page;
            ViewBag.TotalPages = totalPages;
            ViewBag.PageSize = pageSize;
            ViewBag.TotalItems = totalItems;

            return View(paged);
        }


        // GET: /AdminEvaluationCriteria/Create
        public IActionResult Create()
        {
            return View(new EvaluationCriteriaDto());
        }

        // POST: /AdminEvaluationCriteria/Create
        [HttpPost, ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(EvaluationCriteriaDto dto)
        {
            dto.CriterionId = Guid.NewGuid().ToString();
            dto.CreatedAt = DateTime.UtcNow;

            ModelState.Remove(nameof(dto.CriterionId));
            ModelState.Remove(nameof(dto.CreatedAt));

            if (!ModelState.IsValid)
                return View(dto);

            var res = await Client.PostAsJsonAsync("/api/EvaluationCriteria", dto);
            res.EnsureSuccessStatusCode();
            return RedirectToAction(nameof(Index));
        }


        // GET: /AdminEvaluationCriteria/Edit/{id}
        public async Task<IActionResult> Edit(string id)
        {
            var all = await Client.GetFromJsonAsync<List<EvaluationCriteriaDto>>("/api/EvaluationCriteria");
            var dto = all.FirstOrDefault(x => x.CriterionId == id);
            if (dto == null) return NotFound();
            return View(dto);
        }

        // POST: /AdminEvaluationCriteria/Edit/{id}
        [HttpPost, ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(string id, EvaluationCriteriaDto dto)
        {
            if (id != dto.CriterionId) return BadRequest();
            if (!ModelState.IsValid) return View(dto);

            var res = await Client.PutAsJsonAsync($"/api/EvaluationCriteria/{id}", dto);
            if (!res.IsSuccessStatusCode)
            {
                ModelState.AddModelError("", "Không thể cập nhật tiêu chí.");
                return View(dto);
            }

            return RedirectToAction(nameof(Index));
        }

        // POST: /AdminEvaluationCriteria/Delete/{id}
        [HttpPost, ValidateAntiForgeryToken]
        public async Task<IActionResult> Delete(string id)
        {
            await Client.DeleteAsync($"/api/EvaluationCriteria/{id}");
            return RedirectToAction(nameof(Index));
        }
    }
}
