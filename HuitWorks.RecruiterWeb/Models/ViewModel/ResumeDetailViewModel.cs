namespace HuitWorks.RecruiterWeb.Models.ViewModel
{
    public class ResumeDetailViewModel
    {
        public ResumeViewModel Resume { get; set; } = null!;
        public List<ResumeSkillViewModel> Skills { get; set; } = new();
    }
}
