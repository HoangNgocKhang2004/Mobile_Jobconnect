using System.ComponentModel.DataAnnotations;

namespace HuitWorks.AdminWeb.Models.ViewModels
{
    public class PodcastViewModel
    {
        [Required]
        public string IdPodcast { get; set; }
        [Required]
        public string Title { get; set; }

        public string? Description { get; set; }

        public string? Host { get; set; }

        public string? AudioUrl { get; set; }

        public string? CoverImageUrl { get; set; }

        public DateTime? PublishDate { get; set; }
    }
}
