using HuitWorks.WebAPI.Data;
using HuitWorks.WebAPI.Models;
using Microsoft.AspNetCore.Mvc;

namespace HuitWorks.WebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class JobPostingController : GenericController<JobPosting>
    {
        public JobPostingController(JobConnectDbContext ctx) : base(ctx) { }
    }
}