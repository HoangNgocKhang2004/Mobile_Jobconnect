using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace HuitWorks.WebAPI.Models
{
    [Table("bank")]
    public class Bank
    {
        [Key]
        [Column("bankId")]
        [StringLength(64)]
        public string BankId { get; set; }

        [Required]
        [Column("bankName")]
        [StringLength(100)]
        public string BankName { get; set; }

        [Required]
        [Column("bankCode")]
        public string BankCode { get; set; }    // Ví dụ: "VCB" cho Vietcombank

        [Required]
        [Column("balance", TypeName = "decimal(15,2)")]
        public decimal Balance { get; set; }

        [Required]
        [Column("cardNumber")]
        [StringLength(20)]
        public string CardNumber { get; set; }

        [Required]
        [Column("accountType")]
        [StringLength(6)]
        public string AccountType { get; set; }      // "VIP" hoặc "Normal"

        [Required]
        [Column("cardType")]
        [StringLength(10)]
        public string CardType { get; set; }         // "Thanh Toán", "Tiết Kiệm" hoặc "Visa"

        [Required]
        [Column("isDefault")]
        [StringLength(10)]
        public bool IsDefault { get; set; }

        [Required]
        [Column("imageUrl")]
        [StringLength(255)]
        public string ImageUrl { get; set; }         // Đường dẫn ảnh ngân hàng/logo

        [Required]
        [Column("userId")]
        [StringLength(64)]
        public string UserId { get; set; }

        // Khóa ngoại về User
        [ForeignKey("UserId")]
        public User User { get; set; }
    }
}
