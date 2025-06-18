using System.Text.Json.Serialization;

namespace HuitWorks.RecruiterWeb.Models
{
    public class UserMetadataRequest
    {
        [JsonPropertyName("idUser")] public string IdUser { get; set; }
        [JsonPropertyName("userName")] public string UserName { get; set; }
        [JsonPropertyName("email")] public string Email { get; set; }
        [JsonPropertyName("phoneNumber")] public string PhoneNumber { get; set; }
        [JsonPropertyName("password")] public string Password { get; set; }  // null
        [JsonPropertyName("idRole")] public string IdRole { get; set; }
        [JsonPropertyName("accountStatus")] public string AccountStatus { get; set; }
        [JsonPropertyName("avatarUrl")] public string AvatarUrl { get; set; }
        [JsonPropertyName("gender")] public string Gender { get; set; }
        [JsonPropertyName("address")] public string Address { get; set; }
        [JsonPropertyName("dateOfBirth")] public DateTime? DateOfBirth { get; set; }
    }
}
