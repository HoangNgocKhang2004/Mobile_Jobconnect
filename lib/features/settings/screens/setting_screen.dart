// import 'package:flutter/material.dart';

// class SettingScreen extends StatefulWidget {
//   const SettingScreen({super.key});

//   @override
//   State<SettingScreen> createState() => _SettingScreenState();
// }

// class _SettingScreenState extends State<SettingScreen> {
//   bool _notificationsEnabled = true;
//   bool _darkModeEnabled = false;
//   String _language = 'Tiếng Việt';
//   bool _emailNotifications = true;
//   bool _pushNotifications = true;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Cài đặt'), centerTitle: true),
//       body: ListView(
//         children: [
//           _buildSection('Thông báo', [
//             SwitchListTile(
//               title: const Text('Bật thông báo'),
//               subtitle: const Text('Nhận thông báo về công việc và cập nhật'),
//               value: _notificationsEnabled,
//               onChanged: (bool value) {
//                 setState(() {
//                   _notificationsEnabled = value;
//                 });
//               },
//             ),
//             if (_notificationsEnabled) ...[
//               SwitchListTile(
//                 title: const Text('Thông báo qua email'),
//                 subtitle: const Text('Nhận thông báo qua email'),
//                 value: _emailNotifications,
//                 onChanged: (bool value) {
//                   setState(() {
//                     _emailNotifications = value;
//                   });
//                 },
//               ),
//               SwitchListTile(
//                 title: const Text('Thông báo đẩy'),
//                 subtitle: const Text('Nhận thông báo trên thiết bị'),
//                 value: _pushNotifications,
//                 onChanged: (bool value) {
//                   setState(() {
//                     _pushNotifications = value;
//                   });
//                 },
//               ),
//             ],
//           ]),
//           _buildSection('Giao diện', [
//             SwitchListTile(
//               title: const Text('Chế độ tối'),
//               subtitle: const Text('Bật/tắt giao diện tối'),
//               value: _darkModeEnabled,
//               onChanged: (bool value) {
//                 setState(() {
//                   _darkModeEnabled = value;
//                 });
//               },
//             ),
//             ListTile(
//               title: const Text('Ngôn ngữ'),
//               subtitle: Text(_language),
//               trailing: const Icon(Icons.arrow_forward_ios),
//               onTap: () {
//                 _showLanguageDialog();
//               },
//             ),
//           ]),
//           _buildSection('Tài khoản', [
//             ListTile(
//               title: const Text('Đổi mật khẩu'),
//               leading: const Icon(Icons.lock_outline),
//               trailing: const Icon(Icons.arrow_forward_ios),
//               onTap: () {},
//             ),
//             ListTile(
//               title: const Text('Xóa tài khoản'),
//               leading: const Icon(Icons.delete_outline, color: Colors.red),
//               trailing: const Icon(Icons.arrow_forward_ios),
//               onTap: () {
//                 _showDeleteAccountDialog();
//               },
//             ),
//           ]),
//           _buildSection('Thông tin', [
//             ListTile(
//               title: const Text('Phiên bản ứng dụng'),
//               subtitle: const Text('1.0.0'),
//             ),
//             ListTile(
//               title: const Text('Điều khoản sử dụng'),
//               trailing: const Icon(Icons.arrow_forward_ios),
//               onTap: () {},
//             ),
//             ListTile(
//               title: const Text('Chính sách bảo mật'),
//               trailing: const Icon(Icons.arrow_forward_ios),
//               onTap: () {},
//             ),
//           ]),
//         ],
//       ),
//     );
//   }

//   Widget _buildSection(String title, List<Widget> children) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
//           child: Text(
//             title,
//             style: const TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey,
//             ),
//           ),
//         ),
//         ...children,
//         const Divider(),
//       ],
//     );
//   }

//   void _showLanguageDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Chọn ngôn ngữ'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 title: const Text('Tiếng Việt'),
//                 onTap: () {
//                   setState(() {
//                     _language = 'Tiếng Việt';
//                   });
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 title: const Text('English'),
//                 onTap: () {
//                   setState(() {
//                     _language = 'English';
//                   });
//                   Navigator.pop(context);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _showDeleteAccountDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Xóa tài khoản'),
//           content: const Text(
//             'Bạn có chắc chắn muốn xóa tài khoản? Hành động này không thể hoàn tác.',
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text('Hủy'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text('Xóa', style: TextStyle(color: Colors.red)),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
