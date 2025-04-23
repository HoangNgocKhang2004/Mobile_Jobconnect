using HuitWorks.WebAPI.Data;
using HuitWorks.WebAPI.Models;
using Microsoft.AspNetCore.Mvc;

namespace HuitWorks.WebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class RecruiterInfoController : GenericController<RecruiterInfo>
    {
        public RecruiterInfoController(JobConnectDbContext ctx) : base(ctx) { }
    }
}