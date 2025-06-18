namespace HuitWorks.RecruiterWeb.Models.ViewModel
{
    public class CompanyAccountViewModel
    {
        public CompanyViewModel? Company { get; set; }

        public List<SubscriptionPackageViewModel>? Packages { get; set; }

        public IFormFile? LicenseFile { get; set; }
        public IFormFile? LogoFile { get; set; }
    }
}
