using Microsoft.AspNetCore.Mvc;

namespace HuitWorks.RecruiterWeb.Controllers
{
    public class CompanyController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}
