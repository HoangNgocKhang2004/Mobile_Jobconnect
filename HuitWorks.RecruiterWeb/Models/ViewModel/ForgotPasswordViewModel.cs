using System.ComponentModel.DataAnnotations;

namespace HuitWorks.RecruiterWeb.Models.ViewModel
{
    public class ForgotPasswordViewModel
    {
        [Required(ErrorMessage = "Vui lòng nhập Email.")]
        [EmailAddress(ErrorMessage = "Email không hợp lệ.")]
        public string? Email { get; set; }
    }
}
