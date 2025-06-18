namespace HuitWorks.WebAPI.DTOs
{
    public class MessageDto
    {
        public string? IdMessage { get; set; }
        public string? IdThread { get; set; }
        public string? IdSender { get; set; }
        public string? Content { get; set; }
        public DateTime? SentAt { get; set; }
        public bool? IsRead { get; set; }
    }
    public class SendMessageDto
    {
        public string? IdSender { get; set; }
        public string? Content { get; set; }
    }
}
