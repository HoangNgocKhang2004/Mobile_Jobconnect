using Microsoft.AspNetCore.Mvc;

namespace HuitWorks.RecruiterWeb.Controllers
{
    public class BlogsController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}
