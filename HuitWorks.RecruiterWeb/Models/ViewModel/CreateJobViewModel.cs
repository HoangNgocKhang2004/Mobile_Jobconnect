using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace HuitWorks.RecruiterWeb.Models.ViewModel
{
    public class CreateJobViewModel
    {
        [Required] public string JobTitle { get; set; }
        [Required] public string CategoryId { get; set; }
        [Required] public string JobType { get; set; }
        [Required] public string ExperienceLevel { get; set; }
        [Required] public string Location { get; set; }
        [Required] public DateTime Deadline { get; set; }
        public decimal? SalaryFrom { get; set; }
        public decimal? SalaryTo { get; set; }
        public bool NegotiableSalary { get; set; }
        [Required] public int Positions { get; set; }
        public int Gender { get; set; }
        [Required] public string JobDescription { get; set; }
        public List<string> Skills { get; set; } = new();
        public List<string> Benefits { get; set; } = new();
        public bool IsUrgent { get; set; }
        // nếu bạn upload logo rồi xử lý riêng, có thể dùng IFormFile CompanyLogo
    }
}
