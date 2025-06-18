namespace HuitWorks.AdminWeb.Models
{
    public class ReportDto
    {
        public string ReportId { get; set; } = null!;
        public string UserId { get; set; } = null!;
        public int ReportTypeId { get; set; }
        public string? Title { get; set; }
        public string? Content { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }

        public ReportTypeDto? ReportType { get; set; }
    }
    public class ReportTypeDto
    {
        public int ReportTypeId { get; set; }
        public string Name { get; set; } = null!;
        public string? Description { get; set; }
        public DateTime CreatedDate { get; set; }
    }
}
