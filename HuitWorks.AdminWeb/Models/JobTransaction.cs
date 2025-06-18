namespace HuitWorks.AdminWeb.Models
{
    public class JobTransaction
    {
        public string IdTransaction { get; set; }
        public string IdUser { get; set; }
        public string IdPackage { get; set; }
        public decimal Amount { get; set; }
        public string PaymentMethod { get; set; }
        public DateTime TransactionDate { get; set; }
        public string Status { get; set; }
        public string UserName { get; set; }
        public string PackageName { get; set; }
    }

}
