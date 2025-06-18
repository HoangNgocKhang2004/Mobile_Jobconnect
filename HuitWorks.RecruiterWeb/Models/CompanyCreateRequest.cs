using System.Text.Json.Serialization;

namespace HuitWorks.RecruiterWeb.Models
{
    public class CompanyCreateRequest
    {
        [JsonPropertyName("companyName")] public string CompanyName { get; set; }
        [JsonPropertyName("address")] public string Address { get; set; }
        [JsonPropertyName("description")] public string Description { get; set; }
        [JsonPropertyName("logoCompany")] public string LogoCompany { get; set; }
        [JsonPropertyName("websiteUrl")] public string WebsiteUrl { get; set; }
        [JsonPropertyName("scale")] public int Scale { get; set; }
        [JsonPropertyName("industry")] public string Industry { get; set; }
        [JsonPropertyName("status")] public string Status { get; set; }
        [JsonPropertyName("isFeatured")] public int IsFeatured { get; set; }
    }
}
