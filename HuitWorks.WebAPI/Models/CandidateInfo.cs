namespace HuitWorks.WebAPI.Models
{
    public class CandidateInfo
    {
        public string IdUser { get; set; } = null!;
        public DateTime? DateOfBirth { get; set; }   // NULLable
        public string? Gender { get; set; }   // NULLable
        public string? Address { get; set; }   // NULLable

        public User User { get; set; } = null!;
    }
}
