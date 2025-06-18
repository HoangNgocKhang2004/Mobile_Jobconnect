using System.Net.Http.Headers;
using System.Net.Http.Json;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using HuitWorks.RecruiterWeb.Models.ViewModel;
using System.Security.Claims;
using HuitWorks.RecruiterWeb.Models;
using Newtonsoft.Json;
using System.IO;
using System.Text;
using FirebaseAdmin.Auth;
using static System.Net.WebRequestMethods;
using FirebaseAdmin;
using Google.Apis.Auth.OAuth2;
using System.Text.Json;
using System.Text.Json.Serialization;
using Newtonsoft.Json.Linq;
using System.ComponentModel.DataAnnotations;
using System.Net.Mail;
using Google.Cloud.Storage.V1;

[AllowAnonymous]
public class AuthController : Controller
{
    private readonly IHttpClientFactory _httpClientFactory;
    private readonly HttpClient _api;
    private readonly IWebHostEnvironment _env;
    private readonly string _firebaseWebApiKey;
    private readonly StorageClient _storageClient;
    private readonly string _bucketName;
    public AuthController(IHttpClientFactory httpClientFactory,
                          IWebHostEnvironment env, IConfiguration configuration, StorageClient storageClient,
        string bucketName)
    {
        _httpClientFactory = httpClientFactory;
        _api = _httpClientFactory.CreateClient("ApiClient");
        _env = env;
        if (FirebaseApp.DefaultInstance == null)
        {
            var credPath = Path.Combine(_env.ContentRootPath, "serviceAccountKey.json");
            FirebaseApp.Create(new AppOptions
            {
                Credential = GoogleCredential.FromFile(credPath)
            });
        }
        _firebaseWebApiKey = configuration["Firebase:WebApiKey"];
        _storageClient = storageClient;
        _bucketName = bucketName;
    }

    [HttpGet]
    public IActionResult Login()
        => View(new LoginViewModel());

    [HttpPost, ValidateAntiForgeryToken]
    public async Task<IActionResult> Login(LoginViewModel model)
    {
        if (!ModelState.IsValid)
            return View(model);

        var loginRes = await _api.PostAsJsonAsync("api/Auth/login", new
        {
            email = model.Email,
            password = model.Password
        });

        if (!loginRes.IsSuccessStatusCode)
        {
            ModelState.AddModelError("", "Email hoặc mật khẩu không đúng.");
            return View(model);
        }

        var loginResult = await loginRes.Content.ReadFromJsonAsync<LoginResponse>();
        var user = loginResult?.User;

        if (user?.accountStatus?.ToLower() != "active" || user.IdRole != "role1")
        {
            ModelState.AddModelError("", "Tài khoản chưa được kích hoạt hoặc không có quyền.");
            return View(model);
        }

        var claims = new List<Claim>
        {
            new Claim(ClaimTypes.NameIdentifier, user.IdUser),
            new Claim(ClaimTypes.Name, user.UserName),
            new Claim(ClaimTypes.Email, user.Email ?? ""),
            new Claim(ClaimTypes.Role, user.IdRole),
            new Claim("avatar", user.AvatarUrl ?? "")
        };

        var identity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);
        var principal = new ClaimsPrincipal(identity);

        await HttpContext.SignInAsync(
            CookieAuthenticationDefaults.AuthenticationScheme,
            principal,
            new AuthenticationProperties
            {
                IsPersistent = true,
                ExpiresUtc = DateTime.UtcNow.AddMinutes(30)
            });

        HttpContext.Session.SetString("JwtToken", loginResult.Token);

        _api.DefaultRequestHeaders.Authorization =
            new AuthenticationHeaderValue("Bearer", loginResult.Token);

        return RedirectToAction("Index", "Home");
    }


    // GET: /Auth/RegisterRecruiter
    [HttpGet]
    public IActionResult RegisterRecruiter()
    {
        var file = Path.Combine(_env.WebRootPath, "data", "provinces.json");
        var json = System.IO.File.ReadAllText(file);
        var provinces = JsonConvert.DeserializeObject<List<ProvinceDto>>(json)
                        ?? new List<ProvinceDto>();

        var vm = new RegisterRecruiterViewModel
        {
            Provinces = provinces
        };
        return View(vm);
    }


    [HttpPost, ValidateAntiForgeryToken]
    public async Task<IActionResult> RegisterRecruiter(RegisterRecruiterViewModel model)
    {
        if (!ModelState.IsValid)
            return View(model);

        string? phoneE164 = null;
        if (!string.IsNullOrWhiteSpace(model.PhoneNumber))
        {
            var raw = model.PhoneNumber.Trim();
            if (raw.StartsWith("+")) phoneE164 = raw;
            else if (raw.StartsWith("0")) phoneE164 = "+84" + raw.Substring(1);
            else
            {
                ModelState.AddModelError(nameof(model.PhoneNumber),
                    "Số điện thoại không hợp lệ. Ví dụ: 0901234561 hoặc +84901234561");
                return View(model);
            }
        }

        var registerDto = new
        {
            userName = model.UserName,
            email = model.Email,
            password = model.Password,
            phoneNumber = phoneE164,
            roleName = "Recruiter"
        };

        var regRes = await _api.PostAsJsonAsync("api/Auth/register", registerDto);
        if (!regRes.IsSuccessStatusCode)
        {
            var error = await regRes.Content.ReadAsStringAsync();
            ModelState.AddModelError("", $"Đăng ký thất bại ({regRes.StatusCode}): {error}");
            return View(model);
        }

        var location = regRes.Headers.Location;
        if (location == null || !location.Segments.Any())
        {
            ModelState.AddModelError("", "Không tìm thấy Location header từ API register.");
            return View(model);
        }
        var userId = location.Segments.Last().TrimEnd('/');

        try
        {
            var userArgs = new UserRecordArgs
            {
                Uid = userId,
                Email = model.Email,
                EmailVerified = false,
                PhoneNumber = phoneE164,
                Password = model.Password,
                DisplayName = model.UserName,
            };
            await FirebaseAuth.DefaultInstance.CreateUserAsync(userArgs);
        }
        catch (FirebaseAuthException ex)
        {
            await _api.DeleteAsync($"api/User/{userId}");
            ModelState.AddModelError("", $"Firebase Auth error: {ex.Message}");
            return View(model);
        }

        string businessLicenseUrl = "";
        if (model.BusinessLicenseFile != null && model.BusinessLicenseFile.Length > 0)
        {
            var licExt = Path.GetExtension(model.BusinessLicenseFile.FileName).ToLowerInvariant();
            if (string.IsNullOrEmpty(licExt)) licExt = ".pdf";
            string licenseFolder = $"users/{userId}/licenses";
            string licenseFileName = $"license{licExt}";
            string licenseObjectPath = $"{licenseFolder}/{licenseFileName}";

            try
            {
                await _storageClient.DeleteObjectAsync(_bucketName, licenseObjectPath);
            }
            catch {  }

            string licenseDownloadToken = Guid.NewGuid().ToString();

            var licenseObject = new Google.Apis.Storage.v1.Data.Object
            {
                Bucket = _bucketName,
                Name = licenseObjectPath,
                ContentType = model.BusinessLicenseFile.ContentType,
                Metadata = new Dictionary<string, string>
                {
                    { "firebaseStorageDownloadTokens", licenseDownloadToken }
                }
            };

            using (var stream = model.BusinessLicenseFile.OpenReadStream())
            {
                await _storageClient.UploadObjectAsync(licenseObject, stream);
            }

            string encodedPath = Uri.EscapeDataString(licenseObjectPath);
            businessLicenseUrl = $"https://firebasestorage.googleapis.com/v0/b/{_bucketName}/o/{encodedPath}?alt=media&token={licenseDownloadToken}";
        }

        var compDto = new
        {
            companyName = model.CompanyName,
            taxCode = model.TaxCode,
            address = model.Address,
            description = model.Description,
            logoCompany = "/images/logo.png",
            websiteUrl = model.WebsiteUrl,
            scale = model.Scale,
            industry = model.Industry,
            businessLicenseUrl = businessLicenseUrl,
            status = "active",
            isFeatured = 0
        };

        var compRes = await _api.PostAsJsonAsync("api/Companies", compDto);
        if (!compRes.IsSuccessStatusCode)
        {
            var err = await compRes.Content.ReadAsStringAsync();
            await FirebaseAuth.DefaultInstance.DeleteUserAsync(userId);
            await _api.DeleteAsync($"api/User/{userId}");
            ModelState.AddModelError("", $"Tạo công ty thất bại ({compRes.StatusCode}): {err}");
            return View(model);
        }

        var compVm = await compRes.Content.ReadFromJsonAsync<CompanyViewModel>();
        var compId = compVm?.IdCompany;
        if (string.IsNullOrEmpty(compId))
        {
            ModelState.AddModelError("", "Không lấy được IdCompany từ API Companies.");
            return View(model);
        }

        var hrDto = new
        {
            idUser = userId,
            title = model.Title,
            idCompany = compId,
            department = model.Department,
            description = ""
        };
        var hrRes = await _api.PostAsJsonAsync("api/RecruiterInfo", hrDto);
        if (!hrRes.IsSuccessStatusCode)
        {
            var err = await hrRes.Content.ReadAsStringAsync();
            // rollback Company & User
            await _api.DeleteAsync($"api/Companies/{compId}");
            await FirebaseAuth.DefaultInstance.DeleteUserAsync(userId);
            await _api.DeleteAsync($"api/User/{userId}");
            ModelState.AddModelError("", $"Tạo RecruiterInfo thất bại ({hrRes.StatusCode}): {err}");
            return View(model);
        }

        TempData["Success"] = "Đăng ký thành công! Vui lòng đăng nhập.";
        return RedirectToAction("Login", "Auth");
    }


    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> Logout()
    {
        await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
        HttpContext.Session.Clear();
        return RedirectToAction("Login");
    }
    // GET: /Auth/ForgotPassword
    [HttpGet]
    public IActionResult ForgotPassword()
    {
        return View(new ForgotPasswordViewModel());
    }

    // POST: /Auth/ForgotPassword
    [HttpPost]
    [ValidateAntiForgeryToken]
    public async Task<IActionResult> ForgotPassword(ForgotPasswordViewModel model)
    {
        if (!ModelState.IsValid)
        {
            return View(model);
        }

        var emailTrimmed = model?.Email?.Trim().ToLowerInvariant();

        try
        {
            var endpoint = $"https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key={_firebaseWebApiKey}";

            var payload = new Dictionary<string, string>
                {
                    { "requestType", "PASSWORD_RESET" },
                    { "email", emailTrimmed }
                };

            var json = JsonConvert.SerializeObject(payload);
            var httpContent = new StringContent(json, Encoding.UTF8, "application/json");

            using (var httpClient = new HttpClient())
            {
                var response = await httpClient.PostAsync(endpoint, httpContent);
                var responseBody = await response.Content.ReadAsStringAsync();

                if (response.IsSuccessStatusCode)
                {
                    ViewBag.SuccessMessage = "Nếu email tồn tại, bạn sẽ nhận được liên kết đặt lại mật khẩu trong hộp thư.";
                    return View(new ForgotPasswordViewModel());
                }
                else
                {
                    dynamic errorResp = JsonConvert.DeserializeObject(responseBody);
                    string errorMessage = "Đã có lỗi xảy ra. Vui lòng thử lại.";

                    if (errorResp?.error?.message != null)
                    {
                        string code = errorResp.error.message;
                        if (code == "EMAIL_NOT_FOUND")
                        {
                            errorMessage = "Không tìm thấy tài khoản với địa chỉ email này.";
                        }
                        else
                        {
                            errorMessage = code;
                        }
                    }

                    ModelState.AddModelError(string.Empty, errorMessage);
                    return View(model);
                }
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"[ForgotPassword] Exception: {ex}");
            ModelState.AddModelError(string.Empty, "Đã có lỗi xảy ra. Vui lòng thử lại sau.");
            return View(model);
        }
    }


    [HttpPost, AllowAnonymous, IgnoreAntiforgeryToken]
    public async Task<IActionResult> ExternalLogin([FromBody] ExternalLoginModel model)
    {
        if (!ModelState.IsValid)
            return BadRequest(ModelState);

        var apiRes = await _api.PostAsJsonAsync("api/Auth/social-login", new
        {
            idToken = model.IdToken,
            email = model.Email,
            name = model.Name
        });
        if (!apiRes.IsSuccessStatusCode)
        {
            var err = await apiRes.Content.ReadAsStringAsync();
            return StatusCode((int)apiRes.StatusCode, $"Social-login failed: {err}");
        }

        var dto = await apiRes.Content.ReadFromJsonAsync<SocialLoginResponseDto>();
        if (dto == null || string.IsNullOrWhiteSpace(dto.Token))
            return StatusCode(500, "Invalid response from social-login");

        var claims = new List<Claim>
        {
            new Claim(ClaimTypes.NameIdentifier, dto.User.IdUser),
            new Claim(ClaimTypes.Name,           dto.User.UserName ?? ""),
            new Claim(ClaimTypes.Email,          dto.User.Email    ?? ""),
            new Claim(ClaimTypes.Role,           dto.User.IdRole   ?? ""),

            new Claim("avatar", dto.User.AvatarUrl ?? "")
        };

        await HttpContext.SignInAsync(
            CookieAuthenticationDefaults.AuthenticationScheme,
            new ClaimsPrincipal(new ClaimsIdentity(
                claims, CookieAuthenticationDefaults.AuthenticationScheme)),
            new AuthenticationProperties
            {
                IsPersistent = true,
                ExpiresUtc = DateTime.UtcNow.AddMinutes(30)
            });

        HttpContext.Session.SetString("JwtToken", dto.Token);
        _api.DefaultRequestHeaders.Authorization =
            new AuthenticationHeaderValue("Bearer", dto.Token);

        return Ok(new { needProfile = dto.NeedProfile });
    }
}
public class ExternalLoginModel
{
    [Required, JsonPropertyName("idToken")]
    public string IdToken { get; set; } = null!;

    [Required, EmailAddress, JsonPropertyName("email")]
    public string Email { get; set; } = null!;

    [Required, JsonPropertyName("name")]
    public string Name { get; set; } = null!;
}

// Models/LocationDtos.cs

public class ProvinceDto
{
    public int code { get; set; }
    public string? name { get; set; }
    public List<DistrictDto>? districts { get; set; }
}

public class DistrictDto
{
    public int code { get; set; }
    public string? name { get; set; }
    public List<WardDto>? wards { get; set; }
}

public class WardDto
{
    public int code { get; set; }
    public string? name { get; set; }
}

