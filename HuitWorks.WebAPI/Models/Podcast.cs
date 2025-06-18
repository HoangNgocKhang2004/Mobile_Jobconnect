using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace HuitWorks.WebAPI.Models
{
    [Table("podcast")]
    public class Podcast
    {
        [Key]
        [Column("idPodcast")]
        [StringLength(64)]
        public required string IdPodcast { get; set; }

        [Required]
        [Column("title")]
        [StringLength(255)]
        public required string Title { get; set; }

        [Required]
        [Column("duration")]
        [StringLength(255)]
        public required int Duration { get; set; }

        [Column("description")]
        public string? Description { get; set; }

        [Column("host")]
        [StringLength(100)]
        public string? Host { get; set; }

        [Column("audioUrl")]
        [StringLength(255)]
        public string? AudioUrl { get; set; }

        [Column("coverImageUrl")]
        [StringLength(255)]
        public string? CoverImageUrl { get; set; }

        [Column("publishDate")]
        public DateTime? PublishDate { get; set; }

        [Required]
        [Column("createdAt")]
        public required DateTime CreatedAt { get; set; }

        [Required]
        [Column("updatedAt")]
        public required DateTime UpdatedAt { get; set; }

        [Required]
        [Column("isFeatured")]
        public required int IsFeatured { get; set; }
    }
}
