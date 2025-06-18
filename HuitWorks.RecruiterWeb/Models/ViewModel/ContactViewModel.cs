using HuitWorks.RecruiterWeb.Models.Dtos;
using System.ComponentModel.DataAnnotations;

namespace HuitWorks.RecruiterWeb.Models.ViewModel
{
    public class ContactViewModel
    {
        // Danh sách các loại báo cáo (được load từ API /api/ReportType)
        public List<ReportTypeDto> ReportTypes { get; set; } = new();

        // ID loại báo cáo đã chọn
        [Required(ErrorMessage = "Vui lòng chọn loại báo cáo.")]
        [Display(Name = "Loại Báo Cáo")]
        public int SelectedReportTypeId { get; set; }

        // Tiêu đề báo cáo
        [Required(ErrorMessage = "Tiêu đề không được để trống.")]
        [StringLength(255, ErrorMessage = "Tiêu đề không được vượt quá 255 ký tự.")]
        [Display(Name = "Tiêu Đề")]
        public string Title { get; set; } = string.Empty;

        // Nội dung báo cáo
        [Required(ErrorMessage = "Nội dung không được để trống.")]
        [Display(Name = "Nội Dung")]
        public string Content { get; set; } = string.Empty;

        // Dùng để hiển thị thông báo (success/error)
        public string? Message { get; set; }
        public bool IsSuccess { get; set; } = false;
    }
}
