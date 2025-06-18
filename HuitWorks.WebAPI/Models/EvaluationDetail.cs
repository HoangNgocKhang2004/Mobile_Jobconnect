using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace HuitWorks.WebAPI.Models
{
    [Table("evaluationDetail")]
    public class EvaluationDetail
    {
        [Key]
        [StringLength(64)]
        [Column("evaluationDetailId")]
        public required string EvaluationDetailId { get; set; }

        [Required, StringLength(64)]
        [Column("evaluationId")]
        public required string EvaluationId { get; set; }      

        [Required, StringLength(64)]
        [Column("criterionId")]
        public required string CriterionId { get; set; }        

        [Range(0, 10)]
        [Column("score")]
        public byte Score { get; set; }

        [Column("comments")]
        public string? Comments { get; set; }

        // Navigation properties
        [ForeignKey("EvaluationId")]
        public CandidateEvaluation? CandidateEvaluation { get; set; }

        [ForeignKey("CriterionId")]
        public EvaluationCriteria? EvaluationCriteria { get; set; }
    }
}
