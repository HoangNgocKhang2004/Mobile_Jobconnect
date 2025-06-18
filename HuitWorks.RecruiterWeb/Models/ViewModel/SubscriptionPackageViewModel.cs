namespace HuitWorks.RecruiterWeb.Models.ViewModel
{
    public class SubscriptionPackageViewModel
    {
        public string IdPackage { get; set; }
        public string PackageName { get; set; }
        public decimal Price { get; set; }
        public int DurationDays { get; set; }
        public string Description { get; set; }
        public int JobPostLimit { get; set; }
        public int CvViewLimit { get; set; }
        public DateTime CreatedAt { get; set; }
        public bool IsActive { get; set; }
    }
}
