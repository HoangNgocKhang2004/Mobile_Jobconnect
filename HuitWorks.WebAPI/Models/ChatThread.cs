using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace HuitWorks.WebAPI.Models
{
    public class ChatThread
    {
        [Key]
        [StringLength(64)]
        public required string IdThread { get; set; }

        [Required, StringLength(64)]
        public required string IdUser1 { get; set; }

        [Required, StringLength(64)]
        public required string IdUser2 { get; set; }

        [Required]
        public DateTime CreatedAt { get; set; }

        [ForeignKey(nameof(IdUser1))]
        public required virtual User User1 { get; set; }

        [ForeignKey(nameof(IdUser2))]
        public required virtual User User2 { get; set; }
    }
}
