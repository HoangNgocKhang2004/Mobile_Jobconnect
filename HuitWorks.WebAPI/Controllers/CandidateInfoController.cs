using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using HuitWorks.WebAPI.Data;
using HuitWorks.WebAPI.Models;

namespace HuitWorks.WebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class CandidateInfoController : ControllerBase
    {
        private readonly JobConnectDbContext _context;

        public CandidateInfoController(JobConnectDbContext context)
        {
            _context = context;
        }

        // GET: api/candidateinfo
        [HttpGet]
        public async Task<ActionResult<IEnumerable<CandidateInfo>>> GetAll()
        {
            var candidates = await _context.CandidateInfo
                .Include(c => c.User)
                    .ThenInclude(r=> r.Role)
                .ToListAsync();
            return Ok(candidates);
        }

        // GET: api/candidateinfo/{id}
        [HttpGet("{id}")]
        public async Task<ActionResult<CandidateInfo>> GetById(string id)
        {
            var candidate = await _context.CandidateInfo
                .Include(c => c.User)
                    .ThenInclude(r=> r.Role)
                .FirstOrDefaultAsync(c => c.IdUser == id);

            if (candidate == null)
                return NotFound(new { message = "CandidateInfo not found." });

            return Ok(candidate);
        }

        // POST: api/candidateinfo
        [HttpPost]
        public async Task<IActionResult> Create([FromBody] CandidateInfo model)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var userExists = await _context.Users.AnyAsync(u => u.IdUser == model.IdUser);
            if (!userExists)
                return BadRequest(new { message = "User does not exist." });

            _context.CandidateInfo.Add(model);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetById), new { id = model.IdUser }, model);
        }

        // PUT: api/candidateinfo/{id}
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(string id, [FromBody] CandidateInfo model)
        {
            if (id != model.IdUser)
                return BadRequest(new { message = "ID mismatch." });

            var existing = await _context.CandidateInfo.FindAsync(id);
            if (existing == null)
                return NotFound(new { message = "CandidateInfo not found." });

            existing.WorkPosition = model.WorkPosition;
            existing.RatingScore = model.RatingScore;
            existing.UniversityName = model.UniversityName;
            existing.EducationLevel = model.EducationLevel;
            existing.ExperienceYears = model.ExperienceYears;
            existing.Skills = model.Skills;
            existing.User = null; // Không cho phép cập nhật navigation User qua API này

            _context.CandidateInfo.Update(existing);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        // DELETE: api/candidateinfo/{id}
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(string id)
        {
            var candidate = await _context.CandidateInfo.FindAsync(id);
            if (candidate == null)
                return NotFound(new { message = "CandidateInfo not found." });

            _context.CandidateInfo.Remove(candidate);
            await _context.SaveChangesAsync();

            return NoContent();
        }
    }
}
