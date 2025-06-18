using System.Text.Json.Serialization;

namespace HuitWorks.RecruiterWeb.Models
{
    public class RecruiterInfoCreateRequest
    {
        [JsonPropertyName("idUser")] public string IdUser { get; set; }
        [JsonPropertyName("title")] public string Title { get; set; }
        [JsonPropertyName("idCompany")] public string IdCompany { get; set; }
        [JsonPropertyName("department")] public string Department { get; set; }
        [JsonPropertyName("description")] public string Description { get; set; }
    }
}
