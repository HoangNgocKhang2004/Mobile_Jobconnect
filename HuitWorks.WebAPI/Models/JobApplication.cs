using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace HuitWorks.WebAPI.Models
{
    [Table("jobApplication")]
    public class JobApplication
    {
        [Key]
        [Column("idJobApp")]
        [StringLength(64)]
        public required string IdJobApp { get; set; }

        [Required]
        [Column("idJobPost")]
        [StringLength(64)]
        public required string IdJobPost { get; set; }

        [Required]
        [Column("idUser")]
        [StringLength(64)]
        public required string IdUser { get; set; }

        [Column("cvFileUrl")]
        [StringLength(255)]
        public string? CvFileUrl { get; set; }

        [Column("coverLetter")]
        public string? CoverLetter { get; set; }

        [Required]
        [Column("applicationStatus")]
        public required string ApplicationStatus { get; set; }

        [Required]
        [Column("submittedAt")]
        public required DateTime SubmittedAt { get; set; }

        [Required]
        [Column("updatedAt")]
        public required DateTime UpdatedAt { get; set; }

        // Navigation properties
        [ForeignKey(nameof(IdJobPost))]
        public JobPosting JobPosting { get; set; } = null!;

        [ForeignKey(nameof(IdUser))]
        public User? User { get; set; }
    }
}