namespace HuitWorks.RecruiterWeb.Models.Dtos
{
    public class ResumeDto
    {
        public string IdResume { get; set; } = "";
        public string IdUser { get; set; } = "";
        public string FileUrl { get; set; } = "";
        public string FileName { get; set; } = "";
        public int FileSizeKB { get; set; }
        public int IsDefault { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
    }
}
