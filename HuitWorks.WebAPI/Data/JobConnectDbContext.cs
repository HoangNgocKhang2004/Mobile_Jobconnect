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
        public DbSet<JobPosting> JobPostings { get; set; }
        public DbSet<JobApplication> JobApplications { get; set; }
        public DbSet<Resume> Resumes { get; set; }
        public DbSet<ResumeSkill> ResumeSkills { get; set; }
        public DbSet<Podcast> Podcasts { get; set; }
        public DbSet<Website> Websites { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            // Primary keys
            modelBuilder.Entity<Role>().HasKey(r => r.IdRole);
            modelBuilder.Entity<Company>().HasKey(c => c.IdCompany);
            modelBuilder.Entity<User>().HasKey(u => u.IdUser);
            modelBuilder.Entity<CandidateInfo>().HasKey(ci => ci.IdUser);
            modelBuilder.Entity<RecruiterInfo>().HasKey(ri => ri.IdUser);
            modelBuilder.Entity<JobPosting>().HasKey(jp => jp.IdJobPost);
            modelBuilder.Entity<JobApplication>().HasKey(ja => ja.IdJobApp);
            modelBuilder.Entity<Resume>().HasKey(r => r.IdResume);
            modelBuilder.Entity<ResumeSkill>().HasKey(rs => new { rs.IdResume, rs.Skill });
            modelBuilder.Entity<Podcast>().HasKey(p => p.IdPodcast);
            modelBuilder.Entity<Website>().HasKey(w => w.IdWebsite);

            // User -> Role
            modelBuilder.Entity<User>()
                .HasOne(u => u.Role)
                .WithMany()
                .HasForeignKey(u => u.IdRole)
                .OnDelete(DeleteBehavior.Restrict);

            // CandidateInfo -> User (1:1)
            modelBuilder.Entity<CandidateInfo>()
                .HasOne(ci => ci.User)
                .WithOne()
                .HasForeignKey<CandidateInfo>(ci => ci.IdUser)
                .OnDelete(DeleteBehavior.Cascade);

            // RecruiterInfo -> User (1:1)
            modelBuilder.Entity<RecruiterInfo>()
                .HasOne(ri => ri.User)
                .WithOne()
                .HasForeignKey<RecruiterInfo>(ri => ri.IdUser)
                .OnDelete(DeleteBehavior.Cascade);

            // RecruiterInfo -> Company (M:1)
            modelBuilder.Entity<RecruiterInfo>()
                .HasOne(ri => ri.Company)
                .WithMany()
                .HasForeignKey(ri => ri.IdCompany)
                .OnDelete(DeleteBehavior.SetNull);

            // JobPosting -> Company (M:1)
            modelBuilder.Entity<JobPosting>()
                .HasOne(jp => jp.Company)
                .WithMany()
                .HasForeignKey(jp => jp.IdCompany)
                .OnDelete(DeleteBehavior.Cascade);

            // JobApplication -> User (M:1)
            modelBuilder.Entity<JobApplication>()
                .HasOne(ja => ja.User)
                .WithMany()
                .HasForeignKey(ja => ja.IdUser)
                .OnDelete(DeleteBehavior.Cascade);

            // JobApplication -> JobPosting (M:1)
            modelBuilder.Entity<JobApplication>()
                .HasOne(ja => ja.JobPosting)
                .WithMany()
                .HasForeignKey(ja => ja.IdJobPost)
                .OnDelete(DeleteBehavior.Cascade);

            // Resume -> User (M:1)
            modelBuilder.Entity<Resume>()
                .HasOne(r => r.User)
                .WithMany()
                .HasForeignKey(r => r.IdUser)
                .OnDelete(DeleteBehavior.Cascade);

            // ResumeSkill -> Resume (M:1)
            modelBuilder.Entity<ResumeSkill>()
                .HasOne(rs => rs.Resume)
                .WithMany(r => r.ResumeSkills)
                .HasForeignKey(rs => rs.IdResume)
                .OnDelete(DeleteBehavior.Cascade);

            // Podcast and Website have no relations
            modelBuilder.Entity<Podcast>();
            modelBuilder.Entity<Website>();
        }
    }
}
