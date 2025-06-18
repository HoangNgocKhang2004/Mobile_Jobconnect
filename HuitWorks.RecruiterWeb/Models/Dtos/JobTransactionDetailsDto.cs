using Newtonsoft.Json;

namespace HuitWorks.RecruiterWeb.Models.Dtos
{
    public class JobTransactionDetailsDto
    {
        [JsonProperty("idTransaction")] public string IdTransaction { get; set; }
        [JsonProperty("amountFormatted")] public string AmountFormatted { get; set; }
        [JsonProperty("amountInWords")] public string AmountInWords { get; set; }
        [JsonProperty("senderName")] public string SenderName { get; set; }
        [JsonProperty("senderBank")] public string SenderBank { get; set; }
        [JsonProperty("receiverName")] public string ReceiverName { get; set; }
        [JsonProperty("receiverBank")] public string ReceiverBank { get; set; }
        [JsonProperty("content")] public string Content { get; set; }
        [JsonProperty("fee")] public string Fee { get; set; }
    }
}
