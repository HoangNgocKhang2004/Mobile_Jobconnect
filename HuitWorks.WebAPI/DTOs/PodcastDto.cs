using System;
using System.ComponentModel.DataAnnotations;

namespace HuitWorks.WebAPI.DTOs
{
    public class PodcastDto
    {
        public string IdPodcast { get; set; } = null!;
        public string Title { get; set; } = null!;
        public int Duration { get; set; }
        public string? Description { get; set; }
        public string? Host { get; set; }
        public string? AudioUrl { get; set; }
        public string? CoverImageUrl { get; set; }
        public DateTime? PublishDate { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
        public int IsFeatured { get; set; }
    }

    public class CreatePodcastDto
    {
        [Required(ErrorMessage = "Tiêu đề là bắt buộc.")]
        [StringLength(255, ErrorMessage = "Tiêu đề không được vượt quá 255 ký tự.")]
        public string Title { get; set; } = null!;

        [Required(ErrorMessage = "Thời lượng là bắt buộc.")]
        public int Duration { get; set; }

        [StringLength(1000, ErrorMessage = "Mô tả không được vượt quá 1000 ký tự.")]
        public string? Description { get; set; }

        [StringLength(100, ErrorMessage = "Tên host không được vượt quá 100 ký tự.")]
        public string? Host { get; set; }

        [StringLength(255, ErrorMessage = "AudioUrl không được vượt quá 255 ký tự.")]
        public string? AudioUrl { get; set; }

        [StringLength(255, ErrorMessage = "CoverImageUrl không được vượt quá 255 ký tự.")]
        public string? CoverImageUrl { get; set; }

        public DateTime? PublishDate { get; set; }
        public int IsFeatured { get; set; }
    }

    public class UpdatePodcastDto
    {
        [StringLength(255, ErrorMessage = "Tiêu đề không được vượt quá 255 ký tự.")]
        public string? Title { get; set; }

        [StringLength(1000, ErrorMessage = "Mô tả không được vượt quá 1000 ký tự.")]
        public string? Description { get; set; }

        [StringLength(100, ErrorMessage = "Tên host không được vượt quá 100 ký tự.")]
        public string? Host { get; set; }

        [StringLength(255, ErrorMessage = "AudioUrl không được vượt quá 255 ký tự.")]
        public string? AudioUrl { get; set; }

        [StringLength(255, ErrorMessage = "CoverImageUrl không được vượt quá 255 ký tự.")]
        public string? CoverImageUrl { get; set; }
        public DateTime? PublishDate { get; set; }
        public int IsFeatured { get; set; }
    }
}
