using HuitWorks.RecruiterWeb.Models.ViewModel;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System.Security.Claims;
using HuitWorks.RecruiterWeb.Models;
using System.Globalization;
using HuitWorks.RecruiterWeb.Models.Dtos;

namespace HuitWorks.RecruiterWeb.Controllers
{
    public class ServiceController : Controller
    {
        private readonly HttpClient _httpClient;

        public ServiceController()
        {
            _httpClient = new HttpClient
            {
                BaseAddress = new Uri("http://localhost:5281/")
            };
        }

        public async Task<IActionResult> Index(int page = 1, int pageSize = 6)
        {
            var hrId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (string.IsNullOrEmpty(hrId))
                return Challenge();

            var resp = await _httpClient.GetAsync("/api/JobTransaction");
            if (!resp.IsSuccessStatusCode)
                return View(new List<JobTransactionViewModel>());

            var allTrans = await resp.Content.ReadFromJsonAsync<List<JobTransactionViewModel>>();
            var myTrans = allTrans?
                .Where(t => t.IdUser == hrId)
                .OrderByDescending(t => t.TransactionDate)
            .ToList()
            ?? new List<JobTransactionViewModel>();

            int totalItems = myTrans.Count;
            int totalPages = (int)Math.Ceiling((double)totalItems / pageSize);

            var paginatedmyTrans = myTrans
                .Skip((page - 1) * pageSize)
            .Take(pageSize)
                .ToList();

            ViewBag.CurrentPage = page;
            ViewBag.TotalPages = totalPages;

            return View(paginatedmyTrans);
        }

        public IActionResult TopUp()
        {
            return View();
        }

        public async Task<IActionResult> Details(string id)
        {
            if (string.IsNullOrEmpty(id)) return NotFound();

            var response = await _httpClient.GetAsync($"/api/JobTransactionDetails/{id}");
            if (!response.IsSuccessStatusCode)
                return View("Index");

            var detail = await response.Content.ReadFromJsonAsync<JobTransactionDetailViewModel>();
            return View(detail);
        }

        public async Task<IActionResult> ReportError(string id)
        {
            ViewBag.TransactionId = id;
            return View();
        }

        // GET: /Service/Create
        [HttpGet]
        public async Task<IActionResult> Create()
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            string? activePackageId = null;

            if (!string.IsNullOrEmpty(userId))
            {
                try
                {
                    var transactionResp = await _httpClient.GetAsync($"api/JobTransaction?userId={userId}");
                    if (transactionResp.IsSuccessStatusCode)
                    {
                        var transactionJson = await transactionResp.Content.ReadAsStringAsync();
                        var trxList = JsonConvert.DeserializeObject<List<JobTransactionDto>>(transactionJson);
                        if (trxList != null && trxList.Any())
                        {
                            var latestCompleted = trxList
                            .Where(t =>
                                string.Equals(t.Status, "Completed", StringComparison.OrdinalIgnoreCase)
                                && t.IdUser == userId)
                            .OrderByDescending(t => t.TransactionDate)
                            .FirstOrDefault();


                            if (latestCompleted != null)
                            {
                                activePackageId = latestCompleted.IdPackage;
                            }
                        }
                    }
                }
                catch
                {
                }
            }

            var resp = await _httpClient.GetAsync("api/SubscriptionPackage");
            if (!resp.IsSuccessStatusCode)
            {
                ModelState.AddModelError("", "Không tải được danh sách gói dịch vụ.");
                return View(new SubscriptionPackagesViewModel());
            }

            var json = await resp.Content.ReadAsStringAsync();
            var all = JsonConvert.DeserializeObject<List<SubscriptionPackageDto>>(json) ?? new List<SubscriptionPackageDto>();
            var active = all.Where(x => x.IsActive).ToList();

            var vm = new SubscriptionPackagesViewModel
            {
                Packages = active,
                ActivePackageId = activePackageId
            };

            return View(vm);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Pay(string packageId, string paymentMethod, string confirmed)
        {
            var userId = User.Claims.FirstOrDefault(c => c.Type == ClaimTypes.NameIdentifier)?.Value;
            if (string.IsNullOrEmpty(userId) || string.IsNullOrEmpty(packageId))
            {
                TempData["Error"] = "Dữ liệu không hợp lệ!";
                return RedirectToAction("Index");
            }

            if (paymentMethod == "Bank Transfer" && confirmed != "true")
            {
                TempData["Info"] = "Vui lòng chuyển khoản rồi bấm 'Tôi đã chuyển khoản xong'.";
                return RedirectToAction("Payment", new { packageId });
            }

            var recRes = await _httpClient.GetAsync($"api/RecruiterInfo/{userId}");
            if (!recRes.IsSuccessStatusCode)
            {
                TempData["Error"] = "Không tìm thấy recruiter!";
                return RedirectToAction("Index");
            }
            var recInfo = await recRes.Content.ReadFromJsonAsync<RecruiterInfoViewModel>();

            var pkgRes = await _httpClient.GetAsync($"api/SubscriptionPackage/{packageId}");
            if (!pkgRes.IsSuccessStatusCode)
            {
                TempData["Error"] = "Gói không tồn tại!";
                return RedirectToAction("Index");
            }
            var pkg = await pkgRes.Content.ReadFromJsonAsync<SubscriptionPackageViewModel>();

            var trxPayload = new
            {
                idUser = userId,
                idPackage = packageId,
                amount = pkg?.Price,
                paymentMethod = paymentMethod,
                transactionDate = DateTime.UtcNow,
                status = "Pending"
            };
            var trxResponse = await _httpClient.PostAsJsonAsync("api/JobTransaction", trxPayload);
            if (!trxResponse.IsSuccessStatusCode)
            {
                TempData["Error"] = "Tạo giao dịch thất bại. Vui lòng thử lại!";
                return RedirectToAction("Payment", new { packageId });
            }

            var createdTrx = await trxResponse.Content.ReadFromJsonAsync<JobTransactionDto>();
            var transactionId = createdTrx?.IdTransaction;

            var detailsPayload = new
            {
                idTransaction = transactionId,
                amountFormatted = $"{pkg.Price:N0} VND",
                amountInWords = NumberToVietnameseWords(pkg.Price) + " đồng",
                senderName = "Người dùng",
                senderBank = "Ngân hàng",
                receiverName = "Công ty ABC",
                receiverBank = "Vietcombank",
                content = $"Thanh toán gói {pkg.PackageName}",
                fee = "Miễn phí"
            };
            var detResponse = await _httpClient.PostAsJsonAsync("api/JobTransactionDetails", detailsPayload);
            if (!detResponse.IsSuccessStatusCode)
            {
                var errorBody = await detResponse.Content.ReadAsStringAsync();
                TempData["Warning"] = $"Không lưu chi tiết giao dịch: {errorBody}";
            }

            var compRes = await _httpClient.GetAsync($"api/Companies/{recInfo?.IdCompany}");
            if (!compRes.IsSuccessStatusCode)
            {
                TempData["Warning"] = "Giao dịch thành công nhưng không cập nhật được công ty.";
                return RedirectToAction("Index");
            }
            var company = await compRes.Content.ReadFromJsonAsync<CompanyViewModel>();
            company.CurrentPackageId = packageId;
            company.PackageExpireAt = DateTime.UtcNow.AddDays(pkg.DurationDays);

            var updRes = await _httpClient.PutAsJsonAsync($"api/Companies/{company.IdCompany}", company);
            if (!updRes.IsSuccessStatusCode)
                TempData["Warning"] = "Cập nhật gói công ty thất bại!";
            else
                TempData["Success"] = "Thanh toán thành công và gói đã được kích hoạt!";

            return RedirectToAction("Index");
        }

        private string NumberToVietnameseWords(decimal number)
        {
            return number.ToString("N0");
        }

        [HttpGet]
        public async Task<IActionResult> MyServices()
        {
            var userId = User.Claims
                             .FirstOrDefault(c => c.Type == ClaimTypes.NameIdentifier)?
                             .Value;
            if (string.IsNullOrEmpty(userId))
                return RedirectToAction("Login", "Account");

            var pkgResp = await _httpClient.GetAsync("api/SubscriptionPackage");
            var allPkgs = pkgResp.IsSuccessStatusCode
                ? JsonConvert.DeserializeObject<List<SubscriptionPackageDto>>(await pkgResp.Content.ReadAsStringAsync())
                : new List<SubscriptionPackageDto>();

            var transResp = await _httpClient.GetAsync("api/JobTransaction");
            var allTrans = transResp.IsSuccessStatusCode
                ? JsonConvert.DeserializeObject<List<JobTransactionDto>>(await transResp.Content.ReadAsStringAsync())
                : new List<JobTransactionDto>();

            var userTrans = allTrans
                .Where(t => t.IdUser == userId)
                .OrderByDescending(t => t.TransactionDate)
                .ToList();

            var vm = new List<MyServiceViewModel>();
            foreach (var t in userTrans)
            {
                var pkg = allPkgs.FirstOrDefault(p => p.IdPackage == t.IdPackage);

                var det = new JobTransactionDetailsDto();
                var detResp = await _httpClient.GetAsync($"api/JobTransactionDetails/{t.IdTransaction}");
                if (detResp.IsSuccessStatusCode)
                {
                    det = JsonConvert.DeserializeObject<JobTransactionDetailsDto>(
                        await detResp.Content.ReadAsStringAsync());
                }

                vm.Add(new MyServiceViewModel
                {
                    TransactionId = t.IdTransaction,
                    PackageName = pkg?.PackageName ?? "(Unknown)",
                    StartDate = t.TransactionDate,
                    ExpireDate = pkg == null ? (DateTime?)null : t.TransactionDate.AddDays(pkg.DurationDays),
                    Price = t.Amount,
                    PaymentMethod = t.PaymentMethod,
                    Status = t.Status,
                    Details = det
                });
            }

            return View(vm);
        }

        public IActionResult TransactionHistory()
        {
            return View();
        }
    }
}
