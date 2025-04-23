using HuitWorks.WebAPI.Data;
using HuitWorks.WebAPI.Models;
using Microsoft.AspNetCore.Mvc;

namespace HuitWorks.WebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class JobApplicationController : GenericController<JobApplication>
    {
        public JobApplicationController(JobConnectDbContext ctx) : base(ctx) { }
    }
}