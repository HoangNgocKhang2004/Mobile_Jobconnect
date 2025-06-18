using Microsoft.AspNetCore.Mvc.ModelBinding;
using System.ComponentModel.DataAnnotations;

namespace HuitWorks.AdminWeb.Models.ViewModels
{
    public class NotificationViewModel
    {
        [BindNever]
        public string IdNotification { get; set; }

        [Required(ErrorMessage = "Chọn người nhận")]
        public string IdUser { get; set; }

        [Required(ErrorMessage = "Nhập tiêu đề")]
        public string Title { get; set; }

        [Required(ErrorMessage = "Nhập loại thông báo")]
        public string Type { get; set; }

        [Required(ErrorMessage = "Chọn thời gian")]
        public DateTime DateTime { get; set; }

        [Required(ErrorMessage = "Chọn trạng thái")]
        public string Status { get; set; }

        [Required(ErrorMessage = "Nhập URL hành động")]
        public string ActionUrl { get; set; }

        public DateTime CreatedAt { get; set; }

        public int IsRead { get; set; }

        [BindNever]
        public string TargetName { get; set; }
    }

   
}
