using HuitWorks.AdminWeb.Models.ViewModels;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;

namespace HuitWorks.AdminWeb.Controllers
{
    public class PodcastController : Controller
    {
        private readonly HttpClient _httpClient;

        public PodcastController()
        {
            _httpClient = new HttpClient();
            _httpClient.BaseAddress = new Uri("http://localhost:5281");
        }

        public async Task<IActionResult> Index(int page = 1, int pageSize = 6)
        {
            List<PodcastViewModel> allPodcasts = new List<PodcastViewModel>();
            var response = await _httpClient.GetAsync("/api/Podcast");
            if (response.IsSuccessStatusCode)
            {
                var json = await response.Content.ReadAsStringAsync();
                allPodcasts = JsonConvert.DeserializeObject<List<PodcastViewModel>>(json);
            }
            int totalPodcasts = allPodcasts.Count;
            var podcasts = allPodcasts
                .OrderByDescending(p => p.PublishDate)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToList();

            ViewBag.CurrentPage = page;
            ViewBag.PageSize = pageSize;
            ViewBag.TotalPages = (int)Math.Ceiling((double)totalPodcasts / pageSize);

            return View(podcasts);
        }

        [HttpGet]
        public IActionResult Create()
        {
            ViewData["Title"] = "Thêm Podcast";
            return View(new PodcastCreateViewModel()); // Luôn truyền model mới vào
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(PodcastCreateViewModel model)
        {
            // Chỉ validate những trường bắt buộc cho form
            if (!ModelState.IsValid)
                return View(model);

            // CHỈ gửi đúng các trường API yêu cầu, KHÔNG gửi IdPodcast
            var data = new
            {
                title = model.Title,
                description = model.Description,
                host = model.Host,
                audioUrl = model.AudioUrl,
                coverImageUrl = model.CoverImageUrl,
                publishDate = model.PublishDate?.ToString("yyyy-MM-ddTHH:mm:ssZ")
            };

            var response = await _httpClient.PostAsJsonAsync("/api/Podcast", data);

            if (response.IsSuccessStatusCode)
                return RedirectToAction("Index");

            ModelState.AddModelError("", "Tạo podcast thất bại.");
            return View(model);
        }


        [HttpGet]
        public async Task<IActionResult> Edit(string id)
        {
            if (string.IsNullOrEmpty(id)) return NotFound();
            var res = await _httpClient.GetAsync($"/api/Podcast/{id}");
            if (!res.IsSuccessStatusCode) return NotFound();
            var json = await res.Content.ReadAsStringAsync();
            // Map sang PodcastEditViewModel nếu cần
            var model = JsonConvert.DeserializeObject<PodcastViewModel>(json);
            return View(model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(PodcastViewModel model)
        {
            if (!ModelState.IsValid) return View(model);

            // Chỉ gửi đúng format
            var updateData = new
            {
                title = model.Title,
                description = model.Description,
                host = model.Host,
                audioUrl = model.AudioUrl,
                coverImageUrl = model.CoverImageUrl,
                publishDate = model.PublishDate
            };
            var res = await _httpClient.PutAsJsonAsync($"/api/Podcast/{model.IdPodcast}", updateData);

            if (res.IsSuccessStatusCode)
                return RedirectToAction("Index");

            ModelState.AddModelError("", "Không thể cập nhật podcast.");
            return View(model);
        }


        [HttpGet]
        public async Task<IActionResult> Delete(string id)
        {
            if (string.IsNullOrEmpty(id)) return NotFound();
            // Lấy podcast để confirm xoá
            var res = await _httpClient.GetAsync($"/api/Podcast/{id}");
            if (!res.IsSuccessStatusCode) return NotFound();
            var json = await res.Content.ReadAsStringAsync();
            var model = JsonConvert.DeserializeObject<PodcastViewModel>(json);
            return View(model);
        }

        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(string id)
        {
            var res = await _httpClient.DeleteAsync($"/api/Podcast/{id}");
            return RedirectToAction("Index");
        }

    }
}
