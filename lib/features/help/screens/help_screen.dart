import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Trợ giúp',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      backgroundColor: const Color(0xFFF5F7FA),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        children: [
          _buildSearchBar(context),
          const SizedBox(height: 24),
          _buildHeaderWithIcon(
            context,
            'Câu hỏi thường gặp',
            Icons.question_answer_rounded,
          ),
          const SizedBox(height: 16),
          _buildFAQSection(context),
          const SizedBox(height: 24),
          _buildHeaderWithIcon(
            context,
            'Liên hệ hỗ trợ',
            Icons.support_agent_rounded,
          ),
          const SizedBox(height: 16),
          _buildContactSection(context),
          const SizedBox(height: 32),
          _buildFeedbackButton(context),
        ],
      ),
    );
  }

  Widget _buildHeaderWithIcon(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor, size: 28),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Tìm kiếm câu hỏi thường gặp...',
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: Theme.of(context).primaryColor,
            size: 24,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        onSubmitted: (value) {},
      ),
    );
  }

  Widget _buildFAQSection(BuildContext context) {
    final List<Map<String, String>> faqItems = [
      {
        'question': 'Làm thế nào để tạo hồ sơ xin việc?',
        'answer':
            'Để tạo hồ sơ xin việc, bạn cần:\n1. Đăng nhập vào tài khoản\n2. Vào mục "Hồ sơ"\n3. Nhấn nút "Chỉnh sửa"\n4. Điền đầy đủ thông tin theo yêu cầu\n5. Nhấn "Lưu" để hoàn tất',
      },
      {
        'question': 'Làm thế nào để ứng tuyển việc?',
        'answer':
            'Để ứng tuyển việc, bạn cần:\n1. Tìm việc phù hợp trong mục "Tìm kiếm"\n2. Nhấn vào việc muốn ứng tuyển\n3. Đọc kỹ mô tả và yêu cầu công việc\n4. Nhấn nút "Ứng tuyển"\n5. Điền thông tin theo yêu cầu\n6. Nhấn "Gửi" để hoàn tất',
      },
      {
        'question': 'Làm thế nào để theo dõi trạng thái ứng tuyển?',
        'answer':
            'Để theo dõi trạng thái ứng tuyển:\n1. Vào mục "Lịch sử ứng tuyển"\n2. Tìm việc muốn theo dõi\n3. Xem trạng thái hiển thị trên thẻ việc làm\n4. Nhấn "Xem chi tiết" để xem thông tin chi tiết',
      },
      {
        'question': 'Làm thế nào để lưu việc làm?',
        'answer':
            'Để lưu việc làm:\n1. Tìm việc muốn lưu\n2. Nhấn vào biểu tượng bookmark trên thẻ việc làm\n3. Việc đã lưu sẽ được hiển thị trong mục "Việc làm đã lưu"',
      },
      {
        'question': 'Làm thế nào để hủy ứng tuyển?',
        'answer':
            'Để hủy ứng tuyển:\n1. Vào mục "Lịch sử ứng tuyển"\n2. Tìm việc muốn hủy ứng tuyển\n3. Nhấn nút "Hủy ứng tuyển"\n4. Xác nhận hủy ứng tuyển',
      },
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children:
              faqItems
                  .map(
                    (item) => _buildFAQItem(
                      context,
                      item['question']!,
                      item['answer']!,
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }

  Widget _buildFAQItem(BuildContext context, String question, String answer) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        title: Text(
          question,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        leading: CircleAvatar(
          // ignore: deprecated_member_use
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          radius: 18,
          child: Icon(
            Icons.help_outline_rounded,
            color: Theme.of(context).primaryColor,
            size: 22,
          ),
        ),
        childrenPadding: const EdgeInsets.only(left: 60, right: 16, bottom: 16),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            answer,
            style: TextStyle(
              color: Colors.grey[700],
              height: 1.6,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildContactCard(
              context: context,
              icon: Icons.email_rounded,
              title: 'Email',
              subtitle: 'support@jobconnect.com',
              color: Colors.blue,
              onTap: () {},
            ),
            _buildDivider(),
            _buildContactCard(
              context: context,
              icon: Icons.phone_rounded,
              title: 'Điện thoại',
              subtitle: '1900 1234',
              color: Colors.green,
              onTap: () {},
            ),
            _buildDivider(),
            _buildContactCard(
              context: context,
              icon: Icons.chat_rounded,
              title: 'Chat trực tuyến',
              subtitle: 'Hỗ trợ 24/7',
              color: Colors.orange,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, thickness: 1, indent: 70, endIndent: 16);
  }

  Widget _buildContactCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(child: Icon(icon, color: color, size: 24)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey[400],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.rate_review_rounded),
        label: const Text(
          'Gửi phản hồi của bạn',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
    );
  }
}
