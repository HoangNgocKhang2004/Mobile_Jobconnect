using System.ComponentModel.DataAnnotations;
using HuitWorks.WebAPI.Models;

namespace HuitWorks.WebAPI.DTOs
{
    // DTO dùng khi đăng ký tài khoản
    public class RegisterDto
    {
        [Required(ErrorMessage = "UserName is required.")]
        [StringLength(100, ErrorMessage = "UserName cannot be longer than 100 characters.")]
        public string UserName { get; set; } = null!;

        [Required(ErrorMessage = "Email is required.")]
        [EmailAddress(ErrorMessage = "Invalid email format.")]
        [StringLength(255, ErrorMessage = "Email cannot be longer than 255 characters.")]
        public string Email { get; set; } = null!;

        [Required(ErrorMessage = "Password is required.")]
        [StringLength(255, MinimumLength = 8, ErrorMessage = "Password must be at least 8 characters.")]
        [RegularExpression(@"^(?=.*[#@$%&]).{8,}$", ErrorMessage = "Password must be at least 8 characters and contain at least one special character (#@$%&).")]
        public string Password { get; set; } = null!;

        [Phone(ErrorMessage = "Invalid phone number format.")]
        [StringLength(20, ErrorMessage = "PhoneNumber cannot be longer than 20 characters.")]
        public string? PhoneNumber { get; set; }

        [Required(ErrorMessage = "RoleName is required.")]
        [StringLength(100, ErrorMessage = "RoleName cannot be longer than 100 characters.")]
        public string RoleName { get; set; } = "Candidate"; // mặc định Candidate
    }
    // DTO dùng khi đăng nhập
    public class LoginDto
    {
        [Required(ErrorMessage = "Email is required.")]
        [EmailAddress(ErrorMessage = "Invalid email format.")]
        [StringLength(255, ErrorMessage = "Email cannot be longer than 255 characters.")]
        public string Email { get; set; } = null!;

        [Required(ErrorMessage = "Password is required.")]
        [StringLength(255, ErrorMessage = "Password cannot be longer than 255 characters.")]
        public string Password { get; set; } = null!;
    }

    // DTO trả về khi xác thực thành công
    public class AuthResponse
    {
        public string Token { get; set; } = null!;
        public User User { get; set; } = null!;
    }
}
