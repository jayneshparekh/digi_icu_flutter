import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import 'app_dialog.dart';

class PatientSideMenu extends StatelessWidget {
  final VoidCallback onLogout;
  final VoidCallback? onDashboardTap;
  final VoidCallback? onAppointmentTap;
  final VoidCallback? onPrescriptionTap;
  final VoidCallback? onChestPainTap;
  final VoidCallback? onQuickFormTap;
  final VoidCallback? onMyGraphsTap;
  final VoidCallback? onMyFormsTap;
  final VoidCallback? onMyPackageTap;

  const PatientSideMenu({
    super.key,
    required this.onLogout,
    this.onDashboardTap,
    this.onAppointmentTap,
    this.onPrescriptionTap,
    this.onChestPainTap,
    this.onQuickFormTap,
    this.onMyGraphsTap,
    this.onMyFormsTap,
    this.onMyPackageTap,
  });

  @override
  Widget build(BuildContext context) {
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
            // Menu Items List (Matching patient_nav_menu.xml in MHC-Android)
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                children: [
                  // 1. My Dashboard
                  _buildMenuItem(
                    icon: 'assets/icons/svg/ic_dashboard.svg',
                    title: 'my_dashboard'.tr,
                    onTap: () {
                      Get.back();
                      onDashboardTap?.call();
                    },
                  ),
                  // 2. Online Pharmacy
                  _buildMenuItem(
                    icon: 'assets/icons/svg/ic_online_pharmacy.svg',
                    title: 'online_pharmacy'.tr,
                    onTap: () => Get.back(),
                  ),
                  // 3. Appointment
                  _buildMenuItem(
                    icon: 'assets/icons/svg/ic_doctor_appointment.svg',
                    title: 'doctor_appointment'.tr,
                    onTap: () {
                      Get.back();
                      onAppointmentTap?.call();
                    },
                  ),
                  // 4. Prescription
                  _buildMenuItem(
                    icon: 'assets/icons/svg/ic_prescription.svg',
                    title: 'prescription'.tr,
                    onTap: () {
                      Get.back();
                      onPrescriptionTap?.call();
                    },
                  ),
                  // 5. Home Services
                  _buildMenuItem(
                    icon: 'assets/icons/svg/ic_orders_status.svg',
                    title: 'home_services'.tr,
                    onTap: () => Get.back(),
                  ),
                  // 6. Quick Form
                  _buildMenuItem(
                    icon: 'assets/icons/svg/ic_quick.svg',
                    title: 'quick_form'.tr,
                    onTap: () {
                      Get.back();
                      onQuickFormTap?.call();
                    },
                  ),
                  // 7. My Package
                  _buildMenuItem(
                    icon: 'assets/icons/svg/ic_my_package.svg',
                    title: 'my_package'.tr,
                    onTap: () {
                      Get.back();
                      onMyPackageTap?.call();
                    },
                  ),
                  // 8. Chest Pain Help
                  _buildMenuItem(
                    icon: 'assets/icons/svg/ic_chest_pain_help.svg',
                    iconColor: AppColors.error,
                    title: 'chest_pain_help'.tr,
                    onTap: () {
                      Get.back();
                      onChestPainTap?.call();
                    },
                  ),
                  // 9. My Reports
                  _buildMenuItem(
                    icon: 'assets/icons/svg/ic_medical_report.svg',
                    title: 'my_reports'.tr,
                    onTap: () => Get.back(),
                  ),
                  // 10. My Graphs
                  _buildMenuItem(
                    icon: 'assets/icons/svg/ic_graphs.svg',
                    title: 'my_graphs'.tr,
                    onTap: () {
                      Get.back();
                      onMyGraphsTap?.call();
                    },
                  ),
                  // 11. Info & Education
                  _buildMenuItem(
                    icon: 'assets/icons/svg/ic_info_education.svg',
                    title: 'info_education'.tr,
                    onTap: () => Get.back(),
                  ),
                  // 12. My Forms
                  _buildMenuItem(
                    icon: 'assets/icons/svg/ic_my_forms.svg',
                    title: 'my_forms'.tr,
                    onTap: () {
                      Get.back();
                      onMyFormsTap?.call();
                    },
                  ),
                  // 13. Emergency
                  _buildMenuItem(
                    icon: 'assets/icons/svg/ic_emergency_call_red.svg',
                    iconColor: AppColors.error,
                    title: 'emergency'.tr,
                    onTap: () => Get.back(),
                  ),
                  // 14. Order Status
                  _buildMenuItem(
                    icon: 'assets/icons/svg/ic_orders_status.svg',
                    title: 'orders_status'.tr,
                    onTap: () => Get.back(),
                  ),
                  // 15. Collaborated Hospitals
                  _buildMenuItem(
                    icon: 'assets/icons/svg/ic_hospital_building.svg',
                    title: 'collaborated_hospitals'.tr,
                    onTap: () => Get.back(),
                  ),
                  // 16. Screening
                  _buildMenuItem(
                    icon: 'assets/icons/svg/ic_screening.svg',
                    title: 'screening'.tr,
                    onTap: () => Get.back(),
                  ),
                  // 17. Health Monitor
                  _buildMenuItem(
                    icon: 'assets/icons/svg/ic_health_monitor.svg',
                    title: 'health_monitor'.tr,
                    onTap: () => Get.back(),
                  ),
                  // 18. Consult Specialist
                  _buildMenuItem(
                    icon: 'assets/icons/svg/ic_specialist.svg',
                    title: 'consult_specialist'.tr,
                    onTap: () => Get.back(),
                  ),
                  // 19. Family Member
                  _buildMenuItem(
                    icon: 'assets/icons/svg/ic_patient_list.svg',
                    title: 'family_member'.tr,
                    onTap: () => Get.back(),
                  ),
                  const Divider(color: AppColors.lightGray),
                  // 20. Logout
                  _buildMenuItem(
                    icon: null,
                    iconData: Icons.logout,
                    title: 'logout'.tr,
                    textColor: AppColors.error,
                    iconColor: AppColors.error,
                    onTap: () {
                      Get.back();
                      _showLogoutDialog(context);
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
    String? icon,
    IconData? iconData,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    Widget leadingWidget;
    if (icon != null) {
      leadingWidget = SvgPicture.asset(
        icon,
        width: 22,
        height: 22,
        colorFilter: ColorFilter.mode(
          iconColor ?? AppColors.coolGray,
          BlendMode.srcIn,
        ),
      );
    } else {
      leadingWidget = Icon(
        iconData ?? Icons.circle,
        size: 22,
        color: iconColor ?? AppColors.coolGray,
      );
    }

    return ListTile(
      dense: true,
      visualDensity: const VisualDensity(horizontal: 0, vertical: -1),
      leading: SizedBox(
        width: 28,
        height: 28,
        child: Center(child: leadingWidget),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textColor ?? AppColors.pureBlack,
        ),
      ),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    AppDialog.show(
      title: 'logout'.tr,
      body: Text(
        'are_you_sure_logout'.tr,
        style: const TextStyle(
          fontSize: 15,
          color: AppColors.pureBlack,
        ),
      ),
      confirmLabel: 'logout'.tr,
      cancelLabel: 'cancel'.tr,
      onConfirm: () {
        Get.back();
        onLogout();
      },
      onCancel: () => Get.back(),
    );
  }
}
