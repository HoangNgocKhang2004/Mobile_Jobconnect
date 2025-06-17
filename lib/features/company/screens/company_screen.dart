import 'package:flutter/material.dart';
import 'package:job_connect/core/constant/apiconstant.dart';
import 'package:job_connect/core/models/company_model.dart';
import 'package:job_connect/core/services/api.dart';

class CompanyScreen extends StatefulWidget {
  const CompanyScreen({Key? key}) : super(key: key);

  @override
  State<CompanyScreen> createState() => CompanyScreenState();
}

class CompanyScreenState extends State<CompanyScreen> {
  final _apiService = ApiService(baseUrl: ApiConstants.baseUrl);

  final List<Company> companies = [];

  Future<void> fetchCompanies() async {
    try {
      final response = await _apiService.get(ApiConstants.companyEndpoint);
      setState(() {
        companies.clear();
        companies.addAll(response.map((e) => Company.fromJson(e)).toList());
      });
    } catch (e) {
      // Handle error
      print('Error fetching companies: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách công ty'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body:
          companies.isEmpty
              ? Center(
                child: Text(
                  'Không có công ty nào để hiển thị',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: companies.length,
                itemBuilder: (context, index) {
                  final company = companies[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        child: Text(
                          company.companyName[0].toUpperCase(),
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ),
                      title: Text(
                        company.companyName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        company.address ?? 'Không có địa chỉ',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, size: 16),
                        onPressed: () {
                          // Navigate to company details
                        },
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
