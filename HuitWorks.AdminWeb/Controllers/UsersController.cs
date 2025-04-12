using Microsoft.AspNetCore.Mvc;

namespace HuitWorks.AdminWeb.Controllers
{
    public class UsersController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}
