using HuitWorks.AdminWeb.Models;
using Microsoft.AspNetCore.Mvc;
using System.Text;
using System.Text.Json;

namespace HuitWorks.AdminWeb.Controllers
{
    public class NewsController : Controller
    {
        private readonly HttpClient _httpClient;
        private readonly JsonSerializerOptions _jsonOptions;

        public NewsController()
        {
            _httpClient = new HttpClient { BaseAddress = new Uri("http://localhost:5281") };
            _jsonOptions = new JsonSerializerOptions
            {
                PropertyNameCaseInsensitive = true,
                Converters = { new System.Text.Json.Serialization.JsonStringEnumConverter() } 
            };
        }

        public async Task<IActionResult> Index(int page = 1, int pageSize = 6)
        {
            var response = await _httpClient.GetAsync("/api/News");
            if (!response.IsSuccessStatusCode)
            {
                TempData["ErrorMessage"] = "Lấy danh sách tin tức thất bại.";
                return View(new List<News>());
            }

            var stream = await response.Content.ReadAsStreamAsync();
            var newsList = await JsonSerializer.DeserializeAsync<List<News>>(stream, _jsonOptions) ?? new List<News>();

            // Phân trang
            int totalItems = newsList.Count;
            int totalPages = (int)Math.Ceiling((double)totalItems / pageSize);
            page = Math.Max(1, Math.Min(page, totalPages > 0 ? totalPages : 1));

            var paginated = newsList
                .OrderByDescending(n => n.PublishDate)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToList();

            ViewBag.CurrentPage = page;
            ViewBag.TotalPages = totalPages;
            ViewBag.PageSize = pageSize;
            ViewBag.TotalItems = totalItems;

            return View(paginated);
        }

        public async Task<IActionResult> Details(int id)
        {
            var response = await _httpClient.GetAsync($"/api/News/{id}");
            if (!response.IsSuccessStatusCode)
            {
                TempData["ErrorMessage"] = "Không tìm thấy tin tức.";
                return RedirectToAction("Index");
            }
            var stream = await response.Content.ReadAsStreamAsync();
            var news = await JsonSerializer.DeserializeAsync<News>(stream, _jsonOptions);
            return View(news);
        }

        [HttpGet]
        public async Task<IActionResult> Edit(int id)
        {
            var response = await _httpClient.GetAsync($"/api/News/{id}");
            if (!response.IsSuccessStatusCode)
            {
                TempData["ErrorMessage"] = "Không tìm thấy tin tức.";
                return RedirectToAction("Index");
            }
            var stream = await response.Content.ReadAsStreamAsync();
            var news = await JsonSerializer.DeserializeAsync<News>(stream, _jsonOptions);
            return View(news);
        }


        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(News model)
        {
            if (!ModelState.IsValid)
                return View(model);

            var content = new StringContent(JsonSerializer.Serialize(model, _jsonOptions), Encoding.UTF8, "application/json");
            var response = await _httpClient.PutAsync($"/api/News/{model.idNews}", content);

            if (response.IsSuccessStatusCode)
            {
                TempData["Success"] = "Cập nhật tin tức thành công!";
                return RedirectToAction("Index");
            }
            else
            {
                TempData["ErrorMessage"] = "Cập nhật tin tức thất bại.";
                return View(model);
            }
        }


    }
}
