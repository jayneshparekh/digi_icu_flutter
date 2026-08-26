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
        statusBarColor: AppColors.teal,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Drawer(
        backgroundColor: AppColors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Teal status bar area using SafeArea padding — works across all Android versions and orientations
            Container(
              color: AppColors.teal,
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
                            color: AppColors.success,
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
                      Expanded(
                        child: Text(
                          'digi_icu'.tr,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColors.navy,
                          ),
                        ),
                      ),
                      // Right: Settings SVG
                      IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset(
                          'assets/icons/svg/ic_settings.svg',
                          colorFilter: const ColorFilter.mode(
                            AppColors.coolGray,
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
                              AppColors.navy,
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
                    'copyright_text'.tr,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.medicalGray,
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
                  _buildMenuItem('menu_patient_list'.tr, () {
                    _handleMenuNavigation('/patient-list');
                  }),
                  _buildMenuItem('menu_full_screening'.tr, () {
                    _handlePlaceholderAction();
                  }),
                  _buildMenuItem('menu_short_screening'.tr, () {
                    _handlePlaceholderAction();
                  }),
                  _buildMenuItem('menu_manage_patients'.tr, () {
                    _handleMenuNavigation('/manage-patients');
                  }),
                  _buildMenuItem('menu_add_templates'.tr, () {
                    _handlePlaceholderAction();
                  }),
                  _buildMenuItem('menu_my_defaults'.tr, () {
                    _handlePlaceholderAction();
                  }),
                  _buildMenuItem('menu_add_slots'.tr, () {
                    _handlePlaceholderAction();
                  }),
                  _buildMenuItem('menu_add_phe'.tr, () {
                    _handlePlaceholderAction();
                  }),
                  _buildMenuItem('menu_universal_patient_access'.tr, () {
                    _handlePlaceholderAction();
                  }),
                  _buildMenuItem('menu_about_app'.tr, () {
                    _handlePlaceholderAction();
                  }),
                  _buildMenuItem('menu_home_visit'.tr, () {
                    _handlePlaceholderAction();
                  }),
                  _buildMenuItem('menu_mh_clinic_tele_ecg'.tr, () {
                    _handlePlaceholderAction();
                  }),
                  _buildMenuItem('menu_my_ipd_pt'.tr, () {
                    _handlePlaceholderAction();
                  }),
                  _buildMenuItem('menu_logout'.tr, () {
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
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        title: Text(
          'warning_title'.tr,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.navy,
          ),
        ),
        content: Text(
          'registration_pending'.tr,
          style: TextStyle(fontSize: 14, color: AppColors.navy),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              'okay'.tr,
              style: TextStyle(
                color: AppColors.teal,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              'cancel'.tr,
              style: TextStyle(color: AppColors.medicalGray, fontWeight: FontWeight.bold),
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
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.navy,
              ),
            ),
          ),
        ),
        const Divider(height: 1, thickness: 1, color: AppColors.medicalGray),
      ],
    );
  }
}


