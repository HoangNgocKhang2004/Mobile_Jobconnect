using Newtonsoft.Json;

namespace HuitWorks.RecruiterWeb.Models
{
    public class RegisterAuthRequest
    {
        [JsonProperty("userName")]
        public string UserName { get; set; }

        [JsonProperty("email")]
        public string Email { get; set; }

        [JsonProperty("password")]
        public string Password { get; set; }

        [JsonProperty("phoneNumber")]
        public string PhoneNumber { get; set; }

        [JsonProperty("roleName")]
        public string RoleName { get; set; }
    }

}
