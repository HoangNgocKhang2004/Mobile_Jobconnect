using HuitWorks.WebAPI.Data;
using HuitWorks.WebAPI.Models;
using Microsoft.AspNetCore.Mvc;
using System;

//namespace HuitWorks.WebAPI.Controllers
//{
//    [ApiController]
//    [Route("api/[controller]")]
//    public class UsersController : GenericController<User>
//    {
//        public UsersController(JobConnectDbContext ctx) : base(ctx) { }
//    }
//}

using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authorization;
using HuitWorks.WebAPI.DTOs;

//namespace HuitWorks.WebAPI.Controllers
//{
//    //[Authorize]
//    [Route("api/[controller]")]
//    [ApiController]
//    public class UsersController : ControllerBase
//    {
//        private readonly JobConnectDbContext _context; // Thay AppDbContext bằng tên DbContext của bạn

//        public UsersController(JobConnectDbContext context)
//        {
//            _context = context;
//        }

//        // GET: api/users
//        [HttpGet]
//        public async Task<ActionResult<IEnumerable<UserDtoo>>> GetUsers()
//        {
//            try
//            {
//                var users = await _context.Users
//                    .Include(u => u.Role) // Tải thông tin Role
//                    .ToListAsync();

//                return Ok(users);
//            }
//            catch (Exception ex)
//            {
//                return StatusCode(500, $"Internal server error: {ex.Message}");
//            }
//        }

//        // GET: api/users/{id}
//        [HttpGet("{id}")]
//        public async Task<ActionResult<User>> GetUser(string id)
//        {
//            try
//            {
//                var user = await _context.Users
//                    .Include(u => u.Role) // Tải thông tin Role
//                    .FirstOrDefaultAsync(u => u.IdUser == id);

//                if (user == null)
//                {
//                    return NotFound($"User with ID {id} not found.");
//                }

//                return Ok(user);
//            }
//            catch (Exception ex)
//            {
//                return StatusCode(500, $"Internal server error: {ex.Message}");
//            }
//        }
//    }
//}


namespace HuitWorks.WebAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UsersController : ControllerBase
    {
        private readonly JobConnectDbContext _context;

        public UsersController(JobConnectDbContext context)
        {
            _context = context;
        }

        // GET: api/users
        [HttpGet]
        public async Task<ActionResult<IEnumerable<UserDto>>> GetUsers()
        {
            try
            {
                var users = await _context.Users
                    .Include(u => u.Role)
                    .ToListAsync();

                var userDtos = users.Select(u => new UserDto
                {
                    IdUser = u.IdUser,
                    UserName = u.UserName,
                    Email = u.Email,
                    PhoneNumber = u.PhoneNumber,
                    IdRole = u.IdRole,
                    AccountStatus = u.AccountStatus,
                    AvatarUrl = u.AvatarUrl,
                    SocialLogin = u.SocialLogin,
                    CreatedAt = u.CreatedAt,
                    UpdatedAt = u.UpdatedAt,
                    Role = u.Role
                }).ToList();

                return Ok(userDtos);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }

        // GET: api/users/{id}
        [HttpGet("{id}")]
        public async Task<ActionResult<UserDto>> GetUser(string id)
        {
            try
            {
                var user = await _context.Users
                    .Include(u => u.Role)
                    .FirstOrDefaultAsync(u => u.IdUser == id);

                if (user == null)
                {
                    return NotFound($"User with ID {id} not found.");
                }

                var userDto = new UserDto
                {
                    IdUser = user.IdUser,
                    UserName = user.UserName,
                    Email = user.Email,
                    PhoneNumber = user.PhoneNumber,
                    IdRole = user.IdRole,
                    AccountStatus = user.AccountStatus,
                    AvatarUrl = user.AvatarUrl,
                    SocialLogin = user.SocialLogin,
                    CreatedAt = user.CreatedAt,
                    UpdatedAt = user.UpdatedAt,
                    Role = user.Role
                };

                return Ok(userDto);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }
    }
}