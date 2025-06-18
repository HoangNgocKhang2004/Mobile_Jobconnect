using System.ComponentModel.DataAnnotations;

namespace HuitWorks.AdminWeb.Models.ViewModels
{
    public class PodcastCreateViewModel
    {
        [Required]
        [StringLength(255)]
        public string Title { get; set; }

        public string? Description { get; set; }

        [StringLength(100)]
        public string? Host { get; set; }

        [StringLength(255)]
        public string? AudioUrl { get; set; }

        [StringLength(255)]
        public string? CoverImageUrl { get; set; }

        public DateTime? PublishDate { get; set; }
    }
}
