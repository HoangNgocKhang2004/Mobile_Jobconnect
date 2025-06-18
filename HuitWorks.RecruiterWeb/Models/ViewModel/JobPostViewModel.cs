// File: Models/ViewModel/JobPostViewModel.cs
using System;
using System.ComponentModel.DataAnnotations;

namespace HuitWorks.RecruiterWeb.Models.ViewModel
{
    public class JobPostViewModel
    {
        public string IdJobPost { get; set; } = null!;

        [Required(ErrorMessage = "Tiêu đề công việc là bắt buộc.")]
        public string Title { get; set; } = null!;

        [Required(ErrorMessage = "Mô tả công việc là bắt buộc.")]
        public string Description { get; set; } = null!;

        public string? Requirements { get; set; }
        public string? Salary { get; set; }
        [Required(ErrorMessage = "Vui lòng chọn địa điểm trên bản đồ.")]
        public string? Location { get; set; }

        // Hai trường lưu kinh/vĩ độ
        public double? Latitude { get; set; }
        public double? Longitude { get; set; }
        public string? WorkType { get; set; }
        public string? ExperienceLevel { get; set; }

        [Required]
        public string? IdCompany { get; set; }

        [Required(ErrorMessage = "Hạn nộp hồ sơ là bắt buộc.")]
        public DateTime ApplicationDeadline { get; set; }

        public string? Benefits { get; set; }

        public bool IsFeatured { get; set; }

        public string? PostStatus { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
    }
}
