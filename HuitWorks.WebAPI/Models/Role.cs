namespace HuitWorks.WebAPI.Models
{
    public class Role
    {
        public string IdRole { get; set; }
        public string RoleName { get; set; }
        public string Description { get; set; }

        public ICollection<User> Users { get; set; }
    }
}