namespace HuitWorks.WebAPI.Models
{
    public class Role
    {
        public required string IdRole { get; set; }
        public required string RoleName { get; set; }
        public string? Description { get; set; }
        //public ICollection<User> Users { get; set; }
    }
}