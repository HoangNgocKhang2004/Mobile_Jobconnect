using HuitWorks.RecruiterWeb.Models;
using Microsoft.AspNetCore.Mvc;

namespace HuitWorks.RecruiterWeb.Controllers
{
    public class CandidatesController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }

        public IActionResult Interviews()
        {
            // Dữ liệu thô mẫu
            var interviews = new List<InterviewViewModel>
        {
            new InterviewViewModel {
                Id = 1,
                CandidateName = "Nguyễn Văn A",
                PositionTitle = "Backend Developer",
                InterviewDateTime = new DateTime(2025, 4, 25, 10, 0, 0),
                Mode = "Offline",
                Status = "Đang chờ"
            },
            new InterviewViewModel {
                Id = 2,
                CandidateName = "Trần Thị B",
                PositionTitle = "Frontend Developer",
                InterviewDateTime = new DateTime(2025, 4, 26, 14, 30, 0),
                Mode = "Online",
                Status = "Đang chờ"
            },
            new InterviewViewModel {
                Id = 3,
                CandidateName = "Lê Thị C",
                PositionTitle = "Fullstack Developer",
                InterviewDateTime = new DateTime(2025, 4, 27, 9, 0, 0),
                Mode = "Offline",
                Status = "Đã hoàn thành"
            },
            new InterviewViewModel {
                Id = 4,
                CandidateName = "Phạm Văn D",
                PositionTitle = "Mobile Developer",
                InterviewDateTime = new DateTime(2025, 4, 28, 13, 0, 0),
                Mode = "Online",
                Status = "Hủy"
            },
            new InterviewViewModel {
                Id = 5,
                CandidateName = "Đỗ Thị E",
                PositionTitle = "QA Engineer",
                InterviewDateTime = new DateTime(2025, 4, 29, 15, 0, 0),
                Mode = "Offline",
                Status = "Đang chờ"
            },
            new InterviewViewModel {
                Id = 6,
                CandidateName = "Hoàng Văn F",
                PositionTitle = "Data Analyst",
                InterviewDateTime = new DateTime(2025, 5, 1, 11, 0, 0),
                Mode = "Online",
                Status = "Đang chờ"
            },
            new InterviewViewModel {
                Id = 7,
                CandidateName = "Vũ Thị G",
                PositionTitle = "DevOps Engineer",
                InterviewDateTime = new DateTime(2025, 5, 2, 10, 30, 0),
                Mode = "Offline",
                Status = "Đang chờ"
            },
            new InterviewViewModel {
                Id = 8,
                CandidateName = "Trương Văn H",
                PositionTitle = "UI/UX Designer",
                InterviewDateTime = new DateTime(2025, 5, 3, 14, 0, 0),
                Mode = "Online",
                Status = "Đang chờ"
            },
            new InterviewViewModel {
                Id = 9,
                CandidateName = "Ngô Thị I",
                PositionTitle = "Product Manager",
                InterviewDateTime = new DateTime(2025, 5, 4, 9, 30, 0),
                Mode = "Offline",
                Status = "Đang chờ"
            },
            new InterviewViewModel {
                Id = 10,
                CandidateName = "Bùi Văn K",
                PositionTitle = "Business Analyst",
                InterviewDateTime = new DateTime(2025, 5, 5, 16, 0, 0),
                Mode = "Online",
                Status = "Đang chờ"
            }
        };

            return View(interviews);
        }
    }
}
