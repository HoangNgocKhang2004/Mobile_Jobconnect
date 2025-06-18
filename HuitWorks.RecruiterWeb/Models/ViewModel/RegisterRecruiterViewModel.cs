using System.ComponentModel.DataAnnotations;
using static AuthController;

namespace HuitWorks.RecruiterWeb.Models.ViewModel
{
    public class RegisterRecruiterViewModel
    {
        // User
        [Required] public string? UserName { get; set; }
        [Required(ErrorMessage = "Mã số thuế là bắt buộc.")]
        [StringLength(50, ErrorMessage = "Mã số thuế không vượt quá 50 ký tự.")]
        public string TaxCode { get; set; } = null!;
        [Required, EmailAddress] public string? Email { get; set; }
        [Required, Phone] public string? PhoneNumber { get; set; }
        [Required, DataType(DataType.Password)] public string? Password { get; set; }
        [Required, DataType(DataType.Password), Compare("Password")] public string ConfirmPassword { get; set; }
        public string? Gender { get; set; }
        public string? Address { get; set; }
        [DataType(DataType.Date)] public DateTime? DateOfBirth { get; set; }
        //public IFormFile AvatarFile { get; set; }
        public IFormFile? BusinessLicenseFile { get; set; }
        // Company
        [Required] public string? CompanyName { get; set; }
        //[Required] public string AddressCompany { get; set; }
        public string? Description { get; set; }
        //public IFormFile LogoCompanyFile { get; set; }
        public string? WebsiteUrl { get; set; }
        public string? Scale { get; set; }
        public string? Industry { get; set; }

        // RecruiterInfo
        [Required] public string? Title { get; set; }
        [Required] public string? Department { get; set; }
        [Required(ErrorMessage = "Vui lòng chọn tỉnh/thành phố")]
        public int ProvinceId { get; set; }

        [Required(ErrorMessage = "Vui lòng chọn quận/huyện")]
        public int DistrictId { get; set; }
        public int WardId { get; set; }
        //nhận danh sách tất cả tỉnh/quận
        public List<ProvinceDto> Provinces { get; set; } = new();

    }
}
