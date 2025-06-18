using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace HuitWorks.WebAPI.Models
{
    [Table("companies")]
    public class Company
    {
        [Key]
        [Column("idCompany")]
        [StringLength(64)]
        public required string IdCompany { get; set; }

        [Column("companyName")]
        [StringLength(100)]
        public required string CompanyName { get; set; }

        [Column("taxCode")]
        [StringLength(14)]
        public required string? TaxCode { get; set; }

        [Column("address")]
        [StringLength(255)]
        public required string? Address { get; set; }

        [Column("description")]
        public string? Description { get; set; }

        [Column("logoCompany")]
        [StringLength(255)]
        public string? LogoCompany { get; set; }

        [Column("websiteUrl")]
        [StringLength(255)]
        public string? WebsiteUrl { get; set; }

        [Column("industry")]
        [StringLength(100)]
        public required string? Industry { get; set; }

        [Column("scale")]
        [StringLength(100)]
        public required string? Scale { get; set; }

        [Column("businessLicenseUrl")]
        [StringLength(255)]
        public string? BusinessLicenseUrl { get; set; }

        [Column("status")]
        public required string? Status { get; set; }

        [Column("isFeatured")]
        public required int IsFeatured { get; set; }

        [Column("createdAt")]
        public DateTime CreatedAt { get; set; }

        [Column("updatedAt")]
        public DateTime UpdatedAt { get; set; }
    }
}
