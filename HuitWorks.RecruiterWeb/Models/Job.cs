// Models/Job.cs
using System;
using System.ComponentModel.DataAnnotations;

namespace HuitWorks.RecruiterWeb.Models
{
    public class Job
    {
        public int Id { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập tiêu đề công việc")]
        [StringLength(100, ErrorMessage = "Tiêu đề không được vượt quá 100 ký tự")]
        [Display(Name = "Tiêu đề")]
        public string Title { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập mô tả công việc")]
        [Display(Name = "Mô tả")]
        public string Description { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập yêu cầu công việc")]
        [Display(Name = "Yêu cầu")]
        public string Requirements { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập địa điểm làm việc")]
        [Display(Name = "Địa điểm")]
        public string Location { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập mức lương")]
        [Display(Name = "Mức lương")]
        public string Salary { get; set; }

        [Display(Name = "Ngày đăng")]
        public DateTime PostedDate { get; set; }

        [Display(Name = "Ngày hết hạn")]
        [Required(ErrorMessage = "Vui lòng chọn ngày hết hạn")]
        public DateTime ExpiryDate { get; set; }

        [Display(Name = "Trạng thái")]
        public bool IsActive { get; set; } = true;

        [Display(Name = "Số lượng ứng viên cần tuyển")]
        [Range(1, 100, ErrorMessage = "Số lượng ứng viên phải từ 1 đến 100")]
        public int RequiredCandidates { get; set; }
    }
}