import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class NearbyJobsMapScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const NearbyJobsMapScreen({Key? key}) : super(key: key);

  @override
  State<NearbyJobsMapScreen> createState() => _NearbyJobsMapScreenState();
}

class _NearbyJobsMapScreenState extends State<NearbyJobsMapScreen> {
  GoogleMapController? mapController;
  final Set<Marker> _markers = {};
  bool _showJobList = false;
  bool _isLoading = true;
  String? _errorMessage;

  // Vị trí mặc định (có thể thay đổi thành vị trí hiện tại của người dùng)
  final LatLng _center = const LatLng(10.762622, 106.660172); // TPHCM

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    try {
      // Kiểm tra trạng thái quyền hiện tại
      var status = await Permission.location.status;

      if (status.isGranted) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Yêu cầu quyền truy cập
      status = await Permission.location.request();

      if (status.isGranted) {
        setState(() {
          _isLoading = false;
        });
      } else if (status.isPermanentlyDenied) {
        setState(() {
          _errorMessage =
              'Vui lòng cấp quyền truy cập vị trí trong cài đặt để sử dụng tính năng này';
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage =
              'Vui lòng cấp quyền truy cập vị trí để sử dụng tính năng này';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Có lỗi xảy ra khi kiểm tra quyền truy cập vị trí';
        _isLoading = false;
      });
      //print('Lỗi khi kiểm tra quyền truy cập vị trí: $e');
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('job_1'),
          position: const LatLng(10.762922, 106.662172),
          infoWindow: const InfoWindow(
            title: 'Flutter Developer',
            snippet: 'Công ty ABC - 12-15 triệu',
          ),
        ),
      );
      _markers.add(
        Marker(
          markerId: const MarkerId('job_2'),
          position: const LatLng(10.763622, 106.658172),
          infoWindow: const InfoWindow(
            title: 'React Native Developer',
            snippet: 'Công ty XYZ - 15-20 triệu',
          ),
        ),
      );
      _markers.add(
        Marker(
          markerId: const MarkerId('job_3'),
          position: const LatLng(10.760622, 106.661172),
          infoWindow: const InfoWindow(
            title: 'UI/UX Designer',
            snippet: 'Công ty DEF - 10-15 triệu',
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Việc làm gần bạn'),
          backgroundColor: const Color(0xFF1E88E5),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _checkLocationPermission,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E88E5),
                  ),
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // Bản đồ
          Builder(
            builder: (context) {
              try {
                return GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 15.0,
                  ),
                  markers: _markers,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  mapType: MapType.normal,
                  zoomControlsEnabled: false,
                  compassEnabled: false,
                  rotateGesturesEnabled: false,
                  scrollGesturesEnabled: true,
                  tiltGesturesEnabled: false,
                );
              } catch (e) {
                //print('Lỗi khi khởi tạo Google Maps: $e');
                return Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: Text('Không thể tải bản đồ. Vui lòng thử lại sau.'),
                  ),
                );
              }
            },
          ),

          // Header với nút back và tiêu đề
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              // ignore: deprecated_member_use
              color: Colors.white.withOpacity(0.9),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF1E88E5),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    "Việc làm gần bạn",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _showJobList = !_showJobList;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        _showJobList ? Icons.map : Icons.list,
                        color: const Color(0xFF1E88E5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Danh sách công việc
          if (_showJobList)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 50,
                      height: 5,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: 10,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          return JobCard(index: index);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Nút tìm kiếm
          Positioned(
            bottom:
                _showJobList
                    ? MediaQuery.of(context).size.height * 0.5 + 16
                    : 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                // Hiển thị bộ lọc
              },
              backgroundColor: const Color(0xFF1E88E5),
              child: const Icon(Icons.filter_list, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class JobCard extends StatelessWidget {
  final int index;

  // ignore: use_super_parameters
  const JobCard({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> titles = [
      'Flutter Developer',
      'React Native Developer',
      'UI/UX Designer',
      'Frontend Developer',
      'Mobile Developer',
      'Backend Developer',
      'Project Manager',
      'Product Owner',
      'QA Engineer',
      'DevOps Engineer',
    ];

    final List<String> companies = [
      'Công ty ABC',
      'Công ty XYZ',
      'Công ty DEF',
      'Startup GHI',
      'Công ty JKL',
      'Tập đoàn MNO',
      'Công ty PQR',
      'Công ty STU',
      'Tập đoàn VWX',
      'Công ty YZ',
    ];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: Color((index * 0x1234567) & 0xFFFFFF).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                companies[index % companies.length][0],
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color((index * 0x1234567) & 0xFFFFFF),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titles[index % titles.length],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  companies[index % companies.length],
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: const Color(0xFF1E88E5).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '${12 + (3 * 0.5)}-${15 + (5 * 0.5)} triệu',
                        style: TextStyle(
                          color: Color(0xFF1E88E5),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${0.5 + index * 0.3} km',
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.bookmark_border, color: Colors.grey),
        ],
      ),
    );
  }
}

// Nút khám phá việc làm gần bạn
class ExploreNearbyJobsButton extends StatelessWidget {
  // ignore: use_super_parameters
  const ExploreNearbyJobsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NearbyJobsMapScreen(),
              ),
            );
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1E88E5), Color(0xFF42A5F5)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: const Color(0xFF1E88E5).withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_on, color: Colors.white, size: 24),
                SizedBox(width: 8),
                Text(
                  "Khám phá việc làm gần bạn",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 25),
      ],
    );
  }
}
