// Controllers/PodcastController.cs
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using HuitWorks.WebAPI.Data;
using HuitWorks.WebAPI.DTOs;
using HuitWorks.WebAPI.Models;

namespace HuitWorks.WebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class PodcastController : ControllerBase
    {
        private readonly JobConnectDbContext _context;

        public PodcastController(JobConnectDbContext context)
        {
            _context = context;
        }

        // GET: api/podcast
        [HttpGet]
        public async Task<ActionResult<IEnumerable<PodcastDto>>> GetAll()
        {
            var list = await _context.Podcasts
                .Select(p => new PodcastDto
                {
                    IdPodcast = p.IdPodcast,
                    Title = p.Title,
                    Duration = p.Duration,
                    Description = p.Description,
                    Host = p.Host,
                    AudioUrl = p.AudioUrl,
                    CoverImageUrl = p.CoverImageUrl,
                    PublishDate = p.PublishDate,
                    CreatedAt = p.CreatedAt,
                    UpdatedAt = p.UpdatedAt
                })
                .ToListAsync();

            return Ok(list);
        }

        // GET: api/podcast/featured
        [HttpGet("featured")]
        public async Task<ActionResult<IEnumerable<PodcastDto>>> GetAllFeatured()
        {
            var list = await _context.Podcasts
                .Where(p => p.IsFeatured == 1)
                .Select(p => new PodcastDto
                {
                    IdPodcast = p.IdPodcast,
                    Title = p.Title,
                    Duration = p.Duration,
                    Description = p.Description,
                    Host = p.Host,
                    AudioUrl = p.AudioUrl,
                    CoverImageUrl = p.CoverImageUrl,
                    PublishDate = p.PublishDate,
                    CreatedAt = p.CreatedAt,
                    UpdatedAt = p.UpdatedAt,
                    IsFeatured = p.IsFeatured
                })
                .ToListAsync();

            return Ok(list);
        }

        // GET: api/podcast/{id}
        [HttpGet("{id}")]
        public async Task<ActionResult<PodcastDto>> GetById(string id)
        {
            var dto = await _context.Podcasts
                .Where(p => p.IdPodcast == id)
                .Select(p => new PodcastDto
                {
                    IdPodcast = p.IdPodcast,
                    Title = p.Title,
                    Duration = p.Duration,
                    Description = p.Description,
                    Host = p.Host,
                    AudioUrl = p.AudioUrl,
                    CoverImageUrl = p.CoverImageUrl,
                    PublishDate = p.PublishDate,
                    CreatedAt = p.CreatedAt,
                    UpdatedAt = p.UpdatedAt,
                    IsFeatured = p.IsFeatured
                })
                .FirstOrDefaultAsync();

            if (dto == null)
                return NotFound(new { message = "Không tìm thấy podcast." });

            return Ok(dto);
        }

        // POST: api/podcast
        [HttpPost]
        public async Task<ActionResult<PodcastDto>> Create([FromBody] CreatePodcastDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var entity = new Podcast
            {
                IdPodcast = Guid.NewGuid().ToString(),
                Title = dto.Title,
                Duration = dto.Duration,
                Description = dto.Description,
                Host = dto.Host,
                AudioUrl = dto.AudioUrl,
                CoverImageUrl = dto.CoverImageUrl,
                PublishDate = dto.PublishDate,
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow,
                IsFeatured = 0
            };

            _context.Podcasts.Add(entity);
            await _context.SaveChangesAsync();

            var result = new PodcastDto
            {
                IdPodcast = entity.IdPodcast,
                Title = entity.Title,
                Duration = entity.Duration,
                Description = entity.Description,
                Host = entity.Host,
                AudioUrl = entity.AudioUrl,
                CoverImageUrl = entity.CoverImageUrl,
                PublishDate = entity.PublishDate,
                CreatedAt = entity.CreatedAt,
                UpdatedAt = entity.UpdatedAt,
                IsFeatured = entity.IsFeatured
            };

            return CreatedAtAction(nameof(GetById), new { id = result.IdPodcast }, result);
        }

        // PUT: api/podcast/{id}
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(string id, [FromBody] UpdatePodcastDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var entity = await _context.Podcasts.FindAsync(id);
            if (entity == null)
                return NotFound(new { message = "Không tìm thấy podcast." });

            entity.Title = dto.Title ?? entity.Title;
            entity.Description = dto.Description ?? entity.Description;
            entity.Host = dto.Host ?? entity.Host;
            entity.AudioUrl = dto.AudioUrl ?? entity.AudioUrl;
            entity.CoverImageUrl = dto.CoverImageUrl ?? entity.CoverImageUrl;
            entity.PublishDate = dto.PublishDate ?? entity.PublishDate;
            entity.UpdatedAt = DateTime.UtcNow;
            entity.IsFeatured = dto.IsFeatured;

            _context.Podcasts.Update(entity);
            await _context.SaveChangesAsync();
            return NoContent();
        }

        // DELETE: api/podcast/{id}
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(string id)
        {
            var entity = await _context.Podcasts.FindAsync(id);
            if (entity == null)
                return NotFound(new { message = "Không tìm thấy podcast." });

            _context.Podcasts.Remove(entity);
            await _context.SaveChangesAsync();
            return NoContent();
        }
    }
}
