namespace HuitWorks.RecruiterWeb.Models
{
    public class Notification
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Message { get; set; }
        public DateTime CreatedAt { get; set; }
        public string Type { get; set; } // System, Job, Candidate, Payment, etc.
        public NotificationStatus Status { get; set; }
        public string ActionUrl { get; set; }

        // Phương thức để định dạng thời gian thông báo thân thiện
        public string GetFriendlyTimeDisplay()
        {
            var timeSpan = DateTime.Now - CreatedAt;

            if (timeSpan.TotalMinutes < 1)
                return "Vừa xong";
            if (timeSpan.TotalHours < 1)
                return $"{(int)timeSpan.TotalMinutes} phút trước";
            if (timeSpan.TotalDays < 1)
                return $"{(int)timeSpan.TotalHours} giờ trước";
            if (timeSpan.TotalDays < 2)
                return "Hôm qua";
            if (timeSpan.TotalDays < 7)
                return $"{(int)timeSpan.TotalDays} ngày trước";

            return CreatedAt.ToString("dd/MM/yyyy");
        }

        // Lấy CSS class cho icon thông báo
        public string GetIconClass()
        {
            return Type.ToLower() switch
            {
                "system" => "system",
                "job" => "success",
                "candidate" => "info",
                "payment" => Type.Contains("failed") || Type.Contains("error") ? "danger" : "warning",
                _ => "system"
            };
        }

        // Lấy emoji icon cho thông báo
        public string GetIcon()
        {
            return Type.ToLower() switch
            {
                "system" => "⚙️",
                "job" => "✓",
                "candidate" => "👤",
                "payment" => Type.Contains("failed") || Type.Contains("error") ? "!" : "⚠️",
                _ => "🔔"
            };
        }
    }

    public enum NotificationStatus
    {
        Unread = 0,
        Read = 1
    }
}
