import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../controllers/doctor_dashboard_controller.dart';

class DoctorDashboardScreen extends GetView<DoctorDashboardController> {
  const DoctorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Check and trigger orientation layout dialog after the screen is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final shortestSide = MediaQuery.of(context).size.shortestSide;
      final isConfigured = await controller.checkAndApplyOrientation(shortestSide);
      if (!isConfigured) {
        _showLayoutDialog(context);
      }
    });

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: const Color(0xFF00897B), // Teal background matching design
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            // Drawer toggle placeholder
          },
        ),
        title: Obx(() {
          return Text(
            controller.doctorName.value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          );
        }),
        actions: [
          // QR Code Icon
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SvgPicture.asset(
                'assets/icons/svg/qr_code_scan.svg',
                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                width: 24,
                height: 24,
              ),
            ),
          ),
          // Circular Logo Image
          Center(
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/mhc_round.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // 3-dot Popup Menu
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == 'logout') {
                controller.logout();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'wallet',
                  child: Text('My Wallet'),
                ),
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Text('Logout'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            // Patient List Card
            InkWell(
              onTap: () {
                Get.toNamed('/patient-list');
              },
              borderRadius: BorderRadius.circular(12),
              child: Card(
                color: Colors.white,
                elevation: 1,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 6.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/svg/ic_patient_list.svg',
                        width: 36,
                        height: 36,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF00897B),
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Patient List',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLayoutDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24),
        actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        title: const Text(
          'Select Layout',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This is the recommended layout but you can change it if you want.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            Obx(() {
              return Column(
                children: [
                  RadioListTile<String>(
                    value: 'portrait',
                    groupValue: controller.selectedOrientation.value,
                    onChanged: (val) {
                      if (val != null) controller.selectedOrientation.value = val;
                    },
                    title: const Text(
                      'Portrait (Vertical)',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    activeColor: const Color(0xFF00B0FF),
                    contentPadding: EdgeInsets.zero,
                  ),
                  RadioListTile<String>(
                    value: 'landscape',
                    groupValue: controller.selectedOrientation.value,
                    onChanged: (val) {
                      if (val != null) controller.selectedOrientation.value = val;
                    },
                    title: const Text(
                      'Landscape (Horizontal)',
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    activeColor: const Color(0xFF00B0FF),
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 16),
                  CheckboxListTile(
                    value: controller.setAsDefault.value,
                    onChanged: (val) {
                      if (val != null) controller.setAsDefault.value = val;
                    },
                    title: const Text(
                      'Set this orientation as default.',
                      style: TextStyle(fontSize: 15, color: Colors.black87),
                    ),
                    activeColor: const Color(0xFF00B0FF),
                    checkColor: Colors.white,
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              );
            }),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.saveAndApplySelectedOrientation();
              Get.back();
            },
            child: const Text(
              'APPLY',
              style: TextStyle(
                color: Color(0xFF00897B),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
