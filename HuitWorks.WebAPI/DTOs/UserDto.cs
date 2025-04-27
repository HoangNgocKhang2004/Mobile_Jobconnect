using HuitWorks.WebAPI.Models;

namespace HuitWorks.WebAPI.DTOs
{
    public class UserDto
    {
        public string IdUser { get; set; } = null!;
        public string UserName { get; set; } = null!;
        public string Email { get; set; } = null!;
        public string? PhoneNumber { get; set; }
        public string IdRole { get; set; } = null!;
        public string AccountStatus { get; set; } = null!;
        public string? AvatarUrl { get; set; }
        public string? SocialLogin { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
        public Role Role { get; set; } = null!;
    }
}
