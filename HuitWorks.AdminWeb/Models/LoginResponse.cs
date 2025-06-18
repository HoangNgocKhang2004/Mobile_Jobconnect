namespace HuitWorks.AdminWeb.Models
{
    public class LoginResponse
    {
        public string Token { get; set; }
        public UserDto User { get; set; }
    }
    public class UserDto
    {
        public string IdUser { get; set; }
        public string UserName { get; set; }
        public string Email { get; set; }
        public string IdRole { get; set; }
        // ... các trường khác nếu cần
    }
}
