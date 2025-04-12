using Microsoft.AspNetCore.Mvc;

namespace HuitWorks.AdminWeb.Controllers
{
    public class CandidatesController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }

        public IActionResult ListCandidate()
        {
            return View();
        }

        public IActionResult Applications() 
        {
            return View();
        }

        public IActionResult TopCandidates()
        {
            return View();
        }
    }
}
