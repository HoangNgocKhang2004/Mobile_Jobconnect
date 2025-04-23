using HuitWorks.WebAPI.Data;
using HuitWorks.WebAPI.Models;
using Microsoft.AspNetCore.Mvc;

namespace HuitWorks.WebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class CandidateInfoController : GenericController<CandidateInfo>
    {
        public CandidateInfoController(JobConnectDbContext ctx) : base(ctx) { }
    }
}