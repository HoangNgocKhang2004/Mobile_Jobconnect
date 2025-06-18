using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using HuitWorks.WebAPI.Data;
using HuitWorks.WebAPI.DTOs;
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

        private string GetCurrentUserId()
        {
            return User.FindFirst(ClaimTypes.NameIdentifier)?.Value
                   ?? User.FindFirst("sub")?.Value
                   ?? "";
        }

        // ===============================
        // 1) GET: api/resume
        // ===============================
        [HttpGet]
        public async Task<ActionResult<IEnumerable<ResumeDto>>> GetAll()
        {
            var list = await _context.Resumes
                .Select(r => new ResumeDto
                {
                    IdResume = r.IdResume,
                    IdUser = r.IdUser,
                    FileUrl = r.FileUrl,
                    FileName = r.FileName,
                    FileSizeKB = r.FileSizeKB,
                    IsDefault = r.IsDefault,
                    CreatedAt = r.CreatedAt,
                    UpdatedAt = r.UpdatedAt
                })
                .ToListAsync();

            return Ok(list);
        }

        // =======================================================
        // 2) GET: api/resume/{idUser}
        // =======================================================
        [HttpGet("{idUser}")]
        public async Task<ActionResult<IEnumerable<ResumeDto>>> GetByIdUser(string idUser)
        {
            var list = await _context.Resumes
                .Where(r => r.IdUser == idUser)
                .Select(r => new ResumeDto
                {
                    IdResume = r.IdResume,
                    IdUser = r.IdUser,
                    FileUrl = r.FileUrl,
                    FileName = r.FileName,
                    FileSizeKB = r.FileSizeKB,
                    IsDefault = r.IsDefault,
                    CreatedAt = r.CreatedAt,
                    UpdatedAt = r.UpdatedAt
                })
                .ToListAsync();

            if (list == null)
                return NotFound(new { message = "Không tìm thấy hồ sơ." });

            return Ok(list);
        }

        // ================================================================
        // 3) GET: api/resume/by-user/{userId} 
        // ================================================================
        [HttpGet("by-user/{candidateId}")]
        public async Task<IActionResult> GetByUser(string candidateId)
        {
            var resume = await _context.Resumes
                .Where(r => r.IdUser == candidateId)
                .OrderByDescending(r => r.IsDefault)
                .FirstOrDefaultAsync();

            if (resume == null)
                return NotFound(new { message = "Ứng viên chưa có hồ sơ." });

            var idViewer = GetCurrentUserId();
            if (string.IsNullOrEmpty(idViewer))
                return Unauthorized(new { message = "Không tìm thấy thông tin user." });

            var nowUtc = DateTime.UtcNow;
            var activeTx = await _context.JobTransactions
                .Where(t =>
                    t.IdUser == idViewer &&
                    t.Status == "Completed" &&
                    t.ExpiryDate >= nowUtc &&
                    t.RemainingCvViews > 0)
                .OrderByDescending(t => t.ExpiryDate)
                .FirstOrDefaultAsync();

            if (activeTx == null)
                return BadRequest(new { message = "Bạn đã hết lượt xem hồ sơ hoặc không có gói xem hồ sơ hợp lệ." });

            activeTx.RemainingCvViews -= 1;
            _context.JobTransactions.Update(activeTx);

            var log = new CvViewUsageLog
            {
                IdLog = Guid.NewGuid().ToString(),
                IdTransaction = activeTx.IdTransaction,
                IdResume = resume.IdResume,
                UsedAt = nowUtc
            };
            _context.CvViewUsageLogs.Add(log);

            await _context.SaveChangesAsync();

            var result = new ResumeDto
            {
                IdResume = resume.IdResume,
                IdUser = resume.IdUser,
                FileUrl = resume.FileUrl,
                FileName = resume.FileName,
                FileSizeKB = resume.FileSizeKB,
                IsDefault = resume.IsDefault,
                CreatedAt = resume.CreatedAt,
                UpdatedAt = resume.UpdatedAt
            };
            return Ok(result);
        }

        // ===============================
        // 4) POST: api/resume
        // ===============================
        [HttpPost]
        public async Task<ActionResult<ResumeDto>> Create([FromBody] CreateResumeDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            if (!await _context.Users.AnyAsync(u => u.IdUser == dto.IdUser))
                return BadRequest(new { message = "Người dùng không tồn tại." });

            var entity = new Resume
            {
                IdResume = Guid.NewGuid().ToString(),
                IdUser = dto.IdUser,
                FileUrl = dto.FileUrl,
                FileName = dto.FileName,
                FileSizeKB = dto.FileSizeKB,
                IsDefault = dto.IsDefault,
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow
            };

            _context.Resumes.Add(entity);
            await _context.SaveChangesAsync();

            var result = new ResumeDto
            {
                IdResume = entity.IdResume,
                IdUser = entity.IdUser,
                FileUrl = entity.FileUrl,
                FileName = entity.FileName,
                FileSizeKB = entity.FileSizeKB,
                IsDefault = entity.IsDefault,
                CreatedAt = entity.CreatedAt,
                UpdatedAt = entity.UpdatedAt
            };
            return CreatedAtAction(nameof(GetByIdUser), new { idUser = result.IdUser }, result);
        }

        // ===============================
        // 5) PUT: api/resume/{id}
        // ===============================
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(string id, [FromBody] UpdateResumeDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var entity = await _context.Resumes.FindAsync(id);
            if (entity == null)
                return NotFound(new { message = "Không tìm thấy hồ sơ." });

            entity.FileUrl = dto.FileUrl ?? entity.FileUrl;
            entity.FileName = dto.FileName ?? entity.FileName;
            entity.FileSizeKB = dto.FileSizeKB ?? entity.FileSizeKB;
            entity.IsDefault = dto.IsDefault ?? entity.IsDefault;
            entity.UpdatedAt = DateTime.UtcNow;

            _context.Resumes.Update(entity);
            await _context.SaveChangesAsync();
            return NoContent();
        }

        // ===============================
        // 6) DELETE: api/resume/{id}
        // ===============================
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(string id)
        {
            var entity = await _context.Resumes.FindAsync(id);
            if (entity == null)
                return NotFound(new { message = "Không tìm thấy hồ sơ." });

            _context.Resumes.Remove(entity);
            await _context.SaveChangesAsync();
            return NoContent();
        }
    }
}
