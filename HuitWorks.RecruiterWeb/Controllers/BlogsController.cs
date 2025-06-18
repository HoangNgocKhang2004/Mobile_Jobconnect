using Microsoft.AspNetCore.Mvc;
using System.Text.Json;
using HuitWorks.RecruiterWeb.Models;

namespace HuitWorks.RecruiterWeb.Controllers
{
    public class BlogsController : Controller
    {
        private readonly HttpClient _httpClient;
        private readonly JsonSerializerOptions _jsonOptions;

        public BlogsController()
        {
            _httpClient = new HttpClient { BaseAddress = new Uri("http://localhost:5281/") };
            _jsonOptions = new JsonSerializerOptions
            {
                PropertyNameCaseInsensitive = true,
                Converters = { new System.Text.Json.Serialization.JsonStringEnumConverter() }
            };
        }

        public async Task<IActionResult> Index(int page = 1, int pageSize = 6)
        {
            var res = await _httpClient.GetAsync("/api/News");
            if (!res.IsSuccessStatusCode)
            {
                ViewBag.News = new List<News>();
                return View(new List<News>());
            }

            var stream = await res.Content.ReadAsStreamAsync();
            var newsList = await JsonSerializer.DeserializeAsync<List<News>>(stream, _jsonOptions) ?? new List<News>();

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
            ViewBag.TotalItems = totalItems;

            return View(paginated);
        }
    }
}
