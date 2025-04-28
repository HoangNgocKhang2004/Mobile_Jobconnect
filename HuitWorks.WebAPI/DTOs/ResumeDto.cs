namespace HuitWorks.WebAPI.Dtos
{
    public class ResumeDto
    {
        public string IdResume { get; set; } = null!;
        public string IdUser { get; set; } = null!;
        public string Experience { get; set; } = null!;
        public string Education { get; set; } = null!;
        public string? Portfolio { get; set; }
        public string? CvFileUrl { get; set; }
        public bool IsPublic { get; set; }
        public decimal? SuitabilityScore { get; set; }
        public string? PreferredJobType { get; set; }
        public decimal? SalaryExpectation { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
        public List<string> Skills { get; set; } = new(); // Chỉ trả về danh sách tên kỹ năng
        public string UserName { get; set; } = null!; // Chỉ trả về tên người dùng, không phải toàn bộ User
    }
}