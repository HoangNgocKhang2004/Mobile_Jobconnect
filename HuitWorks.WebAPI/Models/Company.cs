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

        [Required]
        [Column("companyName")]
        [StringLength(100)]
        public required string CompanyName { get; set; }

        [Required]
        [Column("address")]
        [StringLength(255)]
        public required string Address { get; set; }

        [Column("description")]
        public string? Description { get; set; }

        [Column("logoCompany")]
        [StringLength(255)]
        public string? LogoCompany { get; set; }

        [Column("websiteUrl")]
        [StringLength(255)]
        public string? WebsiteUrl { get; set; }

        [Required]
        [Column("scale")]
        [StringLength(100)]
        public required string Scale { get; set; }

        [Required]
        [Column("status")]
        public required string Status { get; set; }

        [Required]
        [Column("isFeatured")]
        public required int IsFeatured { get; set; }

        [Required]
        [Column("industry")]
        [StringLength(100)]
        public required string Industry { get; set; }
    }
}
