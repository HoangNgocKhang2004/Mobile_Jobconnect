namespace HuitWorks.RecruiterWeb.Models
{
    public class SavedResumeDto
    {
        public string IdSave { get; set; } = null!;
        public string IdRecruiter { get; set; } = null!;
        public string IdCandidate { get; set; } = null!;
        public DateTime SavedAt { get; set; }
    }
}
