using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using HuitWorks.WebAPI.Data;
using HuitWorks.WebAPI.Models;

namespace HuitWorks.WebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class RecruiterInfoController : ControllerBase
    {
        private readonly JobConnectDbContext _context;

        public RecruiterInfoController(JobConnectDbContext context)
        {
            _context = context;
        }

        // GET: api/recruiterinfo
        [HttpGet]
        public async Task<ActionResult<IEnumerable<RecruiterInfo>>> GetAll()
        {
            var recruiters = await _context.RecruiterInfo
                .Include(r => r.User)
                    .ThenInclude(r => r.Role)
                .Include(r => r.Company)
                .ToListAsync();
            return Ok(recruiters);
        }

        // GET: api/recruiterinfo/{id}
        [HttpGet("{id}")]
        public async Task<ActionResult<RecruiterInfo>> GetById(string id)
        {
            var recruiter = await _context.RecruiterInfo
                .Include(r => r.User)
                    .ThenInclude(r => r.Role)
                .Include(r => r.Company)
                .FirstOrDefaultAsync(r => r.IdUser == id);

            if (recruiter == null)
            {
                return NotFound(new { message = "RecruiterInfo not found." });
            }

            return Ok(recruiter);
        }

        // POST: api/recruiterinfo
        [HttpPost]
        public async Task<IActionResult> Create([FromBody] RecruiterInfo model)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var userExists = await _context.Users.AnyAsync(u => u.IdUser == model.IdUser);
            if (!userExists)
                return BadRequest(new { message = "User does not exist." });

            _context.RecruiterInfo.Add(model);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetById), new { id = model.IdUser }, model);
        }

        // PUT: api/recruiterinfo/{id}
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(string id, [FromBody] RecruiterInfo model)
        {
            if (id != model.IdUser)
                return BadRequest(new { message = "ID mismatch." });

            var existing = await _context.RecruiterInfo.FindAsync(id);
            if (existing == null)
                return NotFound(new { message = "RecruiterInfo not found." });

            existing.Title = model.Title;
            existing.IdCompany = model.IdCompany;
            existing.Department = model.Department;
            existing.Description = model.Description;
            existing.User = null;      // Không sửa User ở đây
            existing.Company = null;   // Không sửa Company ở đây

            _context.RecruiterInfo.Update(existing);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        // DELETE: api/recruiterinfo/{id}
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(string id)
        {
            var recruiter = await _context.RecruiterInfo.FindAsync(id);
            if (recruiter == null)
                return NotFound(new { message = "RecruiterInfo not found." });

            _context.RecruiterInfo.Remove(recruiter);
            await _context.SaveChangesAsync();

            return NoContent();
        }
    }
}
