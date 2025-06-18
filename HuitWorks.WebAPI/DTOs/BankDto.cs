namespace HuitWorks.WebAPI.DTOs
{
    public class BankDto
    {
        public string BankId { get; set; }
        public string BankName { get; set; }
        public string BankCode { get; set; }    
        public decimal Balance { get; set; }
        public string CardNumber { get; set; }
        public string AccountType { get; set; }      // "VIP" hoặc "Normal"
        public string CardType { get; set; }         // "Thanh Toán", "Tiết Kiệm" hoặc "Visa"
        public bool IsDefault { get; set; }
        public string ImageUrl { get; set; }        
        public string UserId { get; set; }
    }

    public class CreateBankDto
    {
        public string BankName { get; set; }
        public string BankCode { get; set; }   
        public decimal Balance { get; set; }
        public string CardNumber { get; set; }
        public string AccountType { get; set; }
        public string CardType { get; set; }
        public bool IsDefault { get; set; }
        public string ImageUrl { get; set; }         
        public string UserId { get; set; }
    }

    public class UpdateBankDto
    {
        public string BankName { get; set; }
        public string? BankCode { get; set; }    
        public decimal? Balance { get; set; }
        public string CardNumber { get; set; }
        public string AccountType { get; set; }
        public string CardType { get; set; }
        public bool IsDefault { get; set; }
        public string? ImageUrl { get; set; }      
    }

    public class UpdateBalanceDto
    {
        public decimal Balance { get; set; }
    }
}
