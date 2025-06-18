namespace HuitWorks.AdminWeb.Models.ViewModels
{
    public class HRCompanyViewModel
    {
        public string IdCompany { get; set; }
        public string CompanyName { get; set; }
        public string Address { get; set; }
        public string? Description { get; set; }
        public string? LogoCompany { get; set; }  // <- lấy từ Company
        public string? WebsiteUrl { get; set; }
        public string? Scale { get; set; }

        public string IdUser { get; set; }
        public string UserName { get; set; }
        public string Email { get; set; }
        public string? PhoneNumber { get; set; }
        public string? AvatarUrl { get; set; }

        public string Department { get; set; }
        public string Title { get; set; }
        public string? AccountStatus { get; set; }
        public RecruiterInfoViewModel? Recruiter { get; set; }
        public UserViewModel? User { get; set; }
    }
}