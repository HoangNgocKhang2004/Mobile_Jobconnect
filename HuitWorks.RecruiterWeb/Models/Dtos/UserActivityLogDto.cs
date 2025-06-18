namespace HuitWorks.RecruiterWeb.Models.Dtos
{
    public class UserActivityLogDto
    {
        public string IdLog { get; set; } = null!;
        public string IdUser { get; set; } = null!;
        public string ActionType { get; set; } = null!;
        public string? Description { get; set; }
        public string? EntityName { get; set; }
        public string? EntityId { get; set; }
        public string? IpAddress { get; set; }
        public string? UserAgent { get; set; }
        public DateTime CreatedAt { get; set; }
    }
}
