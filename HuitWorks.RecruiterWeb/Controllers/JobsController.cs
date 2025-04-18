// Controllers/JobsController.cs
using HuitWorks.RecruiterWeb.Models;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;

namespace HuitWorks.RecruiterWeb.Controllers
{
    public class JobsController : Controller
    {
        // Tạo danh sách giả định để lưu trữ tạm thời
        private static List<Job> _jobs = new List<Job>
        {
            new Job {
                Id = 1,
                Title = "Lập trình viên ASP.NET Core",
                Description = "Phát triển và bảo trì các ứng dụng web sử dụng ASP.NET Core và SQL Server",
                Requirements = "- Tối thiểu 2 năm kinh nghiệm với C# và ASP.NET Core\n- Hiểu biết về Entity Framework Core\n- Kinh nghiệm làm việc với SQL Server",
                Location = "Hà Nội",
                Salary = "25-30 triệu VNĐ",
                PostedDate = DateTime.Now.AddDays(-5),
                ExpiryDate = DateTime.Now.AddDays(25),
                IsActive = true,
                RequiredCandidates = 3
            },
            new Job {
                Id = 2,
                Title = "UI/UX Designer",
                Description = "Thiết kế giao diện người dùng cho các ứng dụng web và mobile, tạo wireframe và prototype",
                Requirements = "- Kinh nghiệm sử dụng Figma, Adobe XD\n- Portfolio thiết kế UI/UX ấn tượng\n- Kiến thức về UX research",
                Location = "Hồ Chí Minh",
                Salary = "20-25 triệu VNĐ",
                PostedDate = DateTime.Now.AddDays(-10),
                ExpiryDate = DateTime.Now.AddDays(20),
                IsActive = true,
                RequiredCandidates = 2
            },
            new Job {
                Id = 3,
                Title = "React Developer",
                Description = "Phát triển các ứng dụng web sử dụng React, Redux và RESTful API",
                Requirements = "- Tối thiểu 1 năm kinh nghiệm với React\n- Hiểu biết về Redux, RESTful API\n- Thành thạo JavaScript/TypeScript",
                Location = "Đà Nẵng",
                Salary = "18-22 triệu VNĐ",
                PostedDate = DateTime.Now.AddDays(-15),
                ExpiryDate = DateTime.Now.AddDays(15),
                IsActive = false,
                RequiredCandidates = 2
            }
        };

        // GET: Jobs - Hiển thị danh sách bài tuyển dụng
        public IActionResult Index()
        {
            var jobs = _jobs.OrderByDescending(j => j.PostedDate).ToList();
            return View(jobs);
        }

        // GET: Jobs/Details/5 - Xem chi tiết bài tuyển dụng
        public IActionResult Details(int id)
        {
            var job = _jobs.FirstOrDefault(j => j.Id == id);

            if (job == null)
                return NotFound();

            return View(job);
        }

        // GET: Jobs/Create - Form tạo bài tuyển dụng mới
        public IActionResult Create()
        {
            // Thiết lập giá trị mặc định cho ngày đăng và ngày hết hạn
            var job = new Job
            {
                PostedDate = DateTime.Now,
                ExpiryDate = DateTime.Now.AddMonths(1),
                RequiredCandidates = 1,
                IsActive = true
            };

            return View(job);
        }

        // POST: Jobs/Create - Xử lý tạo bài tuyển dụng mới
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Create(Job job)
        {
            if (ModelState.IsValid)
            {
                job.Id = _jobs.Count > 0 ? _jobs.Max(j => j.Id) + 1 : 1;
                job.PostedDate = DateTime.Now;
                job.IsActive = true;

                _jobs.Add(job);
                TempData["SuccessMessage"] = "Bài tuyển dụng đã được tạo thành công.";
                return RedirectToAction(nameof(Index));
            }
            return View(job);
        }

        // GET: Jobs/Edit/5 - Form chỉnh sửa bài tuyển dụng
        public IActionResult Edit(int id)
        {
            var job = _jobs.FirstOrDefault(j => j.Id == id);

            if (job == null)
                return NotFound();

            return View(job);
        }

        // POST: Jobs/Edit/5 - Xử lý chỉnh sửa bài tuyển dụng
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Edit(int id, Job job)
        {
            if (id != job.Id)
                return NotFound();

            if (ModelState.IsValid)
            {
                var existingJob = _jobs.FirstOrDefault(j => j.Id == id);
                if (existingJob != null)
                {
                    existingJob.Title = job.Title;
                    existingJob.Description = job.Description;
                    existingJob.Requirements = job.Requirements;
                    existingJob.Location = job.Location;
                    existingJob.Salary = job.Salary;
                    existingJob.ExpiryDate = job.ExpiryDate;
                    existingJob.IsActive = job.IsActive;
                    existingJob.RequiredCandidates = job.RequiredCandidates;

                    TempData["SuccessMessage"] = "Bài tuyển dụng đã được cập nhật thành công.";
                    return RedirectToAction(nameof(Index));
                }
                return NotFound();
            }
            return View(job);
        }

        // GET: Jobs/Delete/5 - Xác nhận xóa bài tuyển dụng
        public IActionResult Delete(int id)
        {
            var job = _jobs.FirstOrDefault(j => j.Id == id);

            if (job == null)
                return NotFound();

            return View(job);
        }

        // POST: Jobs/Delete/5 - Xử lý xóa bài tuyển dụng
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public IActionResult DeleteConfirmed(int id)
        {
            var job = _jobs.FirstOrDefault(j => j.Id == id);

            if (job != null)
            {
                _jobs.Remove(job);
                TempData["SuccessMessage"] = "Bài tuyển dụng đã được xóa thành công.";
            }

            return RedirectToAction(nameof(Index));
        }

        // POST: Jobs/ToggleStatus/5 - Tắt/bật trạng thái bài tuyển dụng
        [HttpPost]
        public IActionResult ToggleStatus(int id)
        {
            var job = _jobs.FirstOrDefault(j => j.Id == id);

            if (job == null)
                return NotFound();

            job.IsActive = !job.IsActive;

            string message = job.IsActive
                ? "Bài tuyển dụng đã được kích hoạt lại."
                : "Bài tuyển dụng đã được tắt.";

            return Json(new { success = true, message = message, isActive = job.IsActive });
        }
    }
}