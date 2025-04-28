using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using HuitWorks.WebAPI.Data;
using HuitWorks.WebAPI.Models;

namespace HuitWorks.WebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class WebsiteController : ControllerBase
    {
        private readonly JobConnectDbContext _context;

        public WebsiteController(JobConnectDbContext context)
        {
            _context = context;
        }

        // GET: api/website
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Website>>> GetAll()
        {
            var websites = await _context.Websites.ToListAsync();
            return Ok(websites);
        }

        // GET: api/website/{id}
        [HttpGet("{id}")]
        public async Task<ActionResult<Website>> GetById(string id)
        {
            var website = await _context.Websites.FindAsync(id);
            if (website == null)
                return NotFound(new { message = "Website not found." });

            return Ok(website);
        }

        // POST: api/website
        [HttpPost]
        public async Task<ActionResult<Website>> Create(Website website)
        {
            website.IdWebsite = "web" + Guid.NewGuid().ToString();
            website.CreatedAt = DateTime.UtcNow;
            website.UpdatedAt = DateTime.UtcNow;
            website.IsActive = true; // mặc định khi tạo là đang hoạt động

            _context.Websites.Add(website);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetById), new { id = website.IdWebsite }, website);
        }

        // PUT: api/website/{id}
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(string id, Website updatedWebsite)
        {
            var website = await _context.Websites.FindAsync(id);
            if (website == null)
                return NotFound(new { message = "Website not found." });

            website.Name = updatedWebsite.Name;
            website.Url = updatedWebsite.Url;
            website.Description = updatedWebsite.Description;
            website.IsActive = updatedWebsite.IsActive;
            website.UpdatedAt = DateTime.UtcNow;

            _context.Websites.Update(website);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        // DELETE: api/website/{id}
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(string id)
        {
            var website = await _context.Websites.FindAsync(id);
            if (website == null)
                return NotFound(new { message = "Website not found." });

            _context.Websites.Remove(website);
            await _context.SaveChangesAsync();

            return NoContent();
        }
    }
}
