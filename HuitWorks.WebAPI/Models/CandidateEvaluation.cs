using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace HuitWorks.WebAPI.Models
{
    [Table("candidateEvaluation")]
    public class CandidateEvaluation
    {
        [Key]
        [StringLength(64)]
        [Column("evaluationId")]
        public required string EvaluationId { get; set; }

        [Required, StringLength(64)]
        [Column("idJobPost")]
        public required string IdJobPost { get; set; }    

        [Required, StringLength(64)]
        [Column("idCandidate")]
        public required string IdCandidate { get; set; } 

        [Required, StringLength(64)]
        [Column("idRecruiter")]
        public required string IdRecruiter { get; set; }

        [Column("createdAt")]
        public DateTime CreatedAt { get; set; } = DateTime.Now;

        // Navigation property
        public ICollection<EvaluationDetail>? EvaluationDetails { get; set; }
    }
}
