class ApiConstants {
  // dùng HTTP trên port 5281
  // static const String baseUrl               = "https://localhost:7135";
  static const String baseUrl = "http://10.0.2.2:5281";
  static const String registerEndpoint = "/api/Auth/register";
  static const String loginEndpoint = "/api/Auth/login";
  static const String recruiterInfoEndpoint = "/api/RecruiterInfo";
  static const String candidateInfoEndpoint = "/api/CandidateInfo";
  static const String jobPostingEndpoint = "/api/JobPosting";
  static const String jobPostingSearchEndpoint = "/api/JobPosting/search";
  static const String jobPostingFeaturedEndpoint = "/api/JobPosting/featured";
  static const String jobApplicationPostEndpoint = "/api/JobApplication";
  static const String jobApplicationJobPostEndpoint =
      "/api/JobApplication/jobposting";
  static const String jobApplicationEndpoint = "/api/JobApplication/user";
  static const String jobSavedEndpoint = "/api/JobSaved/user";
  static const String jobSavedPostEndpoint = "/api/JobSaved";
  static const String jobSaveJobPostdEndpoint = "/api/JobSaved";
  static const String podcastEndpoint = "/api/Podcast";
  static const String podcastFeaturedEndpoint = "/api/Podcast/featured";
  static const String userEndpoint = "/api/User";
  static const String roleEndpoint = "/api/Role";
  static const String resumeEndpoint = "/api/Resume";
  static const String resumeSkillEndpoint = "/api/ResumeSkill";
  static const String chatEndpoint = "/api/Chat";
  static const String companiesEndpoint = "/api/Companies";
  static const String companiesFeaturedEndpoint = "/api/Companies/featured";
  static const String notificationEndpoint = "/api/Notification";
  static const String interviewScheduleEndpoint = "/api/InterviewSchedule";
  static const String newsEndpoint = "/api/News";
  static const String subcriptionPackaageEndpoint = "/api/SubcriptionPackage";
  static const String savedResumeEndpoint = "/api/SavedResume";
}
