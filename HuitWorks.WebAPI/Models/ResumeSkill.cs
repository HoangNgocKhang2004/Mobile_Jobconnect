namespace HuitWorks.WebAPI.Models
{
    public class ResumeSkill
    {
        public string IdResume { get; set; } = null!;
        public string Skill { get; set; } = null!;

        public Resume Resume { get; set; } = null!;
    }
}
