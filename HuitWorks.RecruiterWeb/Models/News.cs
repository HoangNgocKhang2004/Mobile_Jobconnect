using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace HuitWorks.RecruiterWeb.Models
{
    public class News
    {
        public int idNews { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập tiêu đề")]
        [Display(Name = "Tiêu Đề")]
        [StringLength(255)]
        public string Title { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập nội dung")]
        [Display(Name = "Nội Dung")]
        public string Content { get; set; }

        [Display(Name = "Mô Tả Ngắn")]
        [StringLength(500)]
        public string? Summary { get; set; }

        [Display(Name = "Ảnh Đại Diện")]
        [StringLength(255)]
        public string? ImageUrl { get; set; }

        [Required(ErrorMessage = "Vui lòng chọn ngày đăng")]
        [Display(Name = "Ngày Đăng")]
        public DateTime PublishDate { get; set; }

        [Display(Name = "Người Đăng")]
        [StringLength(100)]
        public string? Author { get; set; }

        [Display(Name = "Trạng Thái")]
        public bool IsPublished { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập danh mục")]
        [Display(Name = "Danh Mục")]
        [StringLength(100)]
        public string CategoryName { get; set; }

        [Required(ErrorMessage = "Vui lòng chọn đối tượng hiển thị")]
        [Display(Name = "Dành Cho")]
        public TargetAudience TargetAudience { get; set; }
    }

    public enum TargetAudience
    {
        [Display(Name = "Tất Cả")]
        All,
        [Display(Name = "Ứng Viên")]
        Candidate,
        [Display(Name = "Nhà Tuyển Dụng")]
        Employer
    }
}
