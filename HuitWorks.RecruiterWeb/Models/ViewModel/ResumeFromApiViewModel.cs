namespace HuitWorks.RecruiterWeb.Models.ViewModel
{
    public class ResumeFromApiViewModel
    {
        public string IdResume { get; set; } = null!;
        public string IdUser { get; set; } = null!;
        public string FileUrl { get; set; } = null!;
        public string FileName { get; set; } = null!;
        public int FileSizeKB { get; set; }

        // Trước đây bạn khai báo:
        // public bool IsDefault { get; set; }
        //
        // Đổi lại thành int cho khớp với WebAPI trả về 0 hoặc 1:
        public int IsDefault { get; set; }

        public DateTime CreatedAt { get; set; }
        public DateTime UpdatedAt { get; set; }
    }

}
