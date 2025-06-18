using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace HuitWorks.WebAPI.Models
{
    [Table("resumes")]
    public class Resume
    {
        [Key]
        [Column("idResume")]
        [StringLength(64)]
        public required string IdResume { get; set; }

        [Required]
        [Column("idUser")]
        [StringLength(64)]
        public required string IdUser { get; set; }

        [Required]
        [Column("fileUrl")]
        [StringLength(255)]
        public required string FileUrl { get; set; }

        [Required]
        [Column("fileName")]
        [StringLength(255)]
        public required string FileName { get; set; }

        [Column("fileSizeKB")]
        public int FileSizeKB { get; set; }

        [Required]
        [Column("isDefault")]
        public required int IsDefault { get; set; }

        [Required]
        [Column("createdAt")]
        public required DateTime CreatedAt { get; set; }

        [Required]
        [Column("updatedAt")]
        public required DateTime UpdatedAt { get; set; }
    }
}