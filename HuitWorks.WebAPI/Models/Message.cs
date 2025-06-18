using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace HuitWorks.WebAPI.Models
{
    public class Message
    {
        [Key]
        [StringLength(64)]
        public required string IdMessage { get; set; }

        [Required, StringLength(64)]
        public required string IdThread { get; set; }

        [Required, StringLength(64)]
        public required string IdSender { get; set; }

        [Required]
        public required string Content { get; set; }

        [Required]
        public DateTime SentAt { get; set; }

        [Required]
        public bool IsRead { get; set; }

        [ForeignKey(nameof(IdThread))]
        public required virtual ChatThread Thread { get; set; }

        [ForeignKey(nameof(IdSender))]
        public required virtual User Sender { get; set; }
    }
}
