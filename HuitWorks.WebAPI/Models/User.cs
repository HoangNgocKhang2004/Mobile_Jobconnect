namespace HuitWorks.WebAPI.Models
{
    public class User
    {
        public string IdUser { get; set; } = null!;
        public string UserName { get; set; } = null!;
        public string Email { get; set; } = null!;
        public string? PhoneNumber { get; set; }   // NULLable
        public string Password { get; set; } = null!;
        public string IdRole { get; set; } = null!;
        public string AccountStatus { get; set; } = null!;
        public string? AvatarUrl { get; set; }
        public string? SocialLogin { get; set; }

        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }

        public Role Role { get; set; } = null!;
        public CandidateInfo? CandidateInfo { get; set; }
        public RecruiterInfo? RecruiterInfo { get; set; }
        public List<JobApplication> JobApplications { get; set; } = new();
        public List<Resume> Resumes { get; set; } = new();
    }
}
