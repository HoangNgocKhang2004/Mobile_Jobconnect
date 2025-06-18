using System;
using System.ComponentModel.DataAnnotations;

namespace HuitWorks.WebAPI.DTOs
{
    public class EvaluationCriteriaDto
    {
        public string CriterionId { get; set; } = null!;
        public string Name { get; set; } = null!;
        public string? Description { get; set; }
        public DateTime CreatedAt { get; set; }
    }

    public class CreateEvaluationCriteriaDto
    {
        //[Required(ErrorMessage = "CriterionId là bắt buộc.")]
        //[StringLength(64, ErrorMessage = "CriterionId không được vượt quá 64 ký tự.")]
        //public string CriterionId { get; set; } = null!;

        [Required(ErrorMessage = "Name là bắt buộc.")]
        [StringLength(100, ErrorMessage = "Name không được vượt quá 100 ký tự.")]
        public string Name { get; set; } = null!;

        public string? Description { get; set; }
    }

    public class UpdateEvaluationCriteriaDto
    {
        [StringLength(100, ErrorMessage = "Name không được vượt quá 100 ký tự.")]
        public string? Name { get; set; }

        public string? Description { get; set; }
    }
}