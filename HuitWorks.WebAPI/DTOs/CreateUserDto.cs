using System.ComponentModel.DataAnnotations;

namespace HuitWorks.WebAPI.DTOs
{
    public class CreateUserDto
    {
        [Required(ErrorMessage = "UserName is required.")]
        [StringLength(50, ErrorMessage = "UserName cannot be longer than 50 characters.")]
        public string UserName { get; set; } = null!;

        [Required(ErrorMessage = "Email is required.")]
        [EmailAddress(ErrorMessage = "Invalid email format.")]
        public string Email { get; set; } = null!;

        [Phone(ErrorMessage = "Invalid phone number format.")]
        public string? PhoneNumber { get; set; }

        [Required(ErrorMessage = "Password is required.")]
        [StringLength(100, MinimumLength = 6, ErrorMessage = "Password must be between 6 and 100 characters.")]
        public string Password { get; set; } = null!;

        [Required(ErrorMessage = "IdRole is required.")]
        public string IdRole { get; set; } = null!;

        public string? AvatarUrl { get; set; }
        public string? SocialLogin { get; set; }
    }
}
