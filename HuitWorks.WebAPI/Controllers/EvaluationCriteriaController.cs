using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using HuitWorks.WebAPI.Data;
using HuitWorks.WebAPI.DTOs;
using HuitWorks.WebAPI.Models;

namespace HuitWorks.WebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class EvaluationCriteriaController : ControllerBase
    {
        private readonly JobConnectDbContext _context;

        public EvaluationCriteriaController(JobConnectDbContext context)
        {
            _context = context;
        }

        // GET: api/evaluationcriteria
        [HttpGet]
        public async Task<ActionResult<IEnumerable<EvaluationCriteriaDto>>> GetAll()
        {
            var list = await _context.EvaluationCriterias
                .Select(ec => new EvaluationCriteriaDto
                {
                    CriterionId = ec.CriterionId,
                    Name = ec.Name,
                    Description = ec.Description,
                    CreatedAt = ec.CreatedAt
                })
                .ToListAsync();

            return Ok(list);
        }

        // GET: api/evaluationcriteria/{id}
        [HttpGet("{id}")]
        public async Task<ActionResult<EvaluationCriteriaDto>> GetById(string id)
        {
            var ec = await _context.EvaluationCriterias
                .Where(e => e.CriterionId == id)
                .Select(e => new EvaluationCriteriaDto
                {
                    CriterionId = e.CriterionId,
                    Name = e.Name,
                    Description = e.Description,
                    CreatedAt = e.CreatedAt
                })
                .FirstOrDefaultAsync();

            if (ec == null)
                return NotFound(new { message = "Không tìm thấy tiêu chí đánh giá." });

            return Ok(ec);
        }

        // POST: api/evaluationcriteria
        [HttpPost]
        public async Task<ActionResult<EvaluationCriteriaDto>> Create([FromBody] CreateEvaluationCriteriaDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            // Kiểm tra CriterionId đã tồn tại chưa
            //if (await _context.EvaluationCriterias.AnyAsync(e => e.CriterionId == dto.CriterionId))
            //    return BadRequest(new { message = "CriterionId đã tồn tại." });

            var entity = new EvaluationCriteria
            {
                CriterionId = Guid.NewGuid().ToString(),
                Name = dto.Name,
                Description = dto.Description,
                CreatedAt = DateTime.UtcNow
            };

            _context.EvaluationCriterias.Add(entity);
            await _context.SaveChangesAsync();

            var result = new EvaluationCriteriaDto
            {
                CriterionId = entity.CriterionId,
                Name = entity.Name,
                Description = entity.Description,
                CreatedAt = entity.CreatedAt
            };

            return CreatedAtAction(nameof(GetById), new { id = result.CriterionId }, result);
        }

        // PUT: api/evaluationcriteria/{id}
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(string id, [FromBody] UpdateEvaluationCriteriaDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var existing = await _context.EvaluationCriterias.FindAsync(id);
            if (existing == null)
                return NotFound(new { message = "Không tìm thấy tiêu chí đánh giá." });

            existing.Name = dto.Name ?? existing.Name;
            existing.Description = dto.Description ?? existing.Description;

            _context.EvaluationCriterias.Update(existing);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        // DELETE: api/evaluationcriteria/{id}
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(string id)
        {
            var existing = await _context.EvaluationCriterias.FindAsync(id);
            if (existing == null)
                return NotFound(new { message = "Không tìm thấy tiêu chí đánh giá." });

            _context.EvaluationCriterias.Remove(existing);
            await _context.SaveChangesAsync();

            return NoContent();
        }
    }
}
