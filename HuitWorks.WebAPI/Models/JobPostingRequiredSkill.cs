namespace HuitWorks.WebAPI.Models
{
    public class JobPostingRequiredSkill
    {
        public string IdJobPost { get; set; }
        public string Skill { get; set; }

        public JobPosting JobPosting { get; set; }
    }
}