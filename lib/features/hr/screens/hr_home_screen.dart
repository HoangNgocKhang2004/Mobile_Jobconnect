import 'dart:math';

import 'package:flutter/material.dart';
import 'package:job_connect/core/models/account_model.dart';
import 'package:job_connect/core/models/candidate_info_model.dart';
import 'package:job_connect/core/models/enum.dart';
import 'package:job_connect/core/models/job_transaction_model.dart';
import 'package:job_connect/core/models/subscription_package_model.dart';
import 'package:job_connect/core/services/candidateinfo_service.dart';
import 'package:job_connect/core/services/interviewschedule_service.dart';
import 'package:job_connect/core/services/job_transaction_service.dart';
import 'package:job_connect/core/services/subscriptionpackage_service.dart';
import 'package:job_connect/core/utils/format.dart';
import 'package:job_connect/features/candidate/screens/top_candidates_screen.dart';
import 'package:job_connect/features/hr/screens/hr_all_interview_schedule.dart';
import 'package:job_connect/features/hr/screens/hr_pending_aplication_screen.dart';
import 'package:job_connect/features/hr/screens/hr_recent_activitie_sccreen.dart';
import 'package:job_connect/features/search/screens/hr_search_screen.dart';
import 'package:job_connect/features/post/screens/hr_post_job_screen.dart';
import 'package:job_connect/features/chat/screens/hr_chat_screen.dart';
import 'package:job_connect/features/profile/screens/hr_profile_screen.dart';
import 'package:flutter/services.dart';
import 'package:job_connect/features/recruiter/screens/candidate_list_screen.dart';
import 'package:job_connect/features/settings/screens/hr_setting_screen.dart';
import 'package:job_connect/features/settings/screens/notification_screen.dart';
import 'package:job_connect/features/help/screens/help_screen.dart';
import 'package:job_connect/features/chat/screens/ai_chat_screen.dart';
import 'package:job_connect/features/job/screens/hr_job_list_screen.dart';
import 'package:job_connect/features/auth/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import 'package:job_connect/core/models/company_model.dart';
import 'package:job_connect/core/models/job_application_model.dart';
import 'package:job_connect/core/models/job_posting_model.dart';
import 'package:job_connect/core/models/recruiter_info_model.dart';
import 'package:job_connect/core/services/account_service.dart';
import 'package:job_connect/core/services/company_service.dart';
import 'package:job_connect/core/services/job_application_service.dart';
import 'package:job_connect/core/services/job_posting_service.dart';
import 'package:job_connect/core/services/recruiter_service.dart';
import 'package:job_connect/core/models/interview_schedule_model.dart';

// Bottom navigation của HR
class RecruiterScreen extends StatefulWidget {
  final bool isLoggedIn;
  final Account userAccount;
  final int currentIndex;

  const RecruiterScreen({
    super.key,
    required this.isLoggedIn,
    required this.userAccount,
    required this.currentIndex,
  });

  @override
  // ignore: library_private_types_in_public_api
  _RecruiterScreen createState() => _RecruiterScreen();
}

class _RecruiterScreen extends State<RecruiterScreen> {
  late int _currentIndex;
  late final PageController _pageController;

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
    _pageController = PageController(initialPage: _currentIndex);
    _screens.addAll([
      HRHomeScreen(
        key: PageStorageKey('HRHomeScreen'),
        userAccount: widget.userAccount,
      ),
      SearchHrScreen(
        key: PageStorageKey('SearchHrScreen_${widget.userAccount.idUser}'),
        recruiterId: widget.userAccount.idUser,
      ),
      PostJobPage(
        key: PageStorageKey('PostJobPage_${widget.userAccount.idUser}'),
        recruiterId: widget.userAccount.idUser,
      ),
      HRMessagesPage(
        key: PageStorageKey('HRMessagesPage_${widget.userAccount.idUser}'),
        recruiterId: widget.userAccount.idUser,
      ),
      RecruiterProfilePage(
        key: PageStorageKey('RecruiterProfilePage_${widget.userAccount.idUser}'),
        recruiterId: widget.userAccount.idUser,
        account: widget.userAccount,
      ),
    ]);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    // Chuyển thẳng đến trang tương ứng
    setState(() {
      _currentIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _screens,
      ),
      bottomNavigationBar: Container(
        height: 76,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFFF9FAFC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              spreadRadius: 0,
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(
                  0,
                  Icons.home_outlined,
                  Icons.home_rounded,
                  'Home',
                ),
                _buildNavItem(
                  1,
                  Icons.explore_outlined,
                  Icons.explore,
                  'Explore',
                ),
                _buildNavItem(
                  2,
                  Icons.camera_alt_outlined,
                  Icons.camera_alt,
                  'Post',
                  isSpecial: true,
                ),
                _buildNavItem(
                  3,
                  Icons.chat_bubble_outline_rounded,
                  Icons.chat_bubble_rounded,
                  'Chat',
                ),
                _buildNavItem(
                  4,
                  Icons.person_outline_rounded,
                  Icons.person_rounded,
                  'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData iconOutlined,
    IconData iconFilled,
    String label, {
    bool isSpecial = false,
  }) {
    final isSelected = _currentIndex == index;

    // Nếu là nút đặc biệt (nút thêm bài viết)
    if (isSpecial) {
      return InkWell(
        onTap: () => _onTabTapped(index),
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          width: 64,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6A82FB), Color(0xFFFC5C7D)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFC5C7D).withOpacity(0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    isSelected ? iconFilled : iconOutlined,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 64,
                child: Text(
                  _getShortLabel(label),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color:
                        isSelected
                            ? const Color(0xFFFC5C7D)
                            : Colors.grey.shade500,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Cho các tab thông thường
    return InkWell(
      onTap: () => _onTabTapped(index),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? _getColorForIndex(index).withOpacity(0.12)
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                boxShadow:
                    isSelected
                        ? [
                          BoxShadow(
                            color: _getColorForIndex(index).withOpacity(0.18),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ]
                        : null,
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  transitionBuilder: (
                    Widget child,
                    Animation<double> animation,
                  ) {
                    return ScaleTransition(
                      scale: CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutBack,
                      ),
                      child: FadeTransition(opacity: animation, child: child),
                    );
                  },
                  child: Icon(
                    isSelected ? iconFilled : iconOutlined,
                    key: ValueKey<bool>(isSelected),
                    color:
                        isSelected
                            ? _getColorForIndex(index)
                            : Colors.grey.shade500,
                    size: isSelected ? 24 : 22,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              width: 64,
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color:
                      isSelected
                          ? _getColorForIndex(index)
                          : Colors.grey.shade500,
                ),
                child: Text(
                  _getShortLabel(label),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorForIndex(int index) {
    // Màu sắc khác nhau cho từng tab mang lại sự phong phú
    switch (index) {
      case 0:
        return const Color(0xFF1E88E5); // Blue cho Home
      case 1:
        return const Color(0xFF26A69A); // Teal cho Explore
      case 2:
        return const Color(0xFFFC5C7D); // Pink cho Post
      case 3:
        return const Color(0xFF7E57C2); // Purple cho Messages
      case 4:
        return const Color(0xFF5C6BC0); // Indigo cho Profile
      default:
        return const Color(0xFF1E88E5);
    }
  }

  String _getShortLabel(String label) {
    if (label.length > 10) {
      return '${label.substring(0, 9)}...';
    }
    return label;
  }
}

//Trang home của HR
class HRHomeScreen extends StatefulWidget {
  final Account userAccount;
  const HRHomeScreen({super.key, required this.userAccount});

  @override
  State<HRHomeScreen> createState() => _HRHomeScreenState();
}

class _HRHomeScreenState extends State<HRHomeScreen> {
  //Lấy ngày hiện tại
  List<String> time = FormatApp.formatDateDMY(DateTime.now());

  final AccountService accountService = AccountService();
  final CandidateInfoService candidateInfoService = CandidateInfoService();
  final RecruiterService recruiterService = RecruiterService();
  final CompanyService companyService = CompanyService();
  final JobPostingService jobPostingService = JobPostingService();
  final JobApplicationService jobApplicationService = JobApplicationService();
  final InterviewScheduleService interviewScheduleService = InterviewScheduleService();
  final JobtransactionService jobTransactionService = JobtransactionService();
  final SubscriptionpackageService subscriptionpackageService = SubscriptionpackageService();

  late Account user;
  late RecruiterInfo recruiterInfo;
  late Company companyInfo;
  late List<JobPosting> jobPostingsList = [];
  late List<List<JobApplication>> jobApplicationsList = [];
  late List<List<InterviewSchedule>>? interviewSchedulesList;
  late List<InterviewSchedule> flatInterviewSchedulesList ;
  late List<JobApplication> flatJobApplicationList ;
  late List<InterviewSchedule> upcomingInterviewSchedulesList = [];
  late List<Account> accountInterviewList = [];
  late List<Account> accountJobApplicationList = [];
  late List<CandidateInfo> candidateJobApplicationList = [];
  late List<CandidateInfo>? candidateInterviewList;
  late List<CandidateInfo> candidateAllList = [];
  late List<JobTransaction> jobTransactionsList = [];
  late List<SubscriptionPackage> subscriptionPackagesList = [];
  bool isLoading = true;
  String? error;
  
  // Biển lưu giá trị cũ
  int oldTrendCandidate = 0; // Giá trị ứng viên ứng tuyển cũ
  int oldTrendJob = 0; // Giá trị công việc ứng tuyển cũ
  int oldTrendInterview = 0; // Giá trị đã phỏng vấn cũ
  
  // Ví dụ có giá trị mới:
  late int newCandidate; // Số ứng viên mới
  late int newJob; // Số công việc mới
  late int newInterview; // Số đã phỏng vấn mới

  String trendCandidate = ''; // Biến lưu trữ giá trị trend ứng viên
  String trendJob = ''; // Biến lưu trữ giá trị trend công việc
  String trendInterview = ''; // Biến lưu trữ giá trị trend đã phỏng vấn

  @override
  void initState() {
    super.initState();
    _loadDataAndCalculateTrends();
  }

  // Load dữ liệu
  Future<void> _loadDataAndCalculateTrends() async {
    await _loadAllData(); 

    // Gán các giá trị mới sau khi dữ liệu đã có
    newCandidate = jobApplicationsList.length;
    newJob = jobPostingsList.length;
    newInterview = getApplicationsWithStatus(jobApplicationStatus.interview.name).length;

    // Tính và cập nhật các trend
    trendCandidate = getAndUpdateTrend(
      oldValue: oldTrendCandidate,
      newValue: newCandidate,
      updateOldValue: (val) => oldTrendCandidate = val,
    );

    trendJob = getAndUpdateTrend(
      oldValue: oldTrendJob,
      newValue: newJob,
      updateOldValue: (val) => oldTrendJob = val,
    );

    trendInterview = getAndUpdateTrend(
      oldValue: oldTrendInterview,
      newValue: newInterview,
      updateOldValue: (val) => oldTrendInterview = val,
    );
  }

  // Hàm tải dữ liệu
Future<void> _loadAllData() async {
  try {
    // Lấy toàn bộ thông tin của Candidate
    final allCandidates = await candidateInfoService.fetchAll();

    // 1) Lấy thông tin tài khoản
    final acc = await accountService.fetchAccountById(widget.userAccount.idUser);

    // 2) Lấy thông tin HR
    final rec = await recruiterService.fetchRercuiterById(acc.idUser);

    // 3) Lấy thông tin công ty ứng với HR
    final comp = await companyService.fetchCompanyById(rec.idCompany!);

    // 4) Lấy toàn bộ job thuộc công ty ứng với HR
    List<JobPosting> jobPostings = [];
    if (rec.idCompany != null && rec.idCompany!.isNotEmpty) {
      jobPostings = await jobPostingService.fetchJobPostingsByCompanyId(rec.idCompany!);
    }

    // 5) Lấy toàn bộ job applications ứng với job postings
    List<List<JobApplication>> jobApplications = [];
    for (var job in jobPostings) {
      final apps = await jobApplicationService.fetchByJob(job.idJobPost);
      jobApplications.add(apps);
    }

    // Gộp thành 1 danh sách dài
    List<JobApplication> flatJobAppList = jobApplications.expand((e) => e).toList();

    // Lấy danh sách user ứng tuyển
    List<Account> userOfJobApp = [];
    for (var job in flatJobAppList) {
      final user = await accountService.fetchAccountById(job.idUser);
      userOfJobApp.add(user);
    }

    // Lấy danh sách candidate đã ứng tuyển
    List<CandidateInfo> candidateInforOfJobAppList = [];
    for (var user in userOfJobApp) {
      final candidateJobApp = await candidateInfoService.fetchByUserId(user.idUser);
      candidateInforOfJobAppList.add(candidateJobApp);
    }

    // 6) Lấy toàn bộ interview schedules ứng với job postings
    List<List<InterviewSchedule>> interviewSchedulesTemp = [];
    for (var job in jobPostings) {
      final schedules = await interviewScheduleService.fetchInterviewScheduleByJobId(job.idJobPost);
      if (schedules.isNotEmpty) {
        interviewSchedulesTemp.add(schedules);
      }
    }

    // Gộp thành 1 danh sách dài
    List<InterviewSchedule> flatList = interviewSchedulesTemp.expand((e) => e).toList();

    // Lấy toàn bộ thông tin account sau khi có interview schedules
    List<Account>? accountList = [];
    for (var schedule in flatList) {
      final account = await accountService.fetchAccountById(schedule.idUser);
      accountList.add(account);
    }

    // Lấy toàn bộ thông tin candidate sau khi có account
    List<CandidateInfo>? candidateList = [];
    for (var account in accountList) {
      final candidate = await candidateInfoService.fetchByUserId(account.idUser);
      candidateList.add(candidate);
    }

    // 7) Lấy toàn bộ giao dịch từ JobTransactionService
    final jobTransactions = await jobTransactionService.fetchJobTransactions();

    // 8) Lấy toàn bộ gói dịch vụ từ SubscriptionpackageService
    final subscriptionPackages = await SubscriptionpackageService().fetchSubscriptionPackages();

    setState(() {
      recruiterInfo = rec;
      user = acc;
      companyInfo = comp;
      jobPostingsList = jobPostings;
      jobApplicationsList = jobApplications;
      flatJobApplicationList = flatJobAppList;
      interviewSchedulesList = interviewSchedulesTemp;
      flatInterviewSchedulesList = flatList;
      upcomingInterviewSchedulesList = getUpcomingInterviews(flatList);
      accountInterviewList = accountList;
      accountJobApplicationList = userOfJobApp;
      candidateJobApplicationList = candidateInforOfJobAppList;
      candidateInterviewList = candidateList;
      candidateAllList = allCandidates;
      jobTransactionsList = jobTransactions;
      subscriptionPackagesList = subscriptionPackages; 
      isLoading = false;
    });
  } catch (e) {
    setState(() {
      error = e.toString();
      isLoading = false;
    });
    if (context.mounted) {
      debugPrint(e as String?);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tải dữ liệu: $e')),
      );
    }
  }
}
  //Lấy số vị trí đã tuyển từ jobpostting
  int getPosisionPost(){
    List<String> posisionPost = [];
    for(int i = 0; i < jobPostingsList.length; i++){
      posisionPost.add(jobPostingsList[i].title);
    }
    List<String> posisionPostUnique = posisionPost.toSet().toList();
    return posisionPostUnique.length;
  }

  // Hàm lấy số hồ sơ ở trạng thái đang chờ - pending
  List<JobApplication> getApplicationsWithStatus(String status) {
    List<JobApplication> pendingApplications = [];
    for (var jobApplications in jobApplicationsList) {
      for (var application in jobApplications) {
        if (application.applicationStatus == status) {
          pendingApplications.add(application);
        }
      }
    }
    return pendingApplications;
  }

  // Hàm tính tổng hồ sơ phỏng vấn
  int sumJobApplicationsList() {
    return jobApplicationsList.fold(0, (total, sublist) => total! + sublist.length) ?? 0;
  }

  // Hàm tính tổng lịch phỏng vấn
  int sumInterviewSchedulesList() {
    return interviewSchedulesList?.fold(0, (total, sublist) => total! + sublist.length) ?? 0;
  }

  // Hàm tính số trend ứng viên
  String getAndUpdateTrend({
    required int oldValue,
    required int newValue,
    required void Function(int) updateOldValue,
  }) {
    if (oldValue == 0) {
      updateOldValue(newValue);
      if (newValue > 0) {
        return '100%'; 
      }
      return '0%';
    }

    int increase = (newValue - oldValue);
    double percent = (increase / oldValue) * 100;

    // Cập nhật giá trị cũ với giá trị mới
    updateOldValue(newValue);

    return '${percent.floor()}%';
  }

  // Hàm tính đã vượt qua bao nhiêu ngày
  String getRelativeDateLabel(DateTime inputDate) {
    DateTime now = DateTime.now();
    
    // Làm tròn về 0 giờ để so sánh chỉ ngày, không tính giờ/phút/giây
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime targetDate = DateTime(inputDate.year, inputDate.month, inputDate.day);

    int difference = targetDate.difference(today).inDays;

    if (difference == 0) {
      return 'Hôm nay';
    } else if (difference == -1) {
      return 'Hôm qua';
    } else if (difference == 1) {
      return 'Ngày mai';
    } else if (difference > 1) {
      return '$difference ngày nữa';
    } else {
      return 'Đã qua ${-difference} ngày';
    }
  }

  // Hàm chuẩn hóa giờ phút có am/pm
  String formatHourWithAmPm(DateTime dateTime) {
    int hour = dateTime.hour;
    int minute = dateTime.minute;

    String amPm = hour >= 12 ? 'PM' : 'AM';
    int hour12 = hour % 12;
    if (hour12 == 0) hour12 = 12;

    String minuteStr = minute.toString().padLeft(2, '0');

    return '$hour12:$minuteStr $amPm';
  }

  // Hàm lấy danh sách phỏng vấn sắp tới
  List<InterviewSchedule> getUpcomingInterviews(List<InterviewSchedule> list) {
    DateTime now = DateTime.now();
    // Lấy các lịch phỏng vấn có ngày >= hôm nay, sắp xếp tăng dần theo ngày
    return list
        .where((schedule) => !schedule.interviewDate.isBefore(now))
        .toList()
      ..sort((a, b) => a.interviewDate.compareTo(b.interviewDate));
  }
  
  // Hàm color random avatar
  Color getRandomColor() {
    final Random random = Random();
    return Color.fromARGB(
      255, // Alpha luôn full
      random.nextInt(256), // Red 0-255
      random.nextInt(256), // Green 0-255
      random.nextInt(256), // Blue 0-255
    );
  }

  //Modal logout
  Future<void> _logout(BuildContext context) async {
    bool? confirmLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: _buildLogoutDialog(context),
        );
      },
    );

    if (confirmLogout == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // ignore: use_build_context_synchronously
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }
  // Logout dialog
  Widget _buildLogoutDialog(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF3366FF), Color(0xFF5E91F2)],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: Color(0xFF3366FF),
                    size: 36,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Xác nhận đăng xuất',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Text(
                  'Bạn có chắc chắn muốn đăng xuất khỏi tài khoản hiện tại?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF666666),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF666666),
                          side: const BorderSide(color: Color(0xFFDDDDDD)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'HỦY',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3366FF),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'ĐĂNG XUẤT',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (error != null) {
      return Scaffold(body: Center(child: Text('Lỗi: $error')));
    }

    // Thiết lập theme chung
    final primaryColor = Color(0xFF3366FF);
    final backgroundColor = Color(0xFFF7F9FC);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        //Thanh appbart
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          centerTitle: false,
          title: Text(
            'HR Dashboard',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.black87,
            ),
          ),
          actions: [
            IconButton(
              icon: Badge(
                //label: Text(notificationCount.toString()),
                child: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.black54,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationScreen()),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecruiterScreen(currentIndex: 4, isLoggedIn: true, userAccount: widget.userAccount,), 
                    ),
                  );
                },
                child: CircleAvatar(
                  backgroundImage: NetworkImage(widget.userAccount.avatarUrl ?? 'https://example.com/fallback.png'),
                ),
              ),
            ),
          ],
        ),
        drawer: _buildDrawer(context, primaryColor),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(
                Duration(seconds: 1),
              ); 
              await _loadAllData();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Phần chào mừng
                    _buildWelcomeSection(),
                    SizedBox(height: 16),
                    // Phần thống kê
                    _buildStatisticsSection(primaryColor),
                    SizedBox(height: 16),
                    // Phần hoạt động gần đây
                    _buildRecentActivitiesSection(context),
                    SizedBox(height: 16),
                    // Phần lịch phỏng vấn sắp tới
                    _buildUpcomingSection(context),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Nút AI chat
        // floatingActionButton: FloatingActionButton.extended(
        //   backgroundColor: primaryColor,
        //   icon: const Icon(Icons.smart_toy, color: Colors.white),
        //   label: const Text(
        //     "AI Chat",
        //     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        //   ),
        //   elevation: 4,
        //   onPressed: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => const AIChatScreen()),
        //     );
        //   },
        // ),
      ),
    );
  }

  // Drawer
  Widget _buildDrawer(BuildContext context, Color primaryColor) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [primaryColor, Color(0xFF5E91F2)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  // ignore: deprecated_member_use
                  backgroundColor: Colors.white.withOpacity(0.9),
                  child: Icon(Icons.person, size: 40, color: primaryColor),
                ),
                SizedBox(height: 10),
                Text(
                  widget.userAccount.userName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.userAccount.email,
                  style: TextStyle(
                    // ignore: deprecated_member_use
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            Icons.people_outline,
            'Quản lý ứng viên',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CandidateListPage(
                    recruiterId: widget.userAccount.idUser,
                    candidateInfoList: candidateJobApplicationList,
                    jobApplicationList: flatJobApplicationList,
                  ),
                ),
              );
            },
          ),
          _buildDrawerItem(
            Icons.work_outline,
            'Danh sách công việc',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => JobListScreen(
                  jobpostingList: jobPostingsList,
                  jobApplications: flatJobApplicationList,
                )),
              );
            },
          ),
        //  _buildDrawerItem(
        //   Icons.star_border,
        //   'Danh sách ứng viên nổi bật',
        //   onTap: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => CandidateListScreen(
        //           jobPostingList: jobPostingsList,
        //           jobApplicationList: flatJobApplicationList,
        //           candidateInfoList: candidateAllList,
        //         ),
        //       ),
        //     );
        //   },
        // ),
          _buildDrawerItem(Icons.topic_outlined, 'Báo cáo'),
          _buildDrawerItem(
            Icons.calendar_today_outlined,
            'Lịch phỏng vấn',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AllInterviewSchedulesScreen(),
                ),
              );
            },
          ),
          Divider(),
          _buildDrawerItem(
            Icons.settings_outlined,
            'Cài đặt',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HrSettingsScreen(
                  account: user,
                  company: companyInfo,
                  recruiterInfo: recruiterInfo,
                )),
              );
            },
          ),
          _buildDrawerItem(
            Icons.help_outline,
            'Trợ giúp',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpScreen()),
              );
            },
          ),
          _buildDrawerItem(
            Icons.logout,
            'Đăng xuất',
            onTap: () {
              _logout(context);
            },
          ),
        ],
      ),
    );
  }

  // Các mục trong Drawer
  Widget _buildDrawerItem(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
      onTap: onTap, // Gán sự kiện onTap từ bên ngoài
    );
  }

  //P1. Xây dựng phần chào mừng
  Widget _buildWelcomeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start, 
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Phần greeting
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Xin chào,\n${widget.userAccount.userName}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ),

            // Phần nút ngày tháng
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: OutlinedButton.icon(
                icon: const Icon(Icons.calendar_month),
                label: Text('${time[0]}/${time[1]}/${time[2]}'),
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),

       const Text(
          'Chúc bạn một ngày làm việc hiệu quả!',
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        SizedBox(height: 16),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Color(0xFFE9F3FF),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Cần phê duyệt',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${getApplicationsWithStatus(jobApplicationStatus.pending.name).length} hồ sơ ứng viên chờ đánh giá',
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PendingApplicationsScreen(
                                pendingApplications: getApplicationsWithStatus('pending'),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF3366FF),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text('Xem ngay'),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.article_outlined,
                  size: 60,
                  // ignore: deprecated_member_use
                  color: Color(0xFF3366FF).withOpacity(0.7),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // P2. Xây dựng thống kê
  Widget _buildStatisticsSection(Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Thống kê tuyển dụng',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {},
              child: Text('Xem tất cả', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        SizedBox(height: 8),
        GridView.count(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.0, 
          children: [
            _buildStatisticCard(
              title: 'Ứng viên',
              count: jobApplicationsList.length.toString(),
              icon: Icons.people_outline,
              iconBackgroundColor: Color(0xFFE2F1FF),
              iconColor: primaryColor,
              trendValue: '+ $trendCandidate',
              trendUp: true,
            ),
            _buildStatisticCard(
              title: 'Công việc đang tuyển',
              count: jobPostingsList.length.toString(),
              icon: Icons.work_outline,
              iconBackgroundColor: Color(0xFFFFEEE3),
              iconColor: Color(0xFFFF8A47),
              trendValue: '+ $trendJob',
              trendUp: true,
            ),
            _buildStatisticCard(
              title: 'Đã phỏng vấn',
              count: '${getApplicationsWithStatus(jobApplicationStatus.interview.name).length}',
              icon: Icons.record_voice_over_outlined,
              iconBackgroundColor: Color(0xFFE9F9E7),
              iconColor: Color(0xFF4CAF50),
              trendValue: '+ $trendInterview',
              trendUp: true,
            ),
            _buildStatisticCard(
              title: 'Được tuyển',
              count: '${getApplicationsWithStatus(jobApplicationStatus.accepted.name).length}',
              icon: Icons.check_circle_outline,
              iconBackgroundColor: Color(0xFFE8E4FF),
              iconColor: Color(0xFF7C4DFF),
              trendUp: null,
            ),
          ],
        ),
      ],
    );
  }
  
  // Item thống kê tuyển dụng
  Widget _buildStatisticCard({
    required String title,
    required String count,
    required IconData icon,
    required Color iconBackgroundColor,
    required Color iconColor,
    String trendValue = '',
    required bool? trendUp,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Keep this to ensure minimum height
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 24, color: iconColor),
                ),
                if (trendUp != null)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: trendUp ? Color(0xFFE9F9E7) : Color(0xFFFFE8E8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          trendUp ? Icons.arrow_upward : Icons.arrow_downward,
                          size: 12,
                          color:
                              trendUp ? Color(0xFF4CAF50) : Color(0xFFE53935),
                        ),
                        SizedBox(width: 2),
                        Text(
                          trendValue,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color:
                                trendUp ? Color(0xFF4CAF50) : Color(0xFFE53935),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            Flexible(
              // ignore: sized_box_for_whitespace
              child: Container(
                alignment: Alignment.center,
                height: 70, 
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      count,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2),
                    Text(
                      title,
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // P3. Xây dựng hoạt động gần đây
Widget _buildRecentActivitiesSection(BuildContext context) {
  // Lấy danh sách hoạt động gần đây từ dữ liệu thật
  final recentActivities = _getRecentActivities();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Hoạt động gần đây',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () {
              //Điều hướng đến trang xem tất cả hoạt động
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecentActivitiesScreen(activities: recentActivities),
                ),
              );
            },
            child: const Text(
              'Xem tất cả',
              style: TextStyle(color: Color(0xFF3366FF)),
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: recentActivities.length > 3 ? 3 : recentActivities.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final activity = recentActivities[index];
            return _buildActivityItem(
              activity['title'] as String,
              activity['time'] as String,
              activity['icon'] as IconData,
              activity['color'] as Color,
            );
          },
        ),
      ),
    ],
  );
}

// Lấy hoat động gần đây
List<Map<String, dynamic>> _getRecentActivities() {
  List<Map<String, dynamic>> activities = [];

  // Hoạt động từ JobApplication
  for (var application in flatJobApplicationList) {
    final jobPosting = jobPostingsList.firstWhere(
      (job) => job.idJobPost == application.idJobPost,
    );

    // Hoạt động từ JobTransaction
    for (var transaction in jobTransactionsList) {
      final package = subscriptionPackagesList.firstWhere(
        (pkg) => pkg.idPackage == transaction.idPackage,
      );

      activities.add({
        'title': 'Thanh toán gói ${package.packageName} đã được thực hiện',
        'time': _getRelativeTime(transaction.transactionDate),
        'icon': Icons.attach_money,
        'color': const Color(0xFFFFC107),
      });
    }

    activities.add({
      'title': '${_getUserNameById(application.idUser)} đã ứng tuyển vào công việc ${jobPosting.title}',
      'time': _getRelativeTime(jobPosting.createdAt),
      'icon': Icons.person_add_alt_1,
      'color': const Color(0xFF4CAF50),
    });
  }

  // Hoạt động từ JobPosting
  for (var job in jobPostingsList) {
    activities.add({
      'title': 'Công việc mới: ${job.title} đã được đăng tuyển',
      'time': _getRelativeTime(job.createdAt),
      'icon': Icons.work_outline,
      'color': const Color(0xFF3366FF),
    });
  }

  // Sắp xếp hoạt động theo thời gian gần nhất
  activities.sort((a, b) {
    final timeA = DateTime.now().subtract(Duration(days: int.tryParse(a['time'].split(' ')[0]) ?? 0));
    final timeB = DateTime.now().subtract(Duration(days: int.tryParse(b['time'].split(' ')[0]) ?? 0));
    return timeB.compareTo(timeA);
  });

  return activities;
}

// Hàm tính thời gian tương đối
String _getRelativeTime(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inMinutes < 60) {
    return '${difference.inMinutes} phút trước';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} giờ trước';
  } else if (difference.inDays > 0) {
    return '${difference.inDays} ngày trước';
  } else {
    return 'Không xác định';
  }
}

// Lấy tên user theo jobapplication
String _getUserNameById(String idUser) {
  final user = accountJobApplicationList.firstWhere(
    (account) => account.idUser == idUser);
  return user.userName;
}
  
  // Item hoạt động gần đây
  Widget _buildActivityItem(
    String title,
    String time,
    IconData icon,
    Color color,
  ) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 24, color: color),
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
      ),
      subtitle: Text(
        time,
        style: TextStyle(fontSize: 13, color: Colors.black54),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  // P4. Phỏng vấn sắp tới 
 Widget _buildUpcomingSection(BuildContext context) {

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Lịch phỏng vấn sắp tới',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 16),
      Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: upcomingInterviewSchedulesList.length,
                separatorBuilder: (context, index) => Column(
                  children: [
                    SizedBox(height: 12),
                    Divider(),
                    SizedBox(height: 12),
                  ],
                ),
                itemBuilder: (context, index) {
                  final interviewSchedule = upcomingInterviewSchedulesList[index];
                  final account = accountInterviewList[index];
                  final candidate =  candidateInterviewList?[index];
                  return _buildInterviewItem(
                    userName: account.userName,
                    position: candidate!.workPosition ?? '',
                    hour: formatHourWithAmPm(interviewSchedule.interviewDate),
                    date: getRelativeDateLabel(interviewSchedule.interviewDate),
                    avatarColor: getRandomColor(),
                  );
                },
              ),
              SizedBox(height: 40),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (contex)=> AllInterviewSchedulesScreen()));
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: Size(double.infinity, 48),
                ),
                child: Text('Xem tất cả lịch phỏng vấn'),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

  // Item lịch phỏng vấn
  Widget _buildInterviewItem({
    required String userName,
    required String position,
    required String hour,
    required String date,
    required Color avatarColor,
  }) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          // ignore: deprecated_member_use
          backgroundColor: avatarColor.withOpacity(0.2),
          child: Text(
            userName.split(' ').last,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14
            ),
          )
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 2),
              SizedBox(
                width: 150,
                child: Text(
                  position,
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              hour,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
            SizedBox(height: 2),
            Text(date, style: TextStyle(color: Colors.black54, fontSize: 13)),
          ],
        ),
      ],
    );
  }
}