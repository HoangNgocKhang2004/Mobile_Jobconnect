using Microsoft.AspNetCore.Mvc;

namespace HuitWorks.RecruiterWeb.Controllers
{
    public class AuthController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
        public IActionResult Login()
        {
            return View();
        }
        [HttpPost]
        public IActionResult Login(string email, string password)
        {
            if (email == "admin@huitworks.vn" && password == "123456")
            {
                // Đăng nhập thành công
                HttpContext.Session.SetString("UserEmail", email);
                return RedirectToAction("Index", "Home");
            }
            // Đăng nhập thất bại
            ViewBag.Error = "Email hoặc mật khẩu không chính xác";
            return View();
        }

        public IActionResult Register()
        {
            return View();
        }

    }
}
