namespace HuitWorks.RecruiterWeb.Models.ViewModel
{
    public class NotificationViewModel
    {
        public string IdNotification { get; set; }
        public string IdUser { get; set; }
        public string Title { get; set; }
        public string Type { get; set; }
        public DateTime DateTime { get; set; }
        public string Status { get; set; }
        public string ActionUrl { get; set; }
        public DateTime CreatedAt { get; set; }
        public int IsRead { get; set; }
    }
}
