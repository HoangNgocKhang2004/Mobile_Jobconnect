using System.ComponentModel.DataAnnotations;

namespace HuitWorks.WebAPI.Models
{
    // DTO để nhận dữ liệu tạo Company
    public class CreateCompanyDto
    {
        [Required(ErrorMessage = "CompanyName is required.")]
        [StringLength(100, ErrorMessage = "CompanyName cannot be longer than 100 characters.")]
        public string CompanyName { get; set; } = null!;

        [Required(ErrorMessage = "Address is required.")]
        [StringLength(255, ErrorMessage = "Address cannot be longer than 255 characters.")]
        public string Address { get; set; } = null!;

        [StringLength(500, ErrorMessage = "Description cannot be longer than 500 characters.")]
        public string? Description { get; set; }

        [Url(ErrorMessage = "Invalid URL format for LogoCompany.")]
        [StringLength(255, ErrorMessage = "LogoCompany cannot be longer than 255 characters.")]
        public string? LogoCompany { get; set; }

        [Url(ErrorMessage = "Invalid URL format for WebsiteUrl.")]
        [StringLength(255, ErrorMessage = "WebsiteUrl cannot be longer than 255 characters.")]
        public string? WebsiteUrl { get; set; }

        [Required(ErrorMessage = "Scale is required.")]
        [StringLength(100, ErrorMessage = "Scale cannot be longer than 100 characters.")]
        public string Scale { get; set; } = null!;

        [Required(ErrorMessage = "Industry is required.")]
        [StringLength(100, ErrorMessage = "Industry cannot be longer than 100 characters.")]
        public string Industry { get; set; } = null!;

        public string Status { get; set; } = "active"; // mặc định active
        public int IsFeatured { get; set; } = 0;        // mặc định không nổi bật
    }

    // DTO để nhận dữ liệu cập nhật Company
    public class UpdateCompanyDto
    {
        [Required(ErrorMessage = "CompanyName is required.")]
        [StringLength(100, ErrorMessage = "CompanyName cannot be longer than 100 characters.")]
        public string CompanyName { get; set; } = null!;

        [Required(ErrorMessage = "Address is required.")]
        [StringLength(255, ErrorMessage = "Address cannot be longer than 255 characters.")]
        public string Address { get; set; } = null!;

        [StringLength(500, ErrorMessage = "Description cannot be longer than 500 characters.")]
        public string? Description { get; set; }

        [Url(ErrorMessage = "Invalid URL format for LogoCompany.")]
        [StringLength(255, ErrorMessage = "LogoCompany cannot be longer than 255 characters.")]
        public string? LogoCompany { get; set; }

        [Url(ErrorMessage = "Invalid URL format for WebsiteUrl.")]
        [StringLength(255, ErrorMessage = "WebsiteUrl cannot be longer than 255 characters.")]
        public string? WebsiteUrl { get; set; }

        [Required(ErrorMessage = "Scale is required.")]
        [StringLength(100, ErrorMessage = "Scale cannot be longer than 100 characters.")]
        public string Scale { get; set; } = null!;

        [Required(ErrorMessage = "Industry is required.")]
        [StringLength(100, ErrorMessage = "Industry cannot be longer than 100 characters.")]
        public string Industry { get; set; } = null!;

        [Required(ErrorMessage = "Status is required.")]
        public string Status { get; set; } = "active";

        [Required(ErrorMessage = "IsFeatured is required.")]
        public int IsFeatured { get; set; } = 0;
    }

    // DTO để trả về dữ liệu Company
    public class CompanyDto
    {
        public string IdCompany { get; set; } = null!;
        public string CompanyName { get; set; } = null!;
        public string Address { get; set; } = null!;
        public string? Description { get; set; }
        public string? LogoCompany { get; set; }
        public string? WebsiteUrl { get; set; }
        public string Scale { get; set; } = null!;
        public string Industry { get; set; } = null!;
        public string Status { get; set; } = null!;
        public int IsFeatured { get; set; }
    }
}
