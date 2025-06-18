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
        public string? IdUser { get; set; }

        //[Required]
        [Column("userName")]
        [StringLength(100)]
        public string? UserName { get; set; }

        //[Required]
        [Column("email")]
        [StringLength(255)]
        public string? Email { get; set; }

        [Column("phoneNumber")]
        [StringLength(20)]
        public string? PhoneNumber { get; set; }

        [Column("password")]
        [StringLength(255)]
        public string? Password { get; set; }

        //[Required]
        [Column("idRole")]
        [StringLength(64)]
        public string? IdRole { get; set; }

        //[Required]
        [Column("accountStatus")]
        public string? AccountStatus { get; set; }

        [Column("avatarUrl")]
        [StringLength(255)]
        public string? AvatarUrl { get; set; }

        [Column("socialLogin")]
        [StringLength(255)]
        public string? SocialLogin { get; set; }

        [Column("createdAt")]
        public DateTime? CreatedAt { get; set; }

        [Column("updatedAt")]
        public DateTime? UpdatedAt { get; set; }

        [Column("gender")]
        public string? Gender { get; set; }

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
