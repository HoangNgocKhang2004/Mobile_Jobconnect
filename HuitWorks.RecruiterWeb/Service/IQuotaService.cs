// File: Service/IQuotaService.cs
using HuitWorks.RecruiterWeb.Models.ViewModel;
using System.Threading.Tasks;

namespace HuitWorks.RecruiterWeb.Service
{
    public interface IQuotaService
    {
        /// <summary>
        /// Trả về transaction đang active (Status=="Completed", chưa hết hạn, còn lượt đăng > 0) mới nhất của user.
        /// </summary>
        Task<JobTransactionViewModel?> GetActiveTransactionAsync(string userId);
    }
}
