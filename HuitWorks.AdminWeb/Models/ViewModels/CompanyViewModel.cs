namespace HuitWorks.AdminWeb.Models.ViewModels
{
    public class CompanyViewModel
    {
        public string IdCompany { get; set; }
        public string CompanyName { get; set; }
        public string Address { get; set; }
        public string? Description { get; set; }
        public string? LogoCompany { get; set; }  // JSON field từ API
        public string? WebsiteUrl { get; set; }
        public string? Scale { get; set; }
        public string? Status { get; set; }
        public int? IsFeatured { get; set; }
        public string? Industry { get; set; }
    }
}
