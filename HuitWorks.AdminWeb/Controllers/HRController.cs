using Microsoft.AspNetCore.Mvc;

namespace HuitWorks.AdminWeb.Controllers
{
    public class HRController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }

        public IActionResult UserManagement()
        {
            return View();
        }

        public IActionResult VerificationRequests()
        {
            return View();
        }

        public IActionResult ManageRoles()
        {
            return View();
        }

        public IActionResult Details(int id)
        {
            return View();
        }

        public IActionResult Edit(int id)
        {
            return View();
        }
    }
}
