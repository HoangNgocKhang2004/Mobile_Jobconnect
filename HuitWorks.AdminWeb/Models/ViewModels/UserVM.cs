namespace HuitWorks.AdminWeb.Models.ViewModels
{
    public class UserVM
    {
        public string IdUser { get; set; }
        public string UserName { get; set; }
        public string Email { get; set; }
        public string PhoneNumber { get; set; }
        public string IdRole { get; set; }
        public string AccountStatus { get; set; }
        public string AvatarUrl { get; set; }
        public string Address { get; set; }
        public DateTime CreatedAt { get; set; }
    }
}
