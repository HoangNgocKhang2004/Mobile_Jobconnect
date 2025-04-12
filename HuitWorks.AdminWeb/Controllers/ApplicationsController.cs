using Microsoft.AspNetCore.Mvc;

namespace HuitWorks.AdminWeb.Controllers
{
    public class ApplicationsController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}
