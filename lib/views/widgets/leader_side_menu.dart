import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../controllers/leader_dashboard_controller.dart';
import '../../core/theme/app_colors.dart';
import 'app_dialog.dart';

class LeaderSideMenu extends GetView<LeaderDashboardController> {
  const LeaderSideMenu({super.key});

  @override
  Widget build(BuildContext context) {
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
            // Top status bar padding
            Container(
              color: AppColors.teal,
              child: const SafeArea(
                bottom: false,
                child: SizedBox(width: double.infinity),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.medicalGray,
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
                  Expanded(
                    child: Text(
                      'app_name'.tr,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.lightGray),
            // Menu items list
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                children: [
                  // 1. Manage Patients (Connected)
                  _buildMenuItem(
                    iconPath: 'assets/icons/svg/ic_person_add.svg',
                    title: 'menu_manage_patients'.tr,
                    onTap: () {
                      Get.back();
                      controller.openManagePatients();
                    },
                  ),
                  // 2. Patient List (Connected)
                  _buildMenuItem(
                    iconPath: 'assets/icons/svg/ic_patient_list.svg',
                    title: 'menu_patient_list'.tr,
                    onTap: () {
                      Get.back();
                    },
                  ),
                  // 3. Short Screening
                  _buildMenuItem(
                    iconPath: 'assets/icons/svg/ic_screening.svg',
                    title: 'menu_short_screening'.tr,
                    onTap: () {
                      Get.back();
                    },
                  ),
                  // 4. Full Screening
                  _buildMenuItem(
                    iconPath: 'assets/icons/svg/ic_screening.svg',
                    title: 'menu_full_screening'.tr,
                    onTap: () {
                      Get.back();
                    },
                  ),
                  // 5. My Leaves
                  _buildMenuItem(
                    iconPath: 'assets/icons/svg/ic_screening.svg',
                    title: 'menu_my_leaves'.tr,
                    onTap: () {
                      Get.back();
                    },
                  ),
                  // 6. My Doctors
                  _buildMenuItem(
                    iconPath: 'assets/icons/svg/ic_specialist.svg',
                    title: 'menu_my_doctors'.tr,
                    onTap: () {
                      Get.back();
                    },
                  ),
                  // 7. Chat
                  _buildMenuItem(
                    iconPath: 'assets/icons/svg/ic_incoming_call.svg',
                    title: 'menu_chat'.tr,
                    onTap: () {
                      Get.back();
                    },
                  ),
                  // 8. Medicine Request
                  _buildMenuItem(
                    iconPath: 'assets/icons/svg/ic_prescription.svg',
                    title: 'menu_medicine_request'.tr,
                    onTap: () {
                      Get.back();
                    },
                  ),
                  // 9. Online Pharmacy
                  _buildMenuItem(
                    iconPath: 'assets/icons/svg/ic_online_pharmacy.svg',
                    title: 'online_pharmacy'.tr,
                    onTap: () {
                      Get.back();
                    },
                  ),
                  // 10. Blood test at Home
                  _buildMenuItem(
                    iconPath: 'assets/icons/svg/ic_online_pharmacy.svg',
                    title: 'menu_blood_test_at_home'.tr,
                    onTap: () {
                      Get.back();
                    },
                  ),
                  // 11. Info & Education
                  _buildMenuItem(
                    iconPath: 'assets/icons/svg/ic_info_education.svg',
                    title: 'info_education'.tr,
                    onTap: () {
                      Get.back();
                    },
                  ),
                  // 12. Forms
                  _buildMenuItem(
                    iconPath: 'assets/icons/svg/ic_my_forms.svg',
                    title: 'my_forms'.tr,
                    onTap: () {
                      Get.back();
                    },
                  ),
                  // 13. MH Clinic - Tele ECG
                  _buildMenuItem(
                    iconPath: 'assets/icons/svg/ic_health_monitor.svg',
                    title: 'menu_mh_clinic_tele_ecg'.tr,
                    onTap: () {
                      Get.back();
                    },
                  ),
                  // 14. IPD Admission (Connected to IPD Patient list)
                  _buildMenuItem(
                    iconPath: 'assets/icons/svg/ic_ipd_patient.svg',
                    title: 'menu_ipd_admit'.tr,
                    onTap: () {
                      Get.back();
                      controller.openIpdPatients();
                    },
                  ),
                  // 15. My Package (Connected)
                  _buildMenuItem(
                    iconPath: 'assets/icons/svg/ic_reports.svg',
                    title: 'my_package'.tr,
                    onTap: () {
                      Get.back();
                    },
                  ),
                  const Divider(height: 1, color: AppColors.lightGray),
                  // 16. Logout (Connected)
                  ListTile(
                    dense: true,
                    leading: const Icon(
                      Icons.power_settings_new,
                      color: AppColors.error,
                      size: 24,
                    ),
                    title: Text(
                      'menu_logout'.tr,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.error,
                      ),
                    ),
                    onTap: () {
                      Get.back();
                      _showLogoutConfirmDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required String iconPath,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      dense: true,
      leading: SvgPicture.asset(
        iconPath,
        width: 22,
        height: 22,
        colorFilter: const ColorFilter.mode(
          AppColors.teal,
          BlendMode.srcIn,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppColors.navy,
        ),
      ),
      onTap: onTap,
    );
  }

  void _showLogoutConfirmDialog(BuildContext context) {
    AppDialog.show(
      title: 'logout'.tr,
      confirmLabel: 'logout'.tr,
      cancelLabel: 'cancel'.tr,
      onConfirm: () {
        controller.logout();
      },
      body: Text(
        'are_you_sure_logout'.tr,
        style: const TextStyle(fontSize: 14, color: AppColors.navy),
      ),
    );
  }
}
