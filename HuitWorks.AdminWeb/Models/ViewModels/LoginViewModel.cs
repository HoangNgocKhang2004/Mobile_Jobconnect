using System.ComponentModel.DataAnnotations;

namespace HuitWorks.AdminWeb.Models.ViewModels
{
    public class LoginViewModel
    {
        [Required]
        [Display(Name = "Email hoặc tên đăng nhập")]
        public string Username { get; set; }

        [Required]
        [DataType(DataType.Password)]
        public string Password { get; set; }
    }
}
