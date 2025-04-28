using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using HuitWorks.WebAPI.Data;
using HuitWorks.WebAPI.Models;
using HuitWorks.WebAPI.DTOs;

namespace HuitWorks.WebAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class RoleController : ControllerBase
    {
        private readonly JobConnectDbContext _context;

        public RoleController(JobConnectDbContext context)
        {
            _context = context;
        }

        // GET: api/role
        [HttpGet]
        public async Task<ActionResult<IEnumerable<RoleDto>>> GetRoles()
        {
            var roles = await _context.Roles
                .Select(r => new RoleDto
                {
                    IdRole = r.IdRole,
                    RoleName = r.RoleName,
                    Description = r.Description
                })
                .ToListAsync();

            return Ok(roles);
        }

        // GET: api/role/{id}
        [HttpGet("{id}")]
        public async Task<ActionResult<RoleDto>> GetRole(string id)
        {
            var role = await _context.Roles.FindAsync(id);

            if (role == null)
            {
                return NotFound(new { message = "Role not found." });
            }

            var roleDto = new RoleDto
            {
                IdRole = role.IdRole,
                RoleName = role.RoleName,
                Description = role.Description
            };

            return Ok(roleDto);
        }

        // POST: api/role
        [HttpPost]
        public async Task<ActionResult<RoleDto>> CreateRole(CreateRoleDto createRoleDto)
        {
            var role = new Role
            {
                IdRole = Guid.NewGuid().ToString(),
                RoleName = createRoleDto.RoleName,
                Description = createRoleDto.Description
            };

            _context.Roles.Add(role);
            await _context.SaveChangesAsync();

            var roleDto = new RoleDto
            {
                IdRole = role.IdRole,
                RoleName = role.RoleName,
                Description = role.Description
            };

            return CreatedAtAction(nameof(GetRole), new { id = role.IdRole }, roleDto);
        }

        // PUT: api/role/{id}
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateRole(string id, UpdateRoleDto updateRoleDto)
        {
            var role = await _context.Roles.FindAsync(id);

            if (role == null)
            {
                return NotFound(new { message = "Role not found." });
            }

            role.RoleName = updateRoleDto.RoleName;
            role.Description = updateRoleDto.Description;

            _context.Roles.Update(role);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        // DELETE: api/role/{id}
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteRole(string id)
        {
            var role = await _context.Roles.FindAsync(id);

            if (role == null)
            {
                return NotFound(new { message = "Role not found." });
            }

            _context.Roles.Remove(role);
            await _context.SaveChangesAsync();

            return NoContent();
        }
    }
}
