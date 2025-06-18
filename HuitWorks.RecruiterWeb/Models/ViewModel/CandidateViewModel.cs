namespace HuitWorks.RecruiterWeb.Models.ViewModel
{
    public class CandidateViewModel
    {
        public string? IdUser { get; set; }
        public string? UserName { get; set; }
        public string? Email { get; set; }
        public string? WorkPosition { get; set; }
        public double? RatingScore { get; set; }
        public string? UniversityName { get; set; }
        public string? EducationLevel { get; set; }
        public int? ExperienceYears { get; set; }
        public string? Skills { get; set; }
        public bool IsSaved { get; set; }
        // Chúng ta thêm 2 dòng sau để lưu thông tin CV:
        /// <summary>
        /// ID của resume (nếu cần, nhưng thực ra không bắt buộc).
        /// </summary>
        public string? ResumeId { get; set; }

        /// <summary>
        /// Đây chính là URL để xem hoặc tải về file CV của ứng viên.
        /// </summary>
        public string? ResumeFileUrl { get; set; }
    }
}
