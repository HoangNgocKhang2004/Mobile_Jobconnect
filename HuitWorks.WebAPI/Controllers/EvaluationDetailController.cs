using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using HuitWorks.WebAPI.Data;
using HuitWorks.WebAPI.DTOs;
using HuitWorks.WebAPI.Models;

namespace HuitWorks.WebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class EvaluationDetailController : ControllerBase
    {
        private readonly JobConnectDbContext _context;

        public EvaluationDetailController(JobConnectDbContext context)
        {
            _context = context;
        }

        // GET: api/evaluationdetail
        [HttpGet("all")]
        public async Task<ActionResult<IEnumerable<EvaluationDetailDto>>> GetAll()
        {
            var list = await _context.EvaluationDetails
                .Select(ed => new EvaluationDetailDto
                {
                    EvaluationDetailId = ed.EvaluationDetailId,
                    EvaluationId = ed.EvaluationId,
                    CriterionId = ed.CriterionId,
                    Score = ed.Score,
                    Comments = ed.Comments
                })
                .ToListAsync();

            return Ok(list);
        }

        // GET: api/evaluationdetail?evaluationId=xxx
        [HttpGet]
        public async Task<ActionResult<IEnumerable<EvaluationDetailDto>>> GetByEvaluation(
            [FromQuery] string evaluationId = null)
        {
            var query = _context.EvaluationDetails
                                .AsNoTracking()
                                .AsQueryable();

            if (!string.IsNullOrWhiteSpace(evaluationId))
                query = query.Where(d => d.EvaluationId == evaluationId);

            var list = await query
                .OrderBy(d => d.CriterionId)
                .Select(d => new EvaluationDetailDto
                {
                    EvaluationDetailId = d.EvaluationDetailId,
                    EvaluationId = d.EvaluationId,
                    CriterionId = d.CriterionId,
                    Score = d.Score,
                    Comments = d.Comments
                })
                .ToListAsync();

            return Ok(list);
        }

        // GET: api/evaluationdetail/{id}
        [HttpGet("{id}")]
        public async Task<ActionResult<EvaluationDetailDto>> GetById(string id)
        {
            var ed = await _context.EvaluationDetails
                .Where(e => e.EvaluationDetailId == id)
                .Select(e => new EvaluationDetailDto
                {
                    EvaluationDetailId = e.EvaluationDetailId,
                    EvaluationId = e.EvaluationId,
                    CriterionId = e.CriterionId,
                    Score = e.Score,
                    Comments = e.Comments
                })
                .FirstOrDefaultAsync();

            if (ed == null)
                return NotFound(new { message = "Không tìm thấy chi tiết đánh giá." });

            return Ok(ed);
        }

        // POST: api/evaluationdetail
        [HttpPost]
        public async Task<ActionResult<EvaluationDetailDto>> Create([FromBody] CreateEvaluationDetailDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            // Kiểm tra trùng EvaluationDetailId
            if (await _context.EvaluationDetails.AnyAsync(e => e.EvaluationDetailId == dto.EvaluationDetailId))
                return BadRequest(new { message = "EvaluationDetailId đã tồn tại." });

            var entity = new EvaluationDetail
            {
                EvaluationDetailId = Guid.NewGuid().ToString(),
                EvaluationId = dto.EvaluationId,
                CriterionId = dto.CriterionId,
                Score = dto.Score,
                Comments = dto.Comments
            };

            _context.EvaluationDetails.Add(entity);
            await _context.SaveChangesAsync();

            var result = new EvaluationDetailDto
            {
                EvaluationDetailId = entity.EvaluationDetailId,
                EvaluationId = entity.EvaluationId,
                CriterionId = entity.CriterionId,
                Score = entity.Score,
                Comments = entity.Comments
            };

            return CreatedAtAction(nameof(GetById), new { id = result.EvaluationDetailId }, result);
        }

        // PUT: api/evaluationdetail/{id}
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(string id, [FromBody] UpdateEvaluationDetailDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var existing = await _context.EvaluationDetails.FindAsync(id);
            if (existing == null)
                return NotFound(new { message = "Không tìm thấy chi tiết đánh giá." });

            existing.Score = dto.Score ?? existing.Score;
            existing.Comments = dto.Comments ?? existing.Comments;

            _context.EvaluationDetails.Update(existing);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        // DELETE: api/evaluationdetail/{id}
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(string id)
        {
            var existing = await _context.EvaluationDetails.FindAsync(id);
            if (existing == null)
                return NotFound(new { message = "Không tìm thấy chi tiết đánh giá." });

            _context.EvaluationDetails.Remove(existing);
            await _context.SaveChangesAsync();

            return NoContent();
        }
    }
}
