using System;
using System.ComponentModel.DataAnnotations;

namespace HuitWorks.WebAPI.DTOs
{
    public class CandidateEvaluationDto
    {
        public string EvaluationId { get; set; } = null!;
        public string IdJobPost { get; set; } = null!;
        public string IdCandidate { get; set; } = null!;
        public string IdRecruiter { get; set; } = null!;
        public DateTime CreatedAt { get; set; }
    }

    public class CreateCandidateEvaluationDto
    {
        [Required(ErrorMessage = "EvaluationId là bắt buộc.")]
        [StringLength(64, ErrorMessage = "EvaluationId không được vượt quá 64 ký tự.")]
        public string EvaluationId { get; set; } = null!;

        [Required(ErrorMessage = "IdJobPost là bắt buộc.")]
        [StringLength(64, ErrorMessage = "IdJobPost không được vượt quá 64 ký tự.")]
        public string IdJobPost { get; set; } = null!;

        [Required(ErrorMessage = "IdCandidate là bắt buộc.")]
        [StringLength(64, ErrorMessage = "IdCandidate không được vượt quá 64 ký tự.")]
        public string IdCandidate { get; set; } = null!;

        [Required(ErrorMessage = "IdUserRecruiter là bắt buộc.")]
        [StringLength(64, ErrorMessage = "IdUserRecruiter không được vượt quá 64 ký tự.")]
        public string IdRecruiter { get; set; } = null!;
    }

    public class UpdateCandidateEvaluationDto
    {
        [StringLength(64, ErrorMessage = "IdJobPost không được vượt quá 64 ký tự.")]
        public string? IdJobPost { get; set; }

        [StringLength(64, ErrorMessage = "IdCandidate không được vượt quá 64 ký tự.")]
        public string? IdCandidate { get; set; }

        [StringLength(64, ErrorMessage = "IdUserRecruiter không được vượt quá 64 ký tự.")]
        public string? IdRecruiter { get; set; }
    }
}