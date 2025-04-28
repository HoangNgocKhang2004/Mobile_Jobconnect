using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using HuitWorks.WebAPI.Data;
using HuitWorks.WebAPI.Models;

namespace HuitWorks.WebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class JobPostingController : ControllerBase
    {
        private readonly JobConnectDbContext _context;

        public JobPostingController(JobConnectDbContext context)
        {
            _context = context;
        }

        // GET: api/jobposting
        [HttpGet]
        public async Task<ActionResult<IEnumerable<JobPosting>>> GetAll()
        {
            var jobPostings = await _context.JobPostings
                .Include(jp => jp.Company)
                .ToListAsync();
            return Ok(jobPostings);
        }

        // GET: api/jobposting/{id}
        [HttpGet("{id}")]
        public async Task<ActionResult<JobPosting>> GetById(string id)
        {
            var jobPosting = await _context.JobPostings
                .Include(jp => jp.Company)
                .FirstOrDefaultAsync(jp => jp.IdJobPost == id);

            if (jobPosting == null)
                return NotFound(new { message = "JobPosting not found." });

            return Ok(jobPosting);
        }

        // POST: api/jobposting
        [HttpPost]
        public async Task<IActionResult> Create([FromBody] JobPosting model)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var companyExists = await _context.Companies.AnyAsync(c => c.IdCompany == model.IdCompany);
            if (!companyExists)
                return BadRequest(new { message = "Company does not exist." });

            model.IdJobPost = Guid.NewGuid().ToString();
            model.CreatedAt = DateTime.UtcNow;
            model.UpdatedAt = DateTime.UtcNow;

            _context.JobPostings.Add(model);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetById), new { id = model.IdJobPost }, model);
        }

        // PUT: api/jobposting/{id}
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(string id, [FromBody] JobPosting model)
        {
            if (id != model.IdJobPost)
                return BadRequest(new { message = "ID mismatch." });

            var existing = await _context.JobPostings.FindAsync(id);
            if (existing == null)
                return NotFound(new { message = "JobPosting not found." });

            existing.Title = model.Title;
            existing.Description = model.Description;
            existing.Requirements = model.Requirements;
            existing.Salary = model.Salary;
            existing.Location = model.Location;
            existing.WorkType = model.WorkType;
            existing.ExperienceLevel = model.ExperienceLevel;
            existing.IdCompany = model.IdCompany;
            existing.ApplicationDeadline = model.ApplicationDeadline;
            existing.Benefits = model.Benefits;
            existing.PostStatus = model.PostStatus;
            existing.UpdatedAt = DateTime.UtcNow;

            _context.JobPostings.Update(existing);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        // DELETE: api/jobposting/{id}
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(string id)
        {
            var jobPosting = await _context.JobPostings.FindAsync(id);
            if (jobPosting == null)
                return NotFound(new { message = "JobPosting not found." });

            _context.JobPostings.Remove(jobPosting);
            await _context.SaveChangesAsync();

            return NoContent();
        }
    }
}
