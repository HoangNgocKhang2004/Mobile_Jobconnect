// File: Models/ViewModel/JobTransactionViewModel.cs
using System;

namespace HuitWorks.RecruiterWeb.Models.ViewModel
{
    public class JobTransactionViewModel
    {
        public string IdTransaction { get; set; } = null!;
        public string IdUser { get; set; } = null!;
        public string IdPackage { get; set; } = null!;
        public decimal Amount { get; set; }
        public string? PaymentMethod { get; set; }
        public DateTime TransactionDate { get; set; }
        public string? Status { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime ExpiryDate { get; set; }
        public int RemainingJobPosts { get; set; }
        public int RemainingCvViews { get; set; }
    }
}
