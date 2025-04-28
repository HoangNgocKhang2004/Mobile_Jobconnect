using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace HuitWorks.WebAPI.Models
{
    [Table("users")]
    public class User
    {
        [Key]
        [Column("idUser")]
        [StringLength(64)]
        public required string IdUser { get; set; }

        [Required]
        [Column("userName")]
        [StringLength(100)]
        public required string UserName { get; set; }

        [Required]
        [Column("email")]
        [StringLength(255)]
        public required string Email { get; set; }

        [Required]
        [Column("phoneNumber")]
        [StringLength(20)]
        public required string PhoneNumber { get; set; }

        [Required]
        [Column("password")]
        [StringLength(255)]
        public required string Password { get; set; }

        [Required]
        [Column("idRole")]
        [StringLength(64)]
        public required string IdRole { get; set; }

        [Required]
        [Column("accountStatus")]
        public required string AccountStatus { get; set; }

        [Column("avatarUrl")]
        [StringLength(255)]
        public string? AvatarUrl { get; set; }

        [Column("socialLogin")]
        [StringLength(255)]
        public string? SocialLogin { get; set; }

        [Required]
        [Column("createdAt")]
        public required DateTime CreatedAt { get; set; }

        [Required]
        [Column("updatedAt")]
        public required DateTime UpdatedAt { get; set; }

        [Required]
        [Column("gender")]
        public required string Gender { get; set; }

        [Column("address")]
        [StringLength(255)]
        public string? Address { get; set; }

        [Column("dateOfBirth")]
        public DateTime? DateOfBirth { get; set; }

        // Navigation property
        [ForeignKey(nameof(IdRole))]
        public Role? Role { get; set; }
    }
}
