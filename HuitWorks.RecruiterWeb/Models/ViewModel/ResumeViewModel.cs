using HuitWorks.RecruiterWeb.Models.Dtos;

namespace HuitWorks.RecruiterWeb.Models.ViewModel
{
    public class ResumeViewModel
    {
        public string IdResume { get; set; } = "";
        public string FileUrl { get; set; } = "";
        public string FileName { get; set; } = "";
        public int FileSizeKB { get; set; }
        public List<ResumeSkillDto> Skills { get; set; } = new();
    }
}
