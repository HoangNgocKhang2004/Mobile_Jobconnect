namespace HuitWorks.RecruiterWeb.Models
{
    public class SocialLoginResponseDto
    {
        public string Token { get; set; } = null!;
        public UserDto User { get; set; } = null!;    // chứa IdUser, Email, UserName, IdRole...
        public bool NeedProfile { get; set; }
    }
}
