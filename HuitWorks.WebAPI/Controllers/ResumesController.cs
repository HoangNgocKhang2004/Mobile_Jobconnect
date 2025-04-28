using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using HuitWorks.WebAPI.Data;
using HuitWorks.WebAPI.Models;

namespace HuitWorks.WebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ResumeController : ControllerBase
    {
        private readonly JobConnectDbContext _context;

        public ResumeController(JobConnectDbContext context)
        {
            _context = context;
        }

        // GET: api/resume
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Resume>>> GetAll()
        {
            var resumes = await _context.Resumes
                .Include(r => r.User)
                    .ThenInclude(r => r.Role)
                .Include(r => r.ResumeSkills)
                .ToListAsync();
            return Ok(resumes);
        }

        // GET: api/resume/{id}
        [HttpGet("{id}")]
        public async Task<ActionResult<Resume>> GetById(string id)
        {
            var resume = await _context.Resumes
                .Include(r => r.User)
                    .ThenInclude(r => r.Role)
                .Include(r => r.ResumeSkills)
                .FirstOrDefaultAsync(r => r.IdResume == id);

            if (resume == null)
                return NotFound(new { message = "Resume not found." });

            return Ok(resume);
        }

        // POST: api/resume
        [HttpPost]
        public async Task<IActionResult> Create([FromBody] Resume model)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var userExists = await _context.Users.AnyAsync(u => u.IdUser == model.IdUser);
            if (!userExists)
                return BadRequest(new { message = "User does not exist." });

            model.IdResume = Guid.NewGuid().ToString();
            model.CreatedAt = DateTime.UtcNow;
            model.UpdatedAt = DateTime.UtcNow;

            _context.Resumes.Add(model);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetById), new { id = model.IdResume }, model);
        }

        // PUT: api/resume/{id}
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(string id, [FromBody] Resume model)
        {
            if (id != model.IdResume)
                return BadRequest(new { message = "ID mismatch." });

            var resume = await _context.Resumes.FindAsync(id);
            if (resume == null)
                return NotFound(new { message = "Resume not found." });

            resume.FileUrl = model.FileUrl;
            resume.FileName = model.FileName;
            resume.FileSizeKB = model.FileSizeKB;
            resume.IsDefault = model.IsDefault;
            resume.UpdatedAt = DateTime.UtcNow;

            _context.Resumes.Update(resume);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        // DELETE: api/resume/{id}
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(string id)
        {
            var resume = await _context.Resumes.FindAsync(id);
            if (resume == null)
                return NotFound(new { message = "Resume not found." });

            _context.Resumes.Remove(resume);
            await _context.SaveChangesAsync();

            return NoContent();
        }
    }
}
