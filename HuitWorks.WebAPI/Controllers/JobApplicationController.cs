using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using HuitWorks.WebAPI.Data;
using HuitWorks.WebAPI.Models;

namespace HuitWorks.WebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class JobApplicationController : ControllerBase
    {
        private readonly JobConnectDbContext _context;

        public JobApplicationController(JobConnectDbContext context)
        {
            _context = context;
        }

        // GET: api/jobapplication
        [HttpGet]
        public async Task<ActionResult<IEnumerable<JobApplication>>> GetAll()
        {
            var applications = await _context.JobApplications
                .Include(ja => ja.JobPosting)
                    .ThenInclude (cmp => cmp.Company)
                .Include(ja => ja.User)
                .ToListAsync();
            return Ok(applications);
        }

        // GET: api/jobapplication/{id}
        [HttpGet("{id}")]
        public async Task<ActionResult<JobApplication>> GetById(string id)
        {
            var application = await _context.JobApplications
                .Include(ja => ja.JobPosting)
                    .ThenInclude(cmp => cmp.Company)
                .Include(ja => ja.User)
                .FirstOrDefaultAsync(ja => ja.IdJobApp == id);

            if (application == null)
                return NotFound(new { message = "Job Application not found." });

            return Ok(application);
        }

        // POST: api/jobapplication
        [HttpPost]
        public async Task<IActionResult> Create([FromBody] JobApplication model)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var jobPostExists = await _context.JobPostings.AnyAsync(j => j.IdJobPost == model.IdJobPost);
            var userExists = await _context.Users.AnyAsync(u => u.IdUser == model.IdUser);

            if (!jobPostExists)
                return BadRequest(new { message = "Job posting does not exist." });
            if (!userExists)
                return BadRequest(new { message = "User does not exist." });

            model.IdJobApp = Guid.NewGuid().ToString();
            model.SubmittedAt = DateTime.UtcNow;
            model.UpdatedAt = DateTime.UtcNow;

            _context.JobApplications.Add(model);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetById), new { id = model.IdJobApp }, model);
        }

        // PUT: api/jobapplication/{id}
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(string id, [FromBody] JobApplication model)
        {
            if (id != model.IdJobApp)
                return BadRequest(new { message = "ID mismatch." });

            var application = await _context.JobApplications.FindAsync(id);
            if (application == null)
                return NotFound(new { message = "Job Application not found." });

            application.CvFileUrl = model.CvFileUrl;
            application.CoverLetter = model.CoverLetter;
            application.ApplicationStatus = model.ApplicationStatus;
            application.UpdatedAt = DateTime.UtcNow;

            _context.JobApplications.Update(application);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        // DELETE: api/jobapplication/{id}
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(string id)
        {
            var application = await _context.JobApplications.FindAsync(id);
            if (application == null)
                return NotFound(new { message = "Job Application not found." });

            _context.JobApplications.Remove(application);
            await _context.SaveChangesAsync();

            return NoContent();
        }
    }
}
