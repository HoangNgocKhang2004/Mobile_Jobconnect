using HuitWorks.WebAPI.Data;
using HuitWorks.WebAPI.Models;
using Microsoft.AspNetCore.Mvc;

namespace HuitWorks.WebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class JobPostingRequiredSkillsController : GenericController<JobPostingRequiredSkill>
    {
        public JobPostingRequiredSkillsController(JobConnectDbContext ctx) : base(ctx) { }
    }
}