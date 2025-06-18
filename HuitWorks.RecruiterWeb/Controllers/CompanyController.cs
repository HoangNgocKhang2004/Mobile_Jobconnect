using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using HuitWorks.RecruiterWeb.Models.ViewModel;
using Google.Cloud.Storage.V1;

namespace HuitWorks.RecruiterWeb.Controllers
{
    public class CompanyController : Controller
    {
        private readonly HttpClient _httpClient;
        private readonly StorageClient _storageClient;
        private readonly string _bucketName;
        public CompanyController(IConfiguration configuration, StorageClient storageClient,
        string bucketName)
        {
            _httpClient = new HttpClient
            {
                BaseAddress = new Uri("http://localhost:5281/")
            };

            _storageClient = storageClient;
            _bucketName = bucketName;
        }
        public async Task<IActionResult> Index()
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (string.IsNullOrEmpty(userId))
                return Challenge();

            var recRes = await _httpClient.GetAsync($"/api/RecruiterInfo/{userId}");
            if (!recRes.IsSuccessStatusCode)
                return View(null);

            var recInfo = await recRes.Content.ReadFromJsonAsync<RecruiterInfoViewModel>();
            if (recInfo == null || string.IsNullOrEmpty(recInfo.IdCompany))
                return View(null);

            var compRes = await _httpClient.GetAsync("/api/Companies");
            if (!compRes.IsSuccessStatusCode)
                return View(null);

            var companies = await compRes.Content.ReadFromJsonAsync<List<CompanyViewModel>>();
            var myCompany = companies?.FirstOrDefault(c => c.IdCompany == recInfo.IdCompany);

            var packRes = await _httpClient.GetAsync("/api/SubscriptionPackage");
            var packages = packRes.IsSuccessStatusCode
                ? await packRes.Content.ReadFromJsonAsync<List<SubscriptionPackageViewModel>>()
                : new List<SubscriptionPackageViewModel>();

            var transRes = await _httpClient.GetAsync("/api/JobTransaction");
            var allTransactions = transRes.IsSuccessStatusCode
                ? await transRes.Content.ReadFromJsonAsync<List<JobTransactionViewModel>>()
                : new List<JobTransactionViewModel>();

            var latestTran = allTransactions
                ?.Where(t => t.IdUser == userId && t.Status == "Completed")
                .OrderByDescending(t => t.TransactionDate)
                .FirstOrDefault();

            if (myCompany != null)
            {
                myCompany.CurrentPackageId = latestTran?.IdPackage;
                if (latestTran != null)
                {
                    var pkg = packages?.FirstOrDefault(p => p.IdPackage == latestTran.IdPackage);
                    myCompany.PackageExpireAt = latestTran.TransactionDate.AddDays(pkg?.DurationDays ?? 0);
                }
            }

            var vm = new CompanyAccountViewModel
            {
                Company = myCompany,
                Packages = packages
            };

            return View(vm);
        }


        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> SelectPackage(string packageId)
        {
            if (string.IsNullOrEmpty(packageId))
            {
                TempData["Error"] = "Chọn gói không hợp lệ!";
                return RedirectToAction("Index");
            }

            TempData["SelectedPackageId"] = packageId;
            return RedirectToAction("Payment");
        }

        public async Task<IActionResult> Payment()
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (string.IsNullOrEmpty(userId))
                return Challenge();

            var packageId = TempData["SelectedPackageId"] as string;
            if (string.IsNullOrEmpty(packageId))
                return RedirectToAction("Index");

            var packRes = await _httpClient.GetAsync($"/api/SubscriptionPackage/{packageId}");
            var package = packRes.IsSuccessStatusCode
                ? await packRes.Content.ReadFromJsonAsync<SubscriptionPackageViewModel>()
                : null;

            if (package == null)
            {
                TempData["Error"] = "Không tìm thấy gói dịch vụ!";
                return RedirectToAction("Index");
            }

            return View(package);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(CompanyAccountViewModel vm)
        {
            if (!ModelState.IsValid)
            {
                return View("Index", vm);
            }

            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (string.IsNullOrEmpty(userId))
                return Challenge();

            static string? ExtractObjectPathFromUrl(string publicUrl, string bucketName)
            {
                // publicUrl dạng: https://firebasestorage.googleapis.com/v0/b/{bucketName}/o/{encodedPath}?alt=media&token={...}
                try
                {
                    var uri = new Uri(publicUrl);
                    var segments = uri.AbsolutePath.Split("/o/");
                    if (segments.Length < 2) return null;
                    var encoded = segments[1];
                    var endIdx = encoded.IndexOf('?');
                    if (endIdx >= 0)
                        encoded = encoded.Substring(0, endIdx);
                    return Uri.UnescapeDataString(encoded);
                }
                catch
                {
                    return null;
                }
            }

            if (vm.LogoFile != null && vm.LogoFile.Length > 0)
            {
                if (!string.IsNullOrEmpty(vm.Company?.LogoCompany))
                {
                    string? oldObjectPath = ExtractObjectPathFromUrl(vm.Company.LogoCompany, _bucketName);
                    if (!string.IsNullOrEmpty(oldObjectPath))
                    {
                        try
                        {
                            await _storageClient.DeleteObjectAsync(_bucketName, oldObjectPath);
                        }
                        catch
                        {
                        }
                    }
                }

                var ext = Path.GetExtension(vm.LogoFile.FileName).ToLowerInvariant();
                if (string.IsNullOrEmpty(ext))
                    ext = ".png";
                string logoFolder = $"users/{userId}/logo";
                string logoFileName = $"logo{ext}";
                string logoObjectPath = $"{logoFolder}/{logoFileName}";

                string logoDownloadToken = Guid.NewGuid().ToString();

                var logoObject = new Google.Apis.Storage.v1.Data.Object
                {
                    Bucket = _bucketName,
                    Name = logoObjectPath,
                    ContentType = vm.LogoFile.ContentType,
                    Metadata = new System.Collections.Generic.Dictionary<string, string>
                    {
                        { "firebaseStorageDownloadTokens", logoDownloadToken }
                    }
                };

                using (var logoStream = vm.LogoFile.OpenReadStream())
                {
                    await _storageClient.UploadObjectAsync(
                        logoObject,
                        logoStream
                    );
                }

                string encodedLogoPath = Uri.EscapeDataString(logoObjectPath);
                string logoPublicUrl = $"https://firebasestorage.googleapis.com/v0/b/{_bucketName}/o/{encodedLogoPath}?alt=media&token={logoDownloadToken}";
                vm.Company!.LogoCompany = logoPublicUrl;
            }

            if (vm.LicenseFile != null && vm.LicenseFile.Length > 0)
            {
                if (!string.IsNullOrEmpty(vm.Company?.BusinessLicenseUrl))
                {
                    string? oldLicensePath = ExtractObjectPathFromUrl(vm.Company.BusinessLicenseUrl, _bucketName);
                    if (!string.IsNullOrEmpty(oldLicensePath))
                    {
                        try
                        {
                            await _storageClient.DeleteObjectAsync(_bucketName, oldLicensePath);
                        }
                        catch
                        {
                        }
                    }
                }

                var licExt = Path.GetExtension(vm.LicenseFile.FileName).ToLowerInvariant();
                if (string.IsNullOrEmpty(licExt))
                    licExt = ".pdf";
                string licenseFolder = $"users/{userId}/licenses";
                string licenseFileName = $"license{licExt}";
                string licenseObjectPath = $"{licenseFolder}/{licenseFileName}";

                string licenseDownloadToken = Guid.NewGuid().ToString();

                var licenseObject = new Google.Apis.Storage.v1.Data.Object
                {
                    Bucket = _bucketName,
                    Name = licenseObjectPath,
                    ContentType = vm.LicenseFile.ContentType,
                    Metadata = new System.Collections.Generic.Dictionary<string, string>
                    {
                        { "firebaseStorageDownloadTokens", licenseDownloadToken }
                    }
                };

                using (var licenseStream = vm.LicenseFile.OpenReadStream())
                {
                    await _storageClient.UploadObjectAsync(
                        licenseObject,
                        licenseStream
                    );
                }

                string encodedLicensePath = Uri.EscapeDataString(licenseObjectPath);
                string licensePublicUrl = $"https://firebasestorage.googleapis.com/v0/b/{_bucketName}/o/{encodedLicensePath}?alt=media&token={licenseDownloadToken}";
                vm.Company.BusinessLicenseUrl = licensePublicUrl;
            }

            var response = await _httpClient.PutAsJsonAsync(
                $"api/Companies/{vm.Company!.IdCompany}",
                vm.Company
            );

            if (response.IsSuccessStatusCode)
            {
                TempData["Success"] = "Cập nhật thành công!";
                return RedirectToAction("Index");
            }

            ModelState.AddModelError(string.Empty, "Lỗi khi cập nhật công ty!");
            return View("Index", vm);
        }
    }
}
