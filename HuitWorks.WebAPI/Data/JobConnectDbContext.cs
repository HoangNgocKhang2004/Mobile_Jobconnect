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
        public DbSet<Notification> Notifications { get; set; }
        public DbSet<SubscriptionPackage> SubscriptionPackages { get; set; }
        public DbSet<JobTransaction> JobTransactions { get; set; }
        public DbSet<InterviewSchedule> InterviewSchedules { get; set; }
        public DbSet<SavedResume> SavedResumes { get; set; }
        public DbSet<News> News { get; set; }
        public DbSet<JobSaved> JobSaveds { get; set; }
        public DbSet<ChatThread> ChatThreads { get; set; }
        public DbSet<Message> Messages { get; set; }
        public DbSet<JobTransactionDetail> JobTransactionDetails { get; set; }
        public DbSet<SaveCandidate> SaveCandidates { get; set; }
        public DbSet<EvaluationCriteria> EvaluationCriterias { get; set; }
        public DbSet<CandidateEvaluation> CandidateEvaluations { get; set; }
        public DbSet<EvaluationDetail> EvaluationDetails { get; set; }
        public DbSet<UserActivityLog> UserActivityLogs { get; set; } = null!;
        public DbSet<ReportType> ReportTypes { get; set; } = null!;
        public DbSet<Report> Reports { get; set; } = null!;
        public DbSet<JobPostUsageLog> JobPostUsageLogs { get; set; }
        public DbSet<CvViewUsageLog> CvViewUsageLogs { get; set; }
        public DbSet<Bank> Bank { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            // Primary keys
            modelBuilder.Entity<Role>().HasKey(r => r.IdRole);
            modelBuilder.Entity<Company>().HasKey(c => c.IdCompany);
            modelBuilder.Entity<User>().HasKey(u => u.IdUser);
            modelBuilder.Entity<CandidateInfo>().HasKey(ci => ci.IdUser);
            modelBuilder.Entity<RecruiterInfo>().HasKey(ri => ri.IdUser);
            modelBuilder.Entity<JobPosting>().HasKey(jp => jp.IdJobPost);
            modelBuilder.Entity<JobApplication>().HasKey(ja => new { ja.IdJobPost, ja.IdUser });    
            modelBuilder.Entity<Resume>().HasKey(r => r.IdResume);
            modelBuilder.Entity<ResumeSkill>().HasKey(rs => new { rs.IdResume, rs.Skill });
            modelBuilder.Entity<Podcast>().HasKey(p => p.IdPodcast);
            modelBuilder.Entity<Website>().HasKey(w => w.IdWebsite);
            modelBuilder.Entity<Notification>().HasKey(n => n.IdNotification);
            modelBuilder.Entity<SubscriptionPackage>().HasKey(p => p.IdPackage);
            modelBuilder.Entity<JobTransaction>().HasKey(t => t.IdTransaction);
            modelBuilder.Entity<InterviewSchedule>().HasKey(s => s.IdSchedule);
            modelBuilder.Entity<SavedResume>().HasKey(sr => sr.IdSave);
            modelBuilder.Entity<News>().HasKey(n => n.IdNews);
            modelBuilder.Entity<News>().Property(n => n.IdNews).ValueGeneratedOnAdd();
            modelBuilder.Entity<JobSaved>().HasKey(js => new { js.IdJobPost, js.IdUser });
            modelBuilder.Entity<ChatThread>().HasKey(ct => ct.IdThread);
            modelBuilder.Entity<Message>().HasKey(m => m.IdMessage);
            modelBuilder.Entity<JobTransactionDetail>().HasKey(jt => jt.IdTransaction);
            modelBuilder.Entity<SaveCandidate>().HasKey(sc => new { sc.IdUserRecruiter, sc.IdUserCandidate });
            modelBuilder.Entity<EvaluationCriteria>().HasKey(ec => ec.CriterionId);
            modelBuilder.Entity<CandidateEvaluation>().HasKey(ce => ce.EvaluationId);
            modelBuilder.Entity<EvaluationDetail>().HasKey(ed => ed.EvaluationDetailId);
            modelBuilder.Entity<UserActivityLog>(entity =>
            {
                entity.ToTable("userActivityLog");
                entity.HasKey(u => u.IdLog);
                entity.Property(u => u.IdLog).HasColumnName("idLog").HasMaxLength(64).IsRequired();
                entity.Property(u => u.IdUser).HasColumnName("idUser").HasMaxLength(64).IsRequired();
                entity.Property(u => u.ActionType).HasColumnName("actionType").HasMaxLength(100).IsRequired();
                entity.Property(u => u.Description).HasColumnName("description").HasColumnType("TEXT");
                entity.Property(u => u.EntityName).HasColumnName("entityName").HasMaxLength(100);
                entity.Property(u => u.EntityId).HasColumnName("entityId").HasMaxLength(64);
                entity.Property(u => u.IpAddress).HasColumnName("ipAddress").HasMaxLength(45);
                entity.Property(u => u.UserAgent).HasColumnName("userAgent").HasMaxLength(255);
                entity.Property(u => u.CreatedAt).HasColumnName("createdAt").HasDefaultValueSql("CURRENT_TIMESTAMP").IsRequired();
                entity.HasOne(u => u.User).WithMany().HasForeignKey(u => u.IdUser).OnDelete(DeleteBehavior.Cascade).HasConstraintName("fk_userActivityLog_user");
                entity.HasIndex(u => u.IdUser).HasDatabaseName("idx_userActivityLog_user");
                entity.HasIndex(u => u.ActionType).HasDatabaseName("idx_userActivityLog_action");
            });
            modelBuilder.Entity<ReportType>().HasKey(rt => rt.ReportTypeId);
            modelBuilder.Entity<Report>().HasKey(r => r.ReportId);
            modelBuilder.Entity<Report>().HasOne(r => r.ReportType).WithMany().HasForeignKey(r => r.ReportTypeId).OnDelete(DeleteBehavior.Restrict);
            modelBuilder.Entity<Report>().HasOne(r => r.User).WithMany().HasForeignKey(r => r.UserId).OnDelete(DeleteBehavior.Cascade);
            modelBuilder.Entity<JobPostUsageLog>(entity =>
            {
                entity.ToTable("JobPostUsageLog");
                entity.HasKey(j => j.IdLog);
                entity.Property(j => j.IdLog).HasColumnName("idLog").HasMaxLength(64).IsRequired();
                entity.Property(j => j.IdTransaction).HasColumnName("idTransaction").HasMaxLength(50).IsRequired();
                entity.Property(j => j.IdJobPost).HasColumnName("idJobPost").HasMaxLength(64).IsRequired(false); // Cho phép null (ON DELETE SET NULL)
                entity.Property(j => j.UsedAt).HasColumnName("usedAt").HasDefaultValueSql("CURRENT_TIMESTAMP").IsRequired();
                entity.HasOne(j => j.JobTransaction).WithMany().HasForeignKey(j => j.IdTransaction).OnDelete(DeleteBehavior.Cascade).HasConstraintName("fk_JobPostUsageLog_Transaction");
                entity.HasOne(j => j.JobPosting).WithMany().HasForeignKey(j => j.IdJobPost).OnDelete(DeleteBehavior.SetNull).HasConstraintName("fk_JobPostUsageLog_JobPost");
                entity.HasIndex(j => j.IdTransaction).HasDatabaseName("idx_JobPostUsageLog_transaction");
                entity.HasIndex(j => j.IdJobPost).HasDatabaseName("idx_JobPostUsageLog_jobPost");
            });
            modelBuilder.Entity<CvViewUsageLog>(entity =>
            {
                entity.ToTable("CvViewUsageLog");
                entity.HasKey(c => c.IdLog);
                entity.Property(c => c.IdLog).HasColumnName("idLog").HasMaxLength(64).IsRequired();
                entity.Property(c => c.IdTransaction).HasColumnName("idTransaction").HasMaxLength(50).IsRequired();
                entity.Property(c => c.IdResume).HasColumnName("idResume").HasMaxLength(64).IsRequired(false);
                entity.Property(c => c.UsedAt).HasColumnName("usedAt").HasDefaultValueSql("CURRENT_TIMESTAMP").IsRequired();
                entity.HasOne(c => c.JobTransaction).WithMany().HasForeignKey(c => c.IdTransaction).OnDelete(DeleteBehavior.Cascade).HasConstraintName("fk_CvViewUsageLog_Transaction");
                entity.HasOne(c => c.Resume).WithMany().HasForeignKey(c => c.IdResume).OnDelete(DeleteBehavior.SetNull).HasConstraintName("fk_CvViewUsageLog_Resume");
                entity.HasIndex(c => c.IdTransaction).HasDatabaseName("idx_CvViewUsageLog_transaction");
                entity.HasIndex(c => c.IdResume).HasDatabaseName("idx_CvViewUsageLog_resume");
            });
            modelBuilder.Entity<Bank>().HasKey(b => b.BankId);
        }
    }
}
