namespace HuitWorks.AdminWeb.Models.ViewModels
{
    public class JobPostingVM
    {
        public string IdJobPost { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public string Requirements { get; set; }
        public decimal Salary { get; set; }
        public string Location { get; set; }
        public string workType { get; set; }
        public string ExperienceLevel { get; set; }
        public string IdCompany { get; set; }
        public DateTime ApplicationDeadline { get; set; }
        public string Benefits { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
        public string PostStatus { get; set; }
        public List<string>? RequiredSkills { get; set; }
        public CompanyViewModel Company { get; set; }

        // Thuộc tính đọc nhanh CompanyName
        public string CompanyName => Company?.CompanyName;
    }

}
