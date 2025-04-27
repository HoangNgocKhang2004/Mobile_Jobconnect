using Microsoft.EntityFrameworkCore;
using HuitWorks.WebAPI.Models;

namespace HuitWorks.WebAPI.Data
{
    public class JobConnectDbContext : DbContext
    {
        public JobConnectDbContext(DbContextOptions<JobConnectDbContext> options) : base(options) { }

        public DbSet<Role> Roles { get; set; }
        public DbSet<Company> Companies { get; set; }
        public DbSet<User> Users { get; set; }
        public DbSet<CandidateInfo> CandidateInfo { get; set; }
        public DbSet<RecruiterInfo> RecruiterInfo { get; set; }
        public DbSet<JobPosting> JobPosting { get; set; }
        public DbSet<JobPostingRequiredSkill> JobPostingRequiredSkills { get; set; }
        public DbSet<JobApplication> JobApplication { get; set; }
        public DbSet<Resume> Resumes { get; set; }
        public DbSet<ResumeSkill> ResumeSkills { get; set; }

        protected override void OnModelCreating(ModelBuilder mb)
        {
            mb.Entity<Role>().HasKey(r => r.IdRole);
            mb.Entity<Company>().HasKey(c => c.IdCompany);
            mb.Entity<User>().HasKey(u => u.IdUser);
            mb.Entity<CandidateInfo>().HasKey(ci => ci.IdUser);
            mb.Entity<RecruiterInfo>().HasKey(ri => ri.IdUser);
            mb.Entity<JobPosting>().HasKey(jp => jp.IdJobPost);
            mb.Entity<JobPostingRequiredSkill>().HasKey(js => new { js.IdJobPost, js.Skill });
            mb.Entity<JobApplication>().HasKey(ja => ja.IdJobApp);
            mb.Entity<Resume>().HasKey(r => r.IdResume);
            mb.Entity<ResumeSkill>().HasKey(rs => new { rs.IdResume, rs.Skill });

            // Quan hệ User -> Role
            mb.Entity<User>()
                .HasOne(u => u.Role)
                .WithMany()
                .HasForeignKey(u => u.IdRole)
                .OnDelete(DeleteBehavior.Restrict);

            // Ánh xạ rõ ràng cột IdRole trong bảng Users
            mb.Entity<User>()
                .Property(u => u.IdRole)
                .HasColumnName("idRole"); // Khớp với tên cột trong schema

            // Quan hệ CandidateInfo -> User
            mb.Entity<CandidateInfo>()
                .HasOne(ci => ci.User)
                .WithOne()
                .HasForeignKey<CandidateInfo>(ci => ci.IdUser)
                .OnDelete(DeleteBehavior.Cascade);

            // Quan hệ RecruiterInfo -> User
            mb.Entity<RecruiterInfo>()
                .HasOne(ri => ri.User)
                .WithOne()
                .HasForeignKey<RecruiterInfo>(ri => ri.IdUser)
                .OnDelete(DeleteBehavior.Cascade);

            // Quan hệ RecruiterInfo -> Company
            mb.Entity<RecruiterInfo>()
                .HasOne(ri => ri.Company)
                .WithMany(c => c.Recruiters)
                .HasForeignKey(ri => ri.IdCompany)
                .OnDelete(DeleteBehavior.SetNull);

            // Quan hệ JobPosting -> Company
            mb.Entity<JobPosting>()
                .HasOne(jp => jp.Company)
                .WithMany(c => c.JobPostings)
                .HasForeignKey(jp => jp.IdCompany)
                .OnDelete(DeleteBehavior.Cascade);

            // Quan hệ JobPostingRequiredSkill -> JobPosting
            mb.Entity<JobPostingRequiredSkill>()
                .HasOne(js => js.JobPosting)
                .WithMany(jp => jp.RequiredSkills)
                .HasForeignKey(js => js.IdJobPost)
                .OnDelete(DeleteBehavior.Cascade);

            // Quan hệ JobApplication -> User
            mb.Entity<JobApplication>()
                .HasOne(ja => ja.User)
                .WithMany()
                .HasForeignKey(ja => ja.IdUser)
                .OnDelete(DeleteBehavior.Cascade);

            // Quan hệ JobApplication -> JobPosting
            mb.Entity<JobApplication>()
                .HasOne(ja => ja.JobPosting)
                .WithMany(jp => jp.Applications)
                .HasForeignKey(ja => ja.IdJobPost)
                .OnDelete(DeleteBehavior.Cascade);

            // Quan hệ Resume -> User
            mb.Entity<Resume>()
                .HasOne(r => r.User)
                .WithMany()
                .HasForeignKey(r => r.IdUser)
                .OnDelete(DeleteBehavior.Cascade);

            // Quan hệ ResumeSkill -> Resume
            mb.Entity<ResumeSkill>()
                .HasOne(rs => rs.Resume)
                .WithMany(r => r.Skills)
                .HasForeignKey(rs => rs.IdResume)
                .OnDelete(DeleteBehavior.Cascade);
        }
    }
}