namespace HuitWorks.AdminWeb.Models.ViewModels
{
    public class RoleViewModel
    {
        public string IdRole { get; set; }
        public string RoleName { get; set; }
        public string? Description { get; set; }
        public List<UserViewModel> Users { get; set; } = new List<UserViewModel>();

    }
}
