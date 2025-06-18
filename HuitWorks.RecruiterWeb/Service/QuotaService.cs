using System;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text.Json;
using System.Threading.Tasks;
using HuitWorks.RecruiterWeb.Models.ViewModel;
using Microsoft.AspNetCore.Http;

namespace HuitWorks.RecruiterWeb.Service
{
    public class QuotaService : IQuotaService
    {
        private readonly IHttpClientFactory _httpClientFactory;
        private readonly IHttpContextAccessor _httpContextAccessor;

        public QuotaService(IHttpClientFactory httpClientFactory,
                            IHttpContextAccessor httpContextAccessor)
        {
            _httpClientFactory = httpClientFactory;
            _httpContextAccessor = httpContextAccessor;
        }

        /// <summary>
        /// Lấy transaction đang active (chưa hết hạn) và đã Completed của user.
        /// </summary>
        public async Task<JobTransactionViewModel?> GetActiveTransactionAsync(string userId)
        {
            if (string.IsNullOrEmpty(userId))
                return null;

            var client = _httpClientFactory.CreateClient("ApiClient");

            var token = _httpContextAccessor?.HttpContext?.Session.GetString("JwtToken");
            if (!string.IsNullOrEmpty(token))
            {
                client.DefaultRequestHeaders.Authorization =
                    new AuthenticationHeaderValue("Bearer", token);
            }

            var response = await client.GetAsync($"/api/JobTransaction/user/{userId}");
            if (!response.IsSuccessStatusCode)
                return null;

            var json = await response.Content.ReadAsStringAsync();
            var allTx = JsonSerializer.Deserialize<JobTransactionViewModel[]>(json, new JsonSerializerOptions
            {
                PropertyNameCaseInsensitive = true
            });

            if (allTx == null || allTx.Length == 0)
                return null;

            var now = DateTime.UtcNow;
            var activeTx = allTx
                .Where(t => t.Status == "Completed"
                            && t.ExpiryDate >= now
                            && t.RemainingJobPosts > 0)
                .OrderByDescending(t => t.ExpiryDate)
                .FirstOrDefault();

            return activeTx;
        }
    }
}
