using Microsoft.AspNetCore.Mvc;

namespace HuitWorks.RecruiterWeb.Controllers
{
    public class ChatController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
    }
}
