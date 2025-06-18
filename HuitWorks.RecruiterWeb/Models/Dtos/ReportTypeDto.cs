namespace HuitWorks.RecruiterWeb.Models.Dtos
{
    public class ReportTypeDto
    {
        // Đây là IdLoaiBaoCao (INT) trong DB, do API trả về
        public int ReportTypeId { get; set; }

        // TenLoai (string)
        public string Name { get; set; } = null!;

        // MoTa (string?)
        public string? Description { get; set; }

        public DateTime CreatedDate { get; set; }
    }
}
