using Newtonsoft.Json;

namespace HuitWorks.RecruiterWeb.Models.ViewModel
{
    public class JobPosting1ViewModel
    {
        [JsonProperty("idJobPost")]
        public string IdJobPost { get; set; }

        [JsonProperty("title")]
        public string Title { get; set; }

        [JsonProperty("description")]
        public string Description { get; set; }

        [JsonProperty("requirements")]
        public string Requirements { get; set; }

        [JsonProperty("salary")]
        public decimal Salary { get; set; }

        [JsonProperty("location")]
        public string Location { get; set; }

        [JsonProperty("applicationDeadline")]
        public DateTime ApplicationDeadline { get; set; }

        [JsonProperty("createdAt")]
        public DateTime CreatedAt { get; set; }

        [JsonProperty("postStatus")]
        public string PostStatus { get; set; }

        [JsonProperty("idCompany")]
        public string IdCompany { get; set; }

        // Helpers – không serialize riêng lẻ
        [JsonIgnore]
        public bool IsActive
        {
            get => PostStatus == "open";
            set => PostStatus = value ? "open" : "closed";
        }
    }

}
