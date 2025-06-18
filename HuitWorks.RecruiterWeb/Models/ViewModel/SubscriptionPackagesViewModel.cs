namespace HuitWorks.RecruiterWeb.Models.ViewModel
{
    public class SubscriptionPackagesViewModel
    {
        // Danh sách các gói dịch vụ đang “active” (nếu bạn chỉ muốn show những gói còn hiệu lực)
        public List<SubscriptionPackageDto> Packages { get; set; } = new List<SubscriptionPackageDto>();

        // Id của gói mà user đang sử dụng (lấy từ API /api/JobTransaction, ví dụ: “pack4”)
        public string? ActivePackageId { get; set; }
    }
}
