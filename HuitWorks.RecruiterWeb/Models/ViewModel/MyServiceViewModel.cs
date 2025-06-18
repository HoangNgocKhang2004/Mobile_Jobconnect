using HuitWorks.RecruiterWeb.Models.Dtos;

namespace HuitWorks.RecruiterWeb.Models.ViewModel
{
    public class MyServiceViewModel
    {
        public string TransactionId { get; set; }
        public string PackageName { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime? ExpireDate { get; set; }
        public decimal Price { get; set; }
        public string PaymentMethod { get; set; }
        public string Status { get; set; }
        public JobTransactionDetailsDto Details { get; set; }
    }

}
