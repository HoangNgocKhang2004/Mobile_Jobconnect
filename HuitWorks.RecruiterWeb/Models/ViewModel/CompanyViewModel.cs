// HuitWorks.RecruiterWeb/Models/ViewModel/CompanyViewModel.cs
using System;
using System.Text.Json.Serialization;

namespace HuitWorks.RecruiterWeb.Models.ViewModel
{
    public class CompanyViewModel
    {
        public string? IdCompany { get; set; }
        public string? CompanyName { get; set; }
        public string? TaxCode { get; set; }
        public string? Address { get; set; }
        public string? Description { get; set; }
        public string? LogoCompany { get; set; }
        public string? WebsiteUrl { get; set; }
        public string? Scale { get; set; }
        public string? Industry { get; set; }

        // Trường BusinessLicenseUrl sẽ lưu URL file đã upload lên Firebase
        public string? BusinessLicenseUrl { get; set; }

        public string? Status { get; set; }
        public int IsFeatured { get; set; }
        public DateTime? CreatedAt { get; set; }
        public DateTime? UpdatedAt { get; set; }

        // Thông tin gói thuê bao
        public string? CurrentPackageId { get; set; }
        public DateTime? PackageExpireAt { get; set; }
    }
}
