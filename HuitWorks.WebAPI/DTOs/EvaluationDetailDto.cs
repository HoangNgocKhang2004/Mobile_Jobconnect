using System;
using System.ComponentModel.DataAnnotations;

namespace HuitWorks.WebAPI.DTOs
{
    public class EvaluationDetailDto
    {
        public string EvaluationDetailId { get; set; } = null!;
        public string EvaluationId { get; set; } = null!;
        public string CriterionId { get; set; } = null!;
        public byte Score { get; set; }
        public string? Comments { get; set; }
    }

    public class CreateEvaluationDetailDto
    {
        [Required(ErrorMessage = "EvaluationDetailId là bắt buộc.")]
        [StringLength(64, ErrorMessage = "EvaluationDetailId không được vượt quá 64 ký tự.")]
        public string EvaluationDetailId { get; set; } = null!;

        [Required(ErrorMessage = "EvaluationId là bắt buộc.")]
        [StringLength(64, ErrorMessage = "EvaluationId không được vượt quá 64 ký tự.")]
        public string EvaluationId { get; set; } = null!;

        [Required(ErrorMessage = "CriterionId là bắt buộc.")]
        [StringLength(64, ErrorMessage = "CriterionId không được vượt quá 64 ký tự.")]
        public string CriterionId { get; set; } = null!;

        [Range(0, 10, ErrorMessage = "Score phải nằm trong khoảng 0 đến 10.")]
        public byte Score { get; set; }

        public string? Comments { get; set; }
    }

    public class UpdateEvaluationDetailDto
    {
        [Range(0, 10, ErrorMessage = "Score phải nằm trong khoảng 0 đến 10.")]
        public byte? Score { get; set; }

        public string? Comments { get; set; }
    }
}
