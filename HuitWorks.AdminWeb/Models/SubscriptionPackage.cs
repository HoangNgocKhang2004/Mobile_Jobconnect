namespace HuitWorks.AdminWeb.Models
{
    public class SubscriptionPackage
    {
        public string IdPackage { get; set; }
        public string PackageName { get; set; }
        public decimal Price { get; set; }
        public int DurationDays { get; set; }
        public string Description { get; set; }
        public int JobPostLimit { get; set; }
        public int CVViewLimit { get; set; }
        public DateTime CreatedAt { get; set; }
        public bool IsActive { get; set; }
    }

}
