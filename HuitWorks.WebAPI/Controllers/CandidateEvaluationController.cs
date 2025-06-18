using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using HuitWorks.WebAPI.Data;
using HuitWorks.WebAPI.DTOs;
using HuitWorks.WebAPI.Models;

namespace HuitWorks.WebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class CandidateEvaluationController : ControllerBase
    {
        private readonly JobConnectDbContext _context;

        public CandidateEvaluationController(JobConnectDbContext context)
        {
            _context = context;
        }

        // 1) GET api/candidateevaluation?… (lọc qua query-string)
        [HttpGet]
        public async Task<ActionResult<IEnumerable<CandidateEvaluationDto>>> Get(
            [FromQuery] string idJobPost = null,
            [FromQuery] string idCandidate = null,
            [FromQuery] string idRecruiter = null)
        {
            var query = _context.CandidateEvaluations.AsNoTracking().AsQueryable();

            if (!string.IsNullOrWhiteSpace(idJobPost))
                query = query.Where(e => e.IdJobPost == idJobPost);
            if (!string.IsNullOrWhiteSpace(idCandidate))
                query = query.Where(e => e.IdCandidate == idCandidate);
            if (!string.IsNullOrWhiteSpace(idRecruiter))
                query = query.Where(e => e.IdRecruiter == idRecruiter);

            var list = await query
                .OrderByDescending(e => e.CreatedAt)
                .Select(e => new CandidateEvaluationDto
                {
                    EvaluationId = e.EvaluationId,
                    IdJobPost = e.IdJobPost,
                    IdCandidate = e.IdCandidate,
                    IdRecruiter = e.IdRecruiter,
                    CreatedAt = e.CreatedAt
                })
                .ToListAsync();

            return Ok(list);
        }

        // 2) GET api/candidateevaluation/{id}
        [HttpGet("{id}")]
        public async Task<ActionResult<CandidateEvaluationDto>> GetById(string id)
        {
            var ce = await _context.CandidateEvaluations
                .AsNoTracking()
                .Where(e => e.EvaluationId == id)
                .Select(e => new CandidateEvaluationDto
                {
                    EvaluationId = e.EvaluationId,
                    IdJobPost = e.IdJobPost,
                    IdCandidate = e.IdCandidate,
                    IdRecruiter = e.IdRecruiter,
                    CreatedAt = e.CreatedAt
                })
                .FirstOrDefaultAsync();

            if (ce == null) return NotFound();
            return Ok(ce);
        }


        // POST: api/candidateevaluation
        [HttpPost]
        public async Task<ActionResult<CandidateEvaluationDto>> Create([FromBody] CreateCandidateEvaluationDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            // Kiểm tra trùng EvaluationId
            if (await _context.CandidateEvaluations.AnyAsync(e => e.EvaluationId == dto.EvaluationId))
                return BadRequest(new { message = "EvaluationId đã tồn tại." });

            var entity = new CandidateEvaluation
            {
                EvaluationId = dto.EvaluationId,
                IdJobPost = dto.IdJobPost,
                IdCandidate = dto.IdCandidate,
                IdRecruiter = dto.IdRecruiter,
                CreatedAt = DateTime.UtcNow
            };

            _context.CandidateEvaluations.Add(entity);
            await _context.SaveChangesAsync();

            var result = new CandidateEvaluationDto
            {
                EvaluationId = entity.EvaluationId,
                IdJobPost = entity.IdJobPost,
                IdCandidate = entity.IdCandidate,
                IdRecruiter = entity.IdRecruiter,
                CreatedAt = entity.CreatedAt
            };

            return CreatedAtAction(nameof(GetById), new { id = result.EvaluationId }, result);
        }

        // PUT: api/candidateevaluation/{id}
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(string id, [FromBody] UpdateCandidateEvaluationDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var existing = await _context.CandidateEvaluations.FindAsync(id);
            if (existing == null)
                return NotFound(new { message = "Không tìm thấy đánh giá ứng viên." });

            existing.IdJobPost = dto.IdJobPost ?? existing.IdJobPost;
            existing.IdCandidate = dto.IdCandidate ?? existing.IdCandidate;
            existing.IdRecruiter = dto.IdRecruiter ?? existing.IdRecruiter;

            _context.CandidateEvaluations.Update(existing);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        // DELETE: api/candidateevaluation/{id}
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(string id)
        {
            var existing = await _context.CandidateEvaluations.FindAsync(id);
            if (existing == null)
                return NotFound(new { message = "Không tìm thấy đánh giá ứng viên." });

            _context.CandidateEvaluations.Remove(existing);
            await _context.SaveChangesAsync();

            return NoContent();
        }
    }
}
