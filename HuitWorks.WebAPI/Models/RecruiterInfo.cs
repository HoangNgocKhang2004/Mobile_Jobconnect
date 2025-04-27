namespace HuitWorks.WebAPI.Models
{
    public class RecruiterInfo
    {
        public string IdUser { get; set; } = null!;
        public string? Department { get; set; }
        public string? Title { get; set; }
        public string? IdCompany { get; set; }
        public User User { get; set; } = null!;
        public Company? Company { get; set; }
    }
}
