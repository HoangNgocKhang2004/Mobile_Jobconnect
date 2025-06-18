using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace HuitWorks.WebAPI.Models
{
    [Table("recruiterInfo")]
    public class RecruiterInfo
    {
        [Key]
        [Column("idUser")]
        [StringLength(64)]
        public required string IdUser { get; set; }

        [Column("title")]
        [StringLength(100)]
        public required string? Title { get; set; }

        [Column("idCompany")]
        [StringLength(64)]
        public string? IdCompany { get; set; }

        [Column("department")]
        [StringLength(100)]
        public string? Department { get; set; }

        [Column("description")]
        public string? Description { get; set; }
    }
}
