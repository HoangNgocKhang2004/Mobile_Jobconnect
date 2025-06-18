using System.ComponentModel.DataAnnotations;

namespace HuitWorks.AdminWeb.Models
{
    public class ServicePackage
    {
        [Required]
        public string Id { get; set; } = string.Empty;

        [Required(ErrorMessage = "Vui lòng nhập tên gói dịch vụ")]
        [Display(Name = "Tên gói dịch vụ")]
        [StringLength(100, ErrorMessage = "Tên gói tối đa 100 ký tự")]
        public string Name { get; set; } = string.Empty;

        [Required(ErrorMessage = "Vui lòng nhập mô tả")]
        [Display(Name = "Mô tả")]
        public string Description { get; set; } = string.Empty;

        [Required(ErrorMessage = "Vui lòng nhập giá")]
        [Display(Name = "Giá (VNĐ)")]
        [Range(0, 999999999, ErrorMessage = "Giá phải lớn hơn 0")]
        public decimal Price { get; set; }

        [Required(ErrorMessage = "Vui lòng nhập thời hạn")]
        [Display(Name = "Thời hạn (ngày)")]
        [Range(1, 365, ErrorMessage = "Thời hạn phải từ 1 đến 365 ngày")]
        public int Duration { get; set; }

        [Display(Name = "Số lượng tin đăng")]
        [Range(0, 1000, ErrorMessage = "Số lượng tin đăng phải từ 0 đến 1000")]
        public int JobPostLimit { get; set; }

        [Display(Name = "Số lượng CV xem được")]
        [Range(0, 10000, ErrorMessage = "Số lượng CV xem được phải từ 0 đến 10000")]
        public int CVViewLimit { get; set; }

        [Display(Name = "Ngày tạo")]
        public DateTime CreatedDate { get; set; }

        [Display(Name = "Ngày cập nhật")]
        public DateTime? UpdatedAt { get; set; }

        [Display(Name = "Trạng thái")]
        public bool IsActive { get; set; }
    }
}
