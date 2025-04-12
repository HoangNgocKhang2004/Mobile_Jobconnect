using Microsoft.AspNetCore.Mvc;

namespace HuitWorks.AdminWeb.Controllers
{
    public class JobPostController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}
