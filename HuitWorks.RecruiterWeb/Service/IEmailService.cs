﻿namespace HuitWorks.RecruiterWeb.Service
{
    public interface IEmailService
    {
        Task SendEmailAsync(string toEmail, string subject, string htmlBody);
    }
}
