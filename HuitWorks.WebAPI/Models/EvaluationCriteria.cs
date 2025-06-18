using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace HuitWorks.WebAPI.Models
{
    [Table("evaluationCriteria")]
    public class EvaluationCriteria
    {
        [Key]
        [StringLength(64)]
        [Column("criterionId")]
        public required string CriterionId { get; set; } 

        [Required, StringLength(100)]
        [Column("name")]
        public required string Name { get; set; }

        [Column("description")]
        public string? Description { get; set; }

        [Column("createdAt")]
        public DateTime CreatedAt { get; set; } = DateTime.Now;

        public ICollection<EvaluationDetail>? EvaluationDetails { get; set; }
    }
}
