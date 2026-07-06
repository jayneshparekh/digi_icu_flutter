import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/doctor_dashboard_controller.dart';
import '../widgets/qr_code_vector_icon.dart';

class DoctorDashboardScreen extends GetView<DoctorDashboardController> {
  const DoctorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: QrCodeVectorIcon(
                color: Colors.white,
                size: 24,
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
      body: Center(
        child: Obx(() {
          return Text(
            'Welcome to Digi ICU\n${controller.doctorName.value}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          );
        }),
      ),
    );
  }
}
