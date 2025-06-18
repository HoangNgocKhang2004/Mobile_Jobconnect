namespace HuitWorks.AdminWeb.Models.ViewModels
{
    public class RecruiterInfoViewModel
    {
        public string IdUser { get; set; }
        public string Title { get; set; }
        public string IdCompany { get; set; }
        public string Department { get; set; }
        public string? Description { get; set; }

        public UserViewModel? User { get; set; }
        public CompanyViewModel? Company { get; set; }
    }
}
