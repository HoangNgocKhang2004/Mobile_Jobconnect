using HuitWorks.RecruiterWeb.Models.Dtos;
using HuitWorks.RecruiterWeb.Models.ViewModel;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;
using HuitWorks.RecruiterWeb.Models;
using System.Net;
using HuitWorks.RecruiterWeb.Service;
using Google.Cloud.Storage.V1;

namespace HuitWorks.RecruiterWeb.Controllers
{
    public class AccountController : Controller
    {
        private readonly HttpClient _httpClient;
        private readonly StorageClient _storageClient;
        private readonly string _bucketName;
        public AccountController(StorageClient storageClient,
        string bucketName)
        {
            _httpClient = new HttpClient
            {
                BaseAddress = new Uri("http://localhost:5281/")
            };
            _storageClient = storageClient;
            _bucketName = bucketName;
        }

        // GET: /Account/Activities
        [HttpGet]
        public async Task<IActionResult> Activities(int? pageNumber)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (string.IsNullOrEmpty(userId))
            {
                return RedirectToAction("Login", "Auth");
            }

            var logPayload = new
            {
                IdLog = Guid.NewGuid().ToString(),
                IdUser = userId,
                ActionType = "ViewActivities",
                Description = "Xem trang Lịch sử hoạt động",
                EntityName = "userActivityLog",
                EntityId = userId,
                IpAddress = HttpContext.Connection.RemoteIpAddress?.ToString(),
                UserAgent = Request.Headers["User-Agent"].ToString()
            };
            await _httpClient.PostAsJsonAsync("api/UserActivityLog", logPayload);

            var resp = await _httpClient.GetAsync("api/UserActivityLog");
            List<UserActivityLogDto> allLogs = new();
            if (resp.IsSuccessStatusCode)
            {
                allLogs = await resp.Content.ReadFromJsonAsync<List<UserActivityLogDto>>() ?? new();
            }

            var userLogs = allLogs
                .Where(l => l.IdUser == userId)
                .OrderByDescending(l => l.CreatedAt)
                .ToList();

            int pageSize = 10;
            int currentPage = pageNumber ?? 1;
            var pagedLogs = PaginatedList<UserActivityLogDto>.Create(userLogs, currentPage, pageSize);

            return View(pagedLogs);
        }

        // GET: /Account/Settings
        [HttpGet]
        public async Task<IActionResult> Settings()
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (string.IsNullOrEmpty(userId))
            {
                TempData["Error"] = "Không xác định được người dùng.";
                return RedirectToAction("Index", "Home");
            }

            var userRes = await _httpClient.GetAsync($"/api/User/{userId}");
            if (!userRes.IsSuccessStatusCode)
            {
                TempData["Error"] = "Không lấy được thông tin tài khoản.";
                return RedirectToAction("Index", "Home");
            }

            var userDto = await userRes.Content.ReadFromJsonAsync<UserViewModel>();
            if (userDto == null)
            {
                TempData["Error"] = "Dữ liệu tài khoản không hợp lệ.";
                return RedirectToAction("Index", "Home");
            }

            RecruiterInfoViewModel? recDto = null;
            var recRes = await _httpClient.GetAsync($"/api/RecruiterInfo/{userId}");
            if (recRes.IsSuccessStatusCode)
            {
                recDto = await recRes.Content.ReadFromJsonAsync<RecruiterInfoViewModel>();
            }

            var model = new SettingsViewModel
            {
                IdUser = userDto.IdUser,
                UserName = userDto.UserName,
                Email = userDto.Email,
                PhoneNumber = userDto.PhoneNumber,
                IdRole = userDto.IdRole,
                AccountStatus = userDto.AccountStatus,
                Gender = userDto.Gender,
                Address = userDto.Address,
                DateOfBirth = userDto.DateOfBirth,
                AvatarUrl = string.IsNullOrWhiteSpace(userDto.AvatarUrl)
                                  ? Url.Content("~/images/default-avatar.png")
                                  : userDto.AvatarUrl,
                SocialLogin = userDto.SocialLogin,
                CreatedAt = userDto.CreatedAt,
                UpdatedAt = userDto.UpdatedAt,

                Title = recDto?.Title,
                IdCompany = recDto?.IdCompany,
                Department = recDto?.Department,
                Description = recDto?.Description
            };

            return View(model);
        }

        // POST: /Account/Settings
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Settings(SettingsViewModel model)
        {
            if (!ModelState.IsValid)
            {
                return View(model);
            }

            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (string.IsNullOrEmpty(userId) || userId != model.IdUser)
            {
                TempData["Error"] = "Dữ liệu không hợp lệ.";
                return View(model);
            }

            if (model.AvatarFile != null && model.AvatarFile.Length > 0)
            {
                if (!string.IsNullOrEmpty(model.AvatarUrl))
                {
                    string? ExtractObjectPath(string publicUrl)
                    {
                        try
                        {
                            var uri = new Uri(publicUrl);
                            var parts = uri.AbsolutePath.Split("/o/");
                            if (parts.Length < 2) return null;
                            var encoded = parts[1];
                            var idx = encoded.IndexOf('?');
                            if (idx >= 0) encoded = encoded.Substring(0, idx);
                            return Uri.UnescapeDataString(encoded);
                        }
                        catch
                        {
                            return null;
                        }
                    }

                    var oldObjectPath = ExtractObjectPath(model.AvatarUrl);
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

                var ext = Path.GetExtension(model.AvatarFile.FileName).ToLowerInvariant();
                if (string.IsNullOrEmpty(ext)) ext = ".png";
                string avatarFolder = $"users/{userId}/avatars";
                string avatarFileName = $"avatar{ext}";
                string avatarObjectPath = $"{avatarFolder}/{avatarFileName}";

                string avatarToken = Guid.NewGuid().ToString();
                var avatarObject = new Google.Apis.Storage.v1.Data.Object
                {
                    Bucket = _bucketName,
                    Name = avatarObjectPath,
                    ContentType = model.AvatarFile.ContentType,
                    Metadata = new Dictionary<string, string>
            {
                { "firebaseStorageDownloadTokens", avatarToken }
            }
                };

                using (var stream = model.AvatarFile.OpenReadStream())
                {
                    await _storageClient.UploadObjectAsync(avatarObject, stream);
                }

                string encodedAvatarPath = Uri.EscapeDataString(avatarObjectPath);
                string avatarPublicUrl = $"https://firebasestorage.googleapis.com/v0/b/{_bucketName}/o/{encodedAvatarPath}?alt=media&token={avatarToken}";

                model.AvatarUrl = avatarPublicUrl;
            }

            var payload = new
            {
                idUser = model.IdUser,
                userName = model.UserName,
                email = model.Email,
                phoneNumber = model.PhoneNumber,
                gender = model.Gender,
                address = model.Address,
                idRole = model.IdRole,
                accountStatus = model.AccountStatus,
                dateOfBirth = model.DateOfBirth.HasValue
                                  ? model.DateOfBirth.Value.ToString("yyyy-MM-ddTHH:mm:ssZ")
                                  : (string?)null,
                avatarUrl = model.AvatarUrl,
                socialLogin = model.SocialLogin,
                createdAt = model.CreatedAt?.ToString("yyyy-MM-ddTHH:mm:ssZ"),
                updatedAt = DateTime.UtcNow.ToString("yyyy-MM-ddTHH:mm:ssZ")
            };

            var putUserRes = await _httpClient.PutAsJsonAsync($"/api/User/{model.IdUser}", payload);
            if (!putUserRes.IsSuccessStatusCode)
            {
                var serverError = await putUserRes.Content.ReadAsStringAsync();
                TempData["Error"] = $"Cập nhật tài khoản thất bại: {serverError}";
                return View(model);
            }

            var recResCheck = await _httpClient.GetAsync($"/api/RecruiterInfo/{model.IdUser}");
            if (recResCheck.IsSuccessStatusCode)
            {
                var updateRecPayload = new
                {
                    idUser = model.IdUser,
                    title = model.Title,
                    idCompany = model.IdCompany,
                    department = model.Department,
                    description = model.Description
                };
                var putRecRes = await _httpClient.PutAsJsonAsync(
                    $"/api/RecruiterInfo/{model.IdUser}",
                    updateRecPayload
                );
                if (!putRecRes.IsSuccessStatusCode)
                {
                    var recErr = await putRecRes.Content.ReadAsStringAsync();
                    TempData["Warning"] = $"Cập nhật RecruiterInfo không thành công: {recErr}";
                }
            }
            else if (recResCheck.StatusCode == HttpStatusCode.NotFound)
            {
                var createRecPayload = new
                {
                    idUser = model.IdUser,
                    title = model.Title,
                    idCompany = model.IdCompany,
                    department = model.Department,
                    description = model.Description
                };
                var postRecRes = await _httpClient.PostAsJsonAsync(
                    "/api/RecruiterInfo",
                    createRecPayload
                );
                if (!postRecRes.IsSuccessStatusCode)
                {
                    var recErr = await postRecRes.Content.ReadAsStringAsync();
                    TempData["Warning"] = $"Tạo mới RecruiterInfo không thành công: {recErr}";
                }
            }
            else
            {
                TempData["Warning"] = "Lỗi khi kiểm tra thông tin RecruiterInfo.";
            }

            TempData["Success"] = "Cập nhật thông tin thành công!";
            return RedirectToAction("Settings");
        }

    }
}
