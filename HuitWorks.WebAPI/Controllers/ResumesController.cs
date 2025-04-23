using HuitWorks.WebAPI.Data;
using HuitWorks.WebAPI.Models;
using Microsoft.AspNetCore.Mvc;

namespace HuitWorks.WebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ResumesController : GenericController<Resume>
    {
        public ResumesController(JobConnectDbContext ctx) : base(ctx) { }
    }
}