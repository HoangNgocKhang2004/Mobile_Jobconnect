namespace HuitWorks.RecruiterWeb.Models.ViewModel
{
    public class ResumeSkillViewModel
    {
        public string IdResume { get; set; } = null!;

        // API trả proficiency là chuỗi (như "85"), nên dùng string:
        public string Skill { get; set; } = null!;
        public string Proficiency { get; set; } = null!;
    }
}
