using Microsoft.AspNetCore.Mvc;

namespace HuitWorks.RecruiterWeb.Controllers
{
    public class CandidatesController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}
