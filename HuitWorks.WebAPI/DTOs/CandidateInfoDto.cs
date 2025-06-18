using System.ComponentModel.DataAnnotations;

namespace HuitWorks.WebAPI.DTOs
{
    public class CandidateInfoDto
    {
        public string IdUser { get; set; } = null!;
        public string? WorkPosition { get; set; }
        public decimal? RatingScore { get; set; }
        public string? UniversityName { get; set; }
        public string? EducationLevel { get; set; }
        public int? ExperienceYears { get; set; }
        public string? Skills { get; set; }
    }

    public class CreateCandidateInfoDto
    {
        [Required(ErrorMessage = "IdUser là bắt buộc.")]
        [StringLength(64, ErrorMessage = "IdUser không được vượt quá 64 ký tự.")]
        public string IdUser { get; set; } = null!;

        [StringLength(255, ErrorMessage = "WorkPosition không được vượt quá 255 ký tự.")]
        public string? WorkPosition { get; set; }

        public decimal? RatingScore { get; set; }

        [StringLength(255, ErrorMessage = "UniversityName không được vượt quá 255 ký tự.")]
        public string? UniversityName { get; set; }

        [StringLength(100, ErrorMessage = "EducationLevel không được vượt quá 100 ký tự.")]
        public string? EducationLevel { get; set; }

        public int? ExperienceYears { get; set; }

        public string? Skills { get; set; }
    }

    public class UpdateCandidateInfoDto
    {
        [StringLength(255, ErrorMessage = "WorkPosition không được vượt quá 255 ký tự.")]
        public string? WorkPosition { get; set; }

        public decimal? RatingScore { get; set; }

        [StringLength(255, ErrorMessage = "UniversityName không được vượt quá 255 ký tự.")]
        public string? UniversityName { get; set; }

        [StringLength(100, ErrorMessage = "EducationLevel không được vượt quá 100 ký tự.")]
        public string? EducationLevel { get; set; }

        public int? ExperienceYears { get; set; }

        public string? Skills { get; set; }
    }
}
