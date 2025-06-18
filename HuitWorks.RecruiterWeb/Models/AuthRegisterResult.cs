using System.Text.Json.Serialization;

namespace HuitWorks.RecruiterWeb.Models
{
    public class AuthRegisterResult
    {
        [JsonPropertyName("uid")]
        public string Uid { get; set; }

        [JsonPropertyName("email")]
        public string Email { get; set; }

        [JsonPropertyName("displayName")]
        public string DisplayName { get; set; }
    }
}
