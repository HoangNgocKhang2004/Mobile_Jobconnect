using HuitWorks.WebAPI.Data;
using HuitWorks.WebAPI.Models;
using Microsoft.AspNetCore.Mvc;

namespace HuitWorks.WebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class RolesController : GenericController<Role>
    {
        public RolesController(JobConnectDbContext ctx) : base(ctx) { }
    }
}
