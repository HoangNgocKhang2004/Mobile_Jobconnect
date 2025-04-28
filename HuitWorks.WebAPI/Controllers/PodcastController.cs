using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using HuitWorks.WebAPI.Data;
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
        public async Task<ActionResult<IEnumerable<Podcast>>> GetAll()
        {
            var podcasts = await _context.Podcasts.ToListAsync();
            return Ok(podcasts);
        }

        // GET: api/podcast/{id}
        [HttpGet("{id}")]
        public async Task<ActionResult<Podcast>> GetById(string id)
        {
            var podcast = await _context.Podcasts.FindAsync(id);
            if (podcast == null)
                return NotFound(new { message = "Podcast not found." });

            return Ok(podcast);
        }

        // POST: api/podcast
        [HttpPost]
        public async Task<ActionResult<Podcast>> Create(Podcast podcast)
        {
            podcast.IdPodcast = "pod" + Guid.NewGuid().ToString();
            podcast.CreatedAt = DateTime.UtcNow;
            podcast.UpdatedAt = DateTime.UtcNow;

            _context.Podcasts.Add(podcast);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetById), new { id = podcast.IdPodcast }, podcast);
        }

        // PUT: api/podcast/{id}
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(string id, Podcast updatedPodcast)
        {
            var podcast = await _context.Podcasts.FindAsync(id);
            if (podcast == null)
                return NotFound(new { message = "Podcast not found." });

            podcast.Title = updatedPodcast.Title;
            podcast.Description = updatedPodcast.Description;
            podcast.Host = updatedPodcast.Host;
            podcast.AudioUrl = updatedPodcast.AudioUrl;
            podcast.CoverImageUrl = updatedPodcast.CoverImageUrl;
            podcast.PublishDate = updatedPodcast.PublishDate;
            podcast.UpdatedAt = DateTime.UtcNow;

            _context.Podcasts.Update(podcast);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        // DELETE: api/podcast/{id}
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(string id)
        {
            var podcast = await _context.Podcasts.FindAsync(id);
            if (podcast == null)
                return NotFound(new { message = "Podcast not found." });

            _context.Podcasts.Remove(podcast);
            await _context.SaveChangesAsync();

            return NoContent();
        }
    }
}
