using HuitWorks.WebAPI.Data;
using HuitWorks.WebAPI.Models;
using Microsoft.AspNetCore.Mvc;

namespace HuitWorks.WebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class CompaniesController : GenericController<Company>
    {
        public CompaniesController(JobConnectDbContext ctx) : base(ctx) { }
    }
}
