using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using HuitWorks.WebAPI.Data;
using HuitWorks.WebAPI.Models;
using HuitWorks.WebAPI.DTOs;
using Microsoft.AspNetCore.Builder.Extensions;
using FirebaseAdmin;
using Google.Apis.Auth.OAuth2;
using FirebaseAdmin.Auth;
using Microsoft.AspNetCore.Authorization;

namespace HuitWorks.WebAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AuthController : ControllerBase
    {
        private readonly JobConnectDbContext _context;
        private readonly IConfiguration _configuration;

        public AuthController(JobConnectDbContext context, IConfiguration configuration)
        {
            _context = context;
            _configuration = configuration;

            if (FirebaseApp.DefaultInstance == null)
            {
                FirebaseApp.Create(new AppOptions
                {
                    Credential = GoogleCredential
                        .FromFile("serviceAccountKey.json")
                });
            }
        }

        /// <summary>
        /// Đăng ký tài khoản mới
        /// </summary>
        [HttpPost("register")]
        public async Task<IActionResult> Register([FromBody] RegisterDto model)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            if (await _context.Users.AnyAsync(u => u.Email == model.Email))
                return BadRequest(new { message = "Email đã tồn tại" });

            var role = await _context.Roles
                .FirstOrDefaultAsync(r => r.RoleName == model.RoleName);
            if (role == null)
            {
                role = new Role
                {
                    IdRole = Guid.NewGuid().ToString(),
                    RoleName = model.RoleName,
                    Description = $"Auto-created role: {model.RoleName}"
                };
                _context.Roles.Add(role);
                await _context.SaveChangesAsync();
            }

            var user = new User
            {
                IdUser = "user" + Guid.NewGuid().ToString(),
                UserName = model.UserName,
                Email = model.Email,
                PhoneNumber = model.PhoneNumber ?? string.Empty,
                Password = BCrypt.Net.BCrypt.HashPassword(model.Password),
                IdRole = role.IdRole,
                AccountStatus = role.RoleName == "Recruiter" ? "pending" : "active",
                AvatarUrl = "/images/logo.png",
                SocialLogin = null,
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow,
                Gender = "other",
                Address = null,
                DateOfBirth = null
            };

            _context.Users.Add(user);
            await _context.SaveChangesAsync();

            var result = new { IdUser = user.IdUser, Message = "Đăng ký thành công" };
            return CreatedAtAction(
                nameof(GetById),
                new { id = user.IdUser },
                result
            );
        }

        /// <summary>
        /// Lấy thông tin user theo IdUser
        /// </summary>
        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(string id)
        {
            var user = await _context.Users
                .Include(u => u.Role)
                .FirstOrDefaultAsync(u => u.IdUser == id);
            if (user == null)
                return NotFound(new { message = "Không tìm thấy user" });

            var vm = new UserDto
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
                Gender = user.Gender,
                Address = user.Address,
                DateOfBirth = user.DateOfBirth,
                Role = new Role
                {
                    IdRole = user.Role.IdRole,
                    RoleName = user.Role.RoleName,
                    Description = user.Role.Description
                }
            };

            return Ok(vm);
        }

        /// <summary>
        /// Đăng nhập và nhận JWT
        /// </summary>
        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginDto model)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            // Include Role khi query User
            var user = await _context.Users
                .Include(u => u.Role) // Join với bảng Roles
                .FirstOrDefaultAsync(u => u.Email == model.Email);

            if (user == null || !BCrypt.Net.BCrypt.Verify(model.Password, user.Password))
                return Unauthorized(new { message = "Thông tin đăng nhập không hợp lệ" });

            if (user.Role == null)
                return StatusCode(500, new { message = "Không tìm thấy thông tin vai trò cho người dùng" });

            var token = GenerateJwtToken(user);

            var response = new AuthResponseDTO
            {
                Token = token,
                User = new User
                {
                    IdUser = user.IdUser,
                    UserName = user.UserName,
                    Email = user.Email,
                    PhoneNumber = user.PhoneNumber,
                    Password = BCrypt.Net.BCrypt.HashPassword(model.Password),
                    IdRole = user.IdRole,
                    AccountStatus = user.AccountStatus,
                    AvatarUrl = user.AvatarUrl,
                    SocialLogin = user.SocialLogin,
                    CreatedAt = user.CreatedAt,
                    UpdatedAt = user.UpdatedAt,
                    Gender = user.Gender,
                    Address = user.Address,
                    DateOfBirth = user.DateOfBirth,
                    Role = new Role
                    {
                        IdRole = user.Role.IdRole,
                        RoleName = user.Role.RoleName,
                        Description = user.Role.Description
                    }
                }
            };

            return Ok(response);
        }

        [HttpPost("social-login"), AllowAnonymous]
        public async Task<IActionResult> SocialLogin([FromBody] SocialLoginDto model)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            FirebaseToken decoded;
            try
            {
                decoded = await FirebaseAuth.DefaultInstance.VerifyIdTokenAsync(model.IdToken);
            }
            catch (Exception ex)
            {
                return BadRequest($"Invalid Firebase token: {ex.Message}");
            }

            var email = model.Email.Trim();
            var name = model.Name.Trim();

            var recruiterRole = await _context.Roles
                .FirstOrDefaultAsync(r => r.RoleName == "Recruiter");
            if (recruiterRole == null)
            {
                recruiterRole = new Role
                {
                    IdRole = Guid.NewGuid().ToString(),
                    RoleName = "Recruiter",
                    Description = "Nhà tuyển dụng"
                };
                _context.Roles.Add(recruiterRole);
                await _context.SaveChangesAsync();
            }

            var user = await _context.Users
                .Include(u => u.Role)
                .FirstOrDefaultAsync(u => u.IdUser == decoded.Uid);

            if (user == null)
            {
                user = new User
                {
                    IdUser = decoded.Uid,
                    UserName = name,
                    Email = email,
                    PhoneNumber = null,
                    Password = null,
                    IdRole = recruiterRole.IdRole,
                    AccountStatus = "active",
                    AvatarUrl = decoded.Claims.TryGetValue("picture", out var p) ? p.ToString() : null,
                    SocialLogin = "Google",
                    Gender = "other",
                    CreatedAt = DateTime.UtcNow,
                    UpdatedAt = DateTime.UtcNow
                };
                _context.Users.Add(user);
                await _context.SaveChangesAsync();
            }

            var recInfo = await _context.RecruiterInfo.FindAsync(user.IdUser);
            if (recInfo == null)
            {
                var company = new Company
                {
                    IdCompany = Guid.NewGuid().ToString(),
                    CompanyName = "",
                    TaxCode = null,
                    Address = null,
                    Description = null,
                    LogoCompany = null,
                    WebsiteUrl = null,
                    Scale = null,
                    Industry = null,
                    BusinessLicenseUrl = null,
                    Status = "suspended",
                    IsFeatured = 0,
                    CreatedAt = DateTime.UtcNow,
                    UpdatedAt = DateTime.UtcNow
                };
                _context.Companies.Add(company);
                await _context.SaveChangesAsync();

                recInfo = new RecruiterInfo
                {
                    IdUser = user.IdUser,
                    IdCompany = company.IdCompany,
                    Title = null,
                    Department = null,
                    Description = null
                };
                _context.RecruiterInfo.Add(recInfo);
                await _context.SaveChangesAsync();
            }

            var token = GenerateJwtToken(user);

            bool needProfile = string.IsNullOrWhiteSpace(recInfo.Title);

            var userDto = new UserDto
            {
                IdUser = user.IdUser,
                UserName = user.UserName,
                Email = user.Email,
                IdRole = user.IdRole,
                AvatarUrl = user.AvatarUrl
            };

            return Ok(new SocialLoginResponseDto
            {
                Token = token,
                User = userDto,
                NeedProfile = needProfile
            });
        }

        // Helper: Generate JWT Token
        private string GenerateJwtToken(User user)
        {
            var jwtSettings = _configuration.GetSection("JwtSettings");
            var secretKey = jwtSettings["Key"];
            var issuer = jwtSettings["Issuer"];
            var audience = jwtSettings["Audience"];
            var expiryMinutes = int.Parse(jwtSettings["ExpiryInMinutes"]);

            if (string.IsNullOrEmpty(secretKey) || string.IsNullOrEmpty(issuer) || string.IsNullOrEmpty(audience))
                throw new Exception("JWT Settings are not properly configured.");

            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secretKey));
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            var claims = new[]
            {
                new Claim(JwtRegisteredClaimNames.Sub, user.IdUser),
                new Claim(JwtRegisteredClaimNames.Email, user.Email),
            };

            var token = new JwtSecurityToken(
                issuer: issuer,
                audience: audience,
                claims: claims,
                expires: DateTime.UtcNow.AddMinutes(expiryMinutes),
                signingCredentials: creds
            );

            return new JwtSecurityTokenHandler().WriteToken(token);
        }
    }
}