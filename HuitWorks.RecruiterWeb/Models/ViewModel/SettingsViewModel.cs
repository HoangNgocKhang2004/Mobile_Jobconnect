using System;
using System.ComponentModel.DataAnnotations;

namespace HuitWorks.RecruiterWeb.Models.ViewModel
{
    public class SettingsViewModel
    {
        // === Thông tin User ===
        public string? IdUser { get; set; }

        public string? UserName { get; set; }

        public string? Email { get; set; }

        public string? PhoneNumber { get; set; }

        public string? Gender { get; set; } // "male"/"female"/"other"

        public string? Address { get; set; }

        public string? IdRole { get; set; } // Ví dụ: "role1"

        public string? AccountStatus { get; set; } // "active"/"inactive"/"suspended"

        public DateTime? DateOfBirth { get; set; } // Bắt buộc phải có

        public string? AvatarUrl { get; set; }
        public IFormFile? AvatarFile { get; set; }

        public string? SocialLogin { get; set; }

        public DateTime? CreatedAt { get; set; }

        public DateTime? UpdatedAt { get; set; }


        // === Thông tin Recruiter (nếu có) ===
        public string? Title { get; set; }
        public string? IdCompany { get; set; }
        public string? Department { get; set; }
        public string? Description { get; set; }
    }
}
