using HuitWorks.RecruiterWeb.Models.ViewModel;

namespace HuitWorks.RecruiterWeb.Models
{
    public class UserViewModel
    {
        public string? IdUser { get; set; }
        public string? UserName { get; set; }
        public string? Email { get; set; }
        public string? PhoneNumber { get; set; }
        public string? IdRole { get; set; }
        public string? AccountStatus { get; set; }
        public string? AvatarUrl { get; set; }
        public string? SocialLogin { get; set; }
        public DateTime? CreatedAt { get; set; }
        public DateTime? UpdatedAt { get; set; }
        public string? Gender { get; set; }
        public string? Address { get; set; }
        public DateTime? DateOfBirth { get; set; }

        // Vai trò (nested object từ /api/Role)
        public RoleViewModel? Role { get; set; }
    }
}
