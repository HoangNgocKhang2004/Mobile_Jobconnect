class ApiConstants {
  // Dùng HTTP trên port 5281
  //static const String baseUrl               = "https://localhost:5281";
  static const String baseUrl = "http://10.0.2.2:5281";

  // Auth
  static const String registerEndpoint        = "/api/Auth/register";
  static const String loginEndpoint           = "/api/Auth/login";

  // User / Role
  static const String userEndpoint            = "/api/User";
  static const String roleEndpoint            = "/api/Role";

  // Candidate / Recruiter
  static const String candidateInfoEndpoint   = "/api/CandidateInfo";
  static const String recruiterInfoEndpoint   = "/api/RecruiterInfo";

  // JobPosting
  static const String jobPostingEndpoint      = "/api/JobPosting";

  // JobApplication
  static const String jobApplicationEndpoint  = "/api/JobApplication";

  // Resume
  static const String resumeEndpoint          = "/api/Resume";
  static const String resumeSkillEndpoint     = "/api/ResumeSkill";

  // Podcast / Chat
  static const String podcastEndpoint         = "/api/Podcast";
  static const String chatEndpoint            = "/api/Chat";

  // Company / Transaction / Package
  static const String companyEndpoint         = "/api/Companies";

  // Interview / Saved Resume / News / Websites / Notifications
  static const String savedResumeEndpoint    = "/api/SavedResume";
  static const String newsEndpoint           = "/api/News";
  static const String websitesEndpoint       = "/api/Websites";
  static const String notificationsEndpoint  = "/api/Notifications";

  // Chat
  /// Quản lý các cuộc trò chuyện 1-1
  static const String chatThreadsEndpoint     = "/api/chat/threads";
  /// Tin nhắn trong một cuộc trò chuyện
  static const String chatMessagesEndpoint    = "/api/chat/threads"; 

  //Subscription package
  static const String subscriptionPackageEndpoint = "/api/SubscriptionPackage";

  // Job Transaction
  static const String jobTransactionEndpoint  = "/api/JobTransaction";
  static const String jobTransactionDetailEndpoint = "/api/JobTransactionDetails";

  // InterviewSchedule
  static const String interviewScheduleEndpoint = "/api/InterviewSchedule";
  
  // Save Candidate
  static const String saveCandidateEndpoint = "/api/SaveCandidate";

  // Bank
  static const String bankEndpoint = "/api/Bank";

}
