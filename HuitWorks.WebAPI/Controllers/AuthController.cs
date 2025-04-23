using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.EntityFrameworkCore;
using HuitWorks.WebAPI.Data;
using HuitWorks.WebAPI.Models;
using HuitWorks.WebAPI.DTOs;

namespace HuitWorks.WebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AuthController : ControllerBase
    {
        private readonly JobConnectDbContext _context;
        private readonly IConfiguration _configuration;
        private readonly ILogger<AuthController> _logger;

        public AuthController(
            JobConnectDbContext context,
            IConfiguration configuration,
            ILogger<AuthController> logger)
        {
            _context = context;
            _configuration = configuration;
            _logger = logger;
        }

        /// <summary>
        /// Endpoint kiểm thử logger (chỉ dùng debug)
        /// </summary>
        [HttpGet("logger")]
        public IActionResult GetLogger()
        {
            return Ok(_logger);
        }

        /// <summary>
        /// Đăng ký người dùng mới
        /// </summary>
        [HttpPost("register")]
        public async Task<IActionResult> Register([FromBody] RegisterDto model)
        {
            if (!ModelState.IsValid)
            {
                _logger.LogWarning("Invalid model state for register: {Errors}", ModelState);
                return BadRequest(ModelState);
            }

            if (await _context.Users.AnyAsync(u => u.Email == model.Email))
            {
                _logger.LogWarning("Registration failed: Email {Email} already exists", model.Email);
                return BadRequest("Email đã tồn tại");
            }

            var role = await _context.Roles.FirstOrDefaultAsync(r => r.RoleName == model.RoleName);
            if (role == null)
            {
                role = new Role
                {
                    IdRole = Guid.NewGuid().ToString(),
                    RoleName = model.RoleName,
                    Description = $"Auto-created role {model.RoleName}"
                };
                _context.Roles.Add(role);
                await _context.SaveChangesAsync();
            }

            var user = new User
            {
                IdUser = Guid.NewGuid().ToString(),
                UserName = model.UserName,
                Email = model.Email,
                PhoneNumber = model.PhoneNumber,
                Password = BCrypt.Net.BCrypt.HashPassword(model.Password),
                IdRole = role.IdRole,
                AccountStatus = "active",
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow
            };

            _context.Users.Add(user);
            await _context.SaveChangesAsync();
            _logger.LogInformation("User {Email} registered", model.Email);

            return Ok(new { message = "Đăng ký thành công" });
        }

        /// <summary>
        /// Đăng nhập và trả về JWT
        /// </summary>
        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginDto model)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var user = await _context.Users
                .Include(u => u.Role)
                .FirstOrDefaultAsync(u => u.Email == model.Email);

            if (user == null || !BCrypt.Net.BCrypt.Verify(model.Password, user.Password))
                return Unauthorized("Thông tin đăng nhập không hợp lệ");

            var token = GenerateJwtToken(user);
            return Ok(new AuthResponse { Token = token, User = user });
        }

        // Helper method để sinh JWT
        private string GenerateJwtToken(User user)
        {
            var jwt = _configuration.GetSection("JwtSettings");
            var key = Encoding.UTF8.GetBytes(jwt["Key"]!);

            var claims = new[]
            {
                new Claim(ClaimTypes.NameIdentifier, user.IdUser),
                new Claim(ClaimTypes.Email, user.Email),
                new Claim(ClaimTypes.Role, user.Role.RoleName)
            };

            var creds = new SigningCredentials(
                new SymmetricSecurityKey(key),
                SecurityAlgorithms.HmacSha256);

            var token = new JwtSecurityToken(
                issuer: jwt["Issuer"],
                audience: jwt["Audience"],
                claims: claims,
                expires: DateTime.UtcNow.AddMinutes(int.Parse(jwt["ExpiryInMinutes"]!)),
                signingCredentials: creds);

            return new JwtSecurityTokenHandler().WriteToken(token);
        }
    }
}
