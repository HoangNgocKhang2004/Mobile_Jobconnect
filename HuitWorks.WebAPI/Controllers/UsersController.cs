using HuitWorks.WebAPI.Data;
using HuitWorks.WebAPI.Models;
using Microsoft.AspNetCore.Mvc;

namespace HuitWorks.WebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UsersController : GenericController<User>
    {
        public UsersController(JobConnectDbContext ctx) : base(ctx) { }
    }
}