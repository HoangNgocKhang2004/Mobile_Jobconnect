using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace HuitWorks.WebAPI.Models
{
    [Table("candidateInfo")]
    public class CandidateInfo
    {
        [Key]
        [Column("idUser")]
        [StringLength(64)]
        public required string IdUser { get; set; }

        [Column("workPosition")]
        [StringLength(255)]
        public string? WorkPosition { get; set; }

        [Column("ratingScore")]
        public decimal? RatingScore { get; set; }

        [Column("universityName")]
        [StringLength(255)]
        public string? UniversityName { get; set; }

        [Column("educationLevel")]
        [StringLength(100)]
        public string? EducationLevel { get; set; }

        [Column("experienceYears")]
        public int? ExperienceYears { get; set; }

        [Column("skills")]
        public string? Skills { get; set; }

    }
}
