using System;
using System.ComponentModel.DataAnnotations;
using HuitWorks.WebAPI.Models;

namespace HuitWorks.WebAPI.DTOs
{
    public class UserDto
    {
        public string IdUser { get; set; } = null!;

        public string UserName { get; set; } = null!;

        public string Email { get; set; } = null!;

        public string PhoneNumber { get; set; } = null!;

        public string IdRole { get; set; } = null!;

        public string AccountStatus { get; set; } = null!;

        public string? AvatarUrl { get; set; }

        public string? SocialLogin { get; set; }

        public DateTime CreatedAt { get; set; }

        public DateTime UpdatedAt { get; set; }

        public string Gender { get; set; } = null!;

        public string? Address { get; set; }

        public DateTime? DateOfBirth { get; set; }

        public Role Role { get; set; } = null!;
    }

    public class CreateUserDto
    {
        [Required(ErrorMessage = "UserName is required.")]
        [StringLength(100, ErrorMessage = "UserName cannot be longer than 100 characters.")]
        public string UserName { get; set; } = null!;

        [Required(ErrorMessage = "Email is required.")]
        [EmailAddress(ErrorMessage = "Invalid email format.")]
        public string Email { get; set; } = null!;

        [Required(ErrorMessage = "PhoneNumber is required.")]
        [Phone(ErrorMessage = "Invalid phone number format.")]
        public string PhoneNumber { get; set; } = null!;

        [Required(ErrorMessage = "Password is required.")]
        [StringLength(255, MinimumLength = 6, ErrorMessage = "Password must be between 6 and 255 characters.")]
        public string Password { get; set; } = null!;

        [Required(ErrorMessage = "IdRole is required.")]
        public string IdRole { get; set; } = null!;

        [Required(ErrorMessage = "AccountStatus is required.")]
        public string AccountStatus { get; set; } = null!;

        [Required(ErrorMessage = "Gender is required.")]
        public string Gender { get; set; } = null!;

        public string? Address { get; set; }

        public DateTime? DateOfBirth { get; set; }

        public string? AvatarUrl { get; set; }

        public string? SocialLogin { get; set; }
    }
}
