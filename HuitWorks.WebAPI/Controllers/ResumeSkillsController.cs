using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using HuitWorks.WebAPI.Data;
using HuitWorks.WebAPI.Models;

namespace HuitWorks.WebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ResumeSkillController : ControllerBase
    {
        private readonly JobConnectDbContext _context;

        public ResumeSkillController(JobConnectDbContext context)
        {
            _context = context;
        }

        // GET: api/resumeSkill
        [HttpGet]
        public async Task<ActionResult<IEnumerable<ResumeSkill>>> GetAll()
        {
            var skills = await _context.ResumeSkills
                .Include(rs => rs.Resume)
                    .ThenInclude(u => u.User)
                        .ThenInclude(r => r.Role)
                .ToListAsync();
            return Ok(skills);
        }

        // GET: api/resumeSkill/{idResume}
        [HttpGet("{idResume}")]
        public async Task<ActionResult<IEnumerable<ResumeSkill>>> GetByResume(string idResume)
        {
            var skills = await _context.ResumeSkills
                .Where(rs => rs.IdResume == idResume)
                .ToListAsync();

            if (skills == null || !skills.Any())
                return NotFound(new { message = "No skills found for this resume." });

            return Ok(skills);
        }

        // POST: api/resumeSkill
        [HttpPost]
        public async Task<IActionResult> Create([FromBody] ResumeSkill model)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var resumeExists = await _context.Resumes.AnyAsync(r => r.IdResume == model.IdResume);
            if (!resumeExists)
                return BadRequest(new { message = "Resume does not exist." });

            _context.ResumeSkills.Add(model);
            await _context.SaveChangesAsync();

            return Ok(model);
        }

        // PUT: api/resumeSkill
        [HttpPut]
        public async Task<IActionResult> Update([FromBody] ResumeSkill model)
        {
            var skill = await _context.ResumeSkills
                .FirstOrDefaultAsync(rs => rs.IdResume == model.IdResume && rs.Skill == model.Skill);

            if (skill == null)
                return NotFound(new { message = "Resume skill not found." });

            skill.Proficiency = model.Proficiency;

            _context.ResumeSkills.Update(skill);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        // DELETE: api/resumeSkill/{idResume}/{skill}
        [HttpDelete("{idResume}/{skill}")]
        public async Task<IActionResult> Delete(string idResume, string skill)
        {
            var skillToDelete = await _context.ResumeSkills
                .FirstOrDefaultAsync(rs => rs.IdResume == idResume && rs.Skill == skill);

            if (skillToDelete == null)
                return NotFound(new { message = "Resume skill not found." });

            _context.ResumeSkills.Remove(skillToDelete);
            await _context.SaveChangesAsync();

            return NoContent();
        }
    }
}
