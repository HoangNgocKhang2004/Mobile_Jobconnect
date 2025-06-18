using HuitWorks.RecruiterWeb.Service;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

namespace HuitWorks.RecruiterWeb.Controllers
{
    [Authorize]
    [Route("api/[controller]/[action]")]
    public class QuotaController : Controller
    {
        private readonly IQuotaService _quotaService;

        public QuotaController(IQuotaService quotaService)
        {
            _quotaService = quotaService;
        }

        [HttpGet]
        public async Task<IActionResult> HasActiveQuota()
        {
            var recruiterId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (string.IsNullOrEmpty(recruiterId))
            {
                // Chưa đăng nhập → trả về false (hoặc 401 tùy bạn muốn)
                return Json(new { hasQuota = false });
            }

            var activeTx = await _quotaService.GetActiveTransactionAsync(recruiterId);
            bool hasQuota = activeTx != null;
            return Json(new { hasQuota = hasQuota });
        }
    }
}
