using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace HuitWorks.WebAPI.Models
{
    [Table("jobPosting")]
    public class JobPosting
    {
        [Key]
        [Column("idJobPost")]
        [StringLength(64)]
        public required string IdJobPost { get; set; }

        [Required]
        [Column("title")]
        [StringLength(100)]
        public required string Title { get; set; }

        [Required]
        [Column("description")]
        public required string Description { get; set; }

        [Required]
        [Column("requirements")]
        public required string Requirements { get; set; }

        [Column("salary")]
        public decimal? Salary { get; set; }

        [Required]
        [Column("location")]
        [StringLength(255)]
        public required string Location { get; set; }

        [Required]
        [Column("workType")]
        public required string WorkType { get; set; }

        [Required]
        [Column("experienceLevel")]
        [StringLength(50)]
        public required string ExperienceLevel { get; set; }

        [Required]
        [Column("idCompany")]
        [StringLength(64)]
        public required string IdCompany { get; set; }

        [Column("applicationDeadline")]
        public DateTime? ApplicationDeadline { get; set; }

        [Column("benefits")]
        public string? Benefits { get; set; }

        [Required]
        [Column("createdAt")]
        public required DateTime CreatedAt { get; set; }

        [Required]
        [Column("updatedAt")]
        public required DateTime UpdatedAt { get; set; }

        [Required]
        [Column("postStatus")]
        public required string PostStatus { get; set; }

        // Navigation property to Company
        [ForeignKey(nameof(IdCompany))]
        public Company? Company { get; set; }
    }
}