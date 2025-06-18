using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using HuitWorks.AdminWeb.Models.ViewModels;
using HuitWorks.AdminWeb.Models;
using Newtonsoft.Json;
using System.Text;

namespace HuitWorks.AdminWeb.Controllers
{
    [AllowAnonymous]
    public class AuthController : Controller
    {
        private readonly HttpClient _httpClient;

        public AuthController()
        {
            _httpClient = new HttpClient
            {
                BaseAddress = new Uri("http://localhost:5281/")
            };
        }

        [HttpGet]
        public IActionResult Login()
        {
            if (User.Identity.IsAuthenticated)
                return RedirectToAction("Index", "Home");

            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Login(LoginViewModel model)
        {
            if (!ModelState.IsValid)
                return View(model);

            var apiPayload = new
            {
                email = model.Username,
                password = model.Password
            };

            var response = await _httpClient.PostAsJsonAsync("/api/Auth/login", apiPayload);
            if (!response.IsSuccessStatusCode)
            {
                ModelState.AddModelError(string.Empty, "Email hoặc mật khẩu không đúng.");
                return View(model);
            }

            var json = await response.Content.ReadAsStringAsync();
            var loginResult = JsonConvert.DeserializeObject<LoginResponse>(json);

            if (loginResult?.User == null || loginResult.User.IdRole != "role3")
            {
                ModelState.AddModelError(string.Empty, "Bạn không có quyền Admin.");
                return View(model);
            }

            var claims = new List<Claim>
            {
                new Claim(ClaimTypes.NameIdentifier, loginResult.User.IdUser),
                new Claim(ClaimTypes.Name,           loginResult.User.UserName),
                new Claim(ClaimTypes.Email,          loginResult.User.Email),
                new Claim(ClaimTypes.Role,           "Admin")
            };

            var identity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);
            var principal = new ClaimsPrincipal(identity);
            var authProps = new AuthenticationProperties
            {
                IsPersistent = true,
                ExpiresUtc = DateTimeOffset.UtcNow.AddMinutes(30)
            };

            await HttpContext.SignInAsync(
                CookieAuthenticationDefaults.AuthenticationScheme,
                principal,
                authProps);

            HttpContext.Session.SetString("AdminId", loginResult.User.IdUser);
            HttpContext.Session.SetString("JwtToken", loginResult.Token);

            return RedirectToAction("Index", "Home");
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Logout()
        {
            await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
            HttpContext.Session.Clear();
            return RedirectToAction("Login");
        }

        [HttpGet]
        public IActionResult ForgotPassword() => View();

    }
}
