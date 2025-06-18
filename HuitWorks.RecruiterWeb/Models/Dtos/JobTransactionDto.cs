using Newtonsoft.Json;

namespace HuitWorks.RecruiterWeb.Models.Dtos
{
    public class JobTransactionDto
    {
        [JsonProperty("idTransaction")] public string IdTransaction { get; set; }
        [JsonProperty("idUser")] public string IdUser { get; set; }
        [JsonProperty("idPackage")] public string IdPackage { get; set; }
        [JsonProperty("amount")] public decimal Amount { get; set; }
        [JsonProperty("paymentMethod")] public string PaymentMethod { get; set; }
        [JsonProperty("transactionDate")] public DateTime TransactionDate { get; set; }
        [JsonProperty("status")] public string Status { get; set; }

    }
}
