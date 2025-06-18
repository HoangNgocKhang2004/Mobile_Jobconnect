namespace HuitWorks.RecruiterWeb.Models.ViewModel
{
    public class JobTransactionDetailViewModel
    {
        public string IdTransaction { get; set; }
        public string AmountFormatted { get; set; }
        public string AmountInWords { get; set; }
        public string SenderName { get; set; }
        public string SenderBank { get; set; }
        public string ReceiverName { get; set; }
        public string ReceiverBank { get; set; }
        public string Content { get; set; }
        public string Fee { get; set; }
    }

}
