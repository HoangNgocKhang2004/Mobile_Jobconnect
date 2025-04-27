using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using HuitWorks.WebAPI.Data;
using HuitWorks.WebAPI.Models;

namespace HuitWorks.WebAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class RecruiterInfoController : ControllerBase
    {
        private readonly JobConnectDbContext _dbContext;

        public RecruiterInfoController(JobConnectDbContext dbContext)
        {
            _dbContext = dbContext;
        }

        [HttpGet("{id}")]
        //[Authorize]
        public async Task<IActionResult> GetRecruiterInfo(string id)
        {
            Console.WriteLine($"Received ID: {id}");
            var recruiter = await _dbContext.RecruiterInfo
                .Include(ri => ri.User)
                .ThenInclude(u => u.Role)
                .Include(ri => ri.Company)
                .FirstOrDefaultAsync(ri => ri.IdUser == id);

            if (recruiter == null)
            {
                Console.WriteLine("Recruiter not found");
                return NotFound();
            }

            return Ok(recruiter);
        }
    }
}