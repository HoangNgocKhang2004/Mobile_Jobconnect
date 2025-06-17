import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'create_cv_screen.dart';

class CVTemplate {
  final String id;
  final String name;
  final String imageUrl;
  final String description;
  final Map<String, dynamic> sections;

  CVTemplate({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.sections,
  });
}

class CVTemplatesScreen extends StatefulWidget {
  const CVTemplatesScreen({super.key});

  @override
  State<CVTemplatesScreen> createState() => _CVTemplatesScreenState();
}

class _CVTemplatesScreenState extends State<CVTemplatesScreen> {
  final List<CVTemplate> _templates = [
    CVTemplate(
      id: 'professional',
      name: 'Professional',
      imageUrl: 'assets/images/cv_templates/professional.png',
      description: 'Mẫu CV chuyên nghiệp, phù hợp cho các vị trí công nghệ',
      sections: {
        'personal_info': true,
        'summary': true,
        'experience': true,
        'education': true,
        'skills': true,
        'projects': true,
        'certificates': true,
        'languages': true,
      },
    ),
    CVTemplate(
      id: 'creative',
      name: 'Creative',
      imageUrl: 'assets/images/cv_templates/creative.png',
      description: 'Mẫu CV sáng tạo, phù hợp cho các vị trí thiết kế',
      sections: {
        'personal_info': true,
        'summary': true,
        'experience': true,
        'education': true,
        'skills': true,
        'projects': true,
        'portfolio': true,
        'certificates': true,
      },
    ),
    CVTemplate(
      id: 'minimal',
      name: 'Minimal',
      imageUrl: 'assets/images/cv_templates/minimal.png',
      description: 'Mẫu CV tối giản, tập trung vào nội dung',
      sections: {
        'personal_info': true,
        'summary': true,
        'experience': true,
        'education': true,
        'skills': true,
        'projects': true,
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chọn mẫu CV'), centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Chọn mẫu CV phù hợp với bạn',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: MasonryGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              padding: const EdgeInsets.all(16),
              itemCount: _templates.length,
              itemBuilder: (context, index) {
                final template = _templates[index];
                return _buildTemplateCard(template);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateCard(CVTemplate template) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _onTemplateSelected(template),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.asset(
                template.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(Icons.image_not_supported, size: 50),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    template.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    template.description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => _onTemplateSelected(template),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 40),
                    ),
                    child: const Text('Sử dụng mẫu này'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTemplateSelected(CVTemplate template) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateCVScreen(template: template),
      ),
    );
  }
}
