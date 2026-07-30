import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../controllers/doctor_dashboard_controller.dart';

class DoctorSideMenu extends GetView<DoctorDashboardController> {
  const DoctorSideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    // Force standard overlays to prevent side menu from going fullscreen/hiding status bars
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Teal status bar area using SafeArea padding — works across all Android versions and orientations
            Container(
              color: AppColors.primary,
              child: SafeArea(
                bottom: false,
                child: const SizedBox(width: double.infinity),
              ),
            ),
            // Side Menu Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Left: circular Digi Icu logo
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.green.shade600,
                            width: 1,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/digi_icu_logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Center: Digi ICU title
                      const Expanded(
                        child: Text(
                          'Digi ICU',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      // Right: Settings SVG
                      IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset(
                          'assets/icons/svg/ic_settings.svg',
                          colorFilter: const ColorFilter.mode(
                            AppColors.greyDark,
                            BlendMode.srcIn,
                          ),
                          width: 24,
                          height: 24,
                        ),
                      ),
                      // Right: Orientation Toggle SVG
                      Obx(() {
                        final isPortrait =
                            controller.selectedOrientation.value == 'portrait';
                        final iconPath = isPortrait
                            ? 'assets/icons/svg/ic_mobile_landscape.svg'
                            : 'assets/icons/svg/ic_mobile_portrait.svg';

                        return IconButton(
                          onPressed: controller.toggleOrientation,
                          icon: SvgPicture.asset(
                            iconPath,
                            colorFilter: const ColorFilter.mode(
                              Colors.black87,
                              BlendMode.srcIn,
                            ),
                            width: 24,
                            height: 24,
                          ),
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Footer copyright notice inside header
                  Text(
                    '@ Medqul HealthTech Pvt Ltd, Mumbai, India',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1),
            // Side menu body — use SafeArea at bottom to respect navigation bar on all devices
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom,
                ),
                children: [
                  _buildMenuItem('Patient List', () {
                    _handleMenuNavigation('/patient-list');
                  }),
                  _buildMenuItem('Full Screening', () {
                    _handlePlaceholderAction();
                  }),
                  _buildMenuItem('Short Screening', () {
                    _handlePlaceholderAction();
                  }),
                  _buildMenuItem('Manage Patients', () {
                    _handleMenuNavigation('/manage-patients');
                  }),
                  _buildMenuItem('Add Templates', () {
                    _handlePlaceholderAction();
                  }),
                  _buildMenuItem('My Defaults', () {
                    _handlePlaceholderAction();
                  }),
                  _buildMenuItem('Add Slots', () {
                    _handlePlaceholderAction();
                  }),
                  _buildMenuItem('Add PHE', () {
                    _handlePlaceholderAction();
                  }),
                  _buildMenuItem('Universal Patient Access', () {
                    _handlePlaceholderAction();
                  }),
                  _buildMenuItem('About app', () {
                    _handlePlaceholderAction();
                  }),
                  _buildMenuItem('Home visit', () {
                    _handlePlaceholderAction();
                  }),
                  _buildMenuItem('MH Clinic - Tele ECG', () {
                    _handlePlaceholderAction();
                  }),
                  _buildMenuItem('My IPD pt', () {
                    _handlePlaceholderAction();
                  }),
                  _buildMenuItem('Logout', () {
                    Get.back();
                    controller.logout();
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleMenuNavigation(String routeName) {
    Get.back();
    if (controller.accountStatus.value == '2') {
      _showPendingRegistrationDialog();
    } else {
      Get.toNamed(routeName);
    }
  }

  void _handlePlaceholderAction() {
    Get.back();
    if (controller.accountStatus.value == '2') {
      _showPendingRegistrationDialog();
    }
  }

  void _showPendingRegistrationDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: const Text(
          'Warning!!',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        content: const Text(
          'Your registration formalities are pending, please complete first.',
          style: TextStyle(fontSize: 14, color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text(
              'Okay',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Widget _buildMenuItem(String title, VoidCallback onTap) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
          ),
        ),
        const Divider(height: 1, thickness: 1, color: AppColors.divider),
      ],
    );
  }
}


