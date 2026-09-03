import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../controllers/manage_patients_controller.dart';
import '../../models/response/doctors/get_patient_list_response.dart';
import '../widgets/app_network_avatar.dart';
import '../widgets/common_list_app_bar.dart';
import '../widgets/app_dialog.dart';

class ManagePatientsScreen extends GetView<ManagePatientsController> {
  const ManagePatientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CommonListAppBar(
        title: 'manage_patients'.tr,
        doctorName: controller.doctorName,
        searchController: controller.searchController,
        onSearch: (val) => controller.searchPatients(),
        onRefresh: () => controller.refreshList(),
        onHome: () => Get.offAllNamed('/doctor-dashboard'),
      ),
      body: Column(
        children: [
          // Export buttons
          Visibility(
            visible: false,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildOrangeBtn(
                    'export_list'.tr,
                    () => _showContactSupportDialog(context),
                  ),
                  const SizedBox(width: 16),
                  _buildOrangeBtn(
                    'export_patient'.tr,
                    () => _showContactSupportDialog(context),
                  ),
                ],
              ),
            ),
          ),
          // Total Patient Count Text
          Obx(() {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                '${'total_patients'.tr} ${controller.totalPatientsCount.value}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.navy,
                ),
              ),
            );
          }),
          const Divider(height: 1, thickness: 1),
          // Scrollable Patient List or Loader
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.patients.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.teal),
                );
              }

              if (controller.errorMessage.value.isNotEmpty &&
                  controller.patients.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      controller.errorMessage.value,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.medicalGray,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              if (controller.patients.isEmpty) {
                return Center(
                  child: Text(
                    'no_patients_found'.tr,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.medicalGray,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }

              final displayCount =
                  controller.patients.length +
                  (controller.hasMore.value ? 1 : 0);

              return ListView.separated(
                controller: controller.scrollController,
                padding: const EdgeInsets.all(12.0),
                itemCount: displayCount,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  // Render load more spinner at the very bottom
                  if (index == controller.patients.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.teal,
                        ),
                      ),
                    );
                  }

                  final patient = controller.patients[index];
                  return _buildPatientCard(patient);
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Get.toNamed('/patient-signup');
          if (result == true) {
            controller.refreshList();
          }
        },
        backgroundColor: AppColors.error,
        shape: const CircleBorder(),
        child: SvgPicture.asset(
          'assets/icons/svg/ic_add.svg',
          colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
          width: 24,
          height: 24,
        ),
      ),
    );
  }

  Widget _buildOrangeBtn(String label, VoidCallback onTap) {
    return SizedBox(
      height: 36,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.warning,
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildPatientCard(PatientData patient) {
    final name = '${patient.firstName} ${patient.midName} ${patient.lastName}'
        .trim();

    // Hide profile picture if it contains 'default.jpg', 'default.png', is empty, or is null
    final hasProfilePic =
        patient.profilePic.isNotEmpty &&
        !patient.profilePic.contains('default.jpg') &&
        !patient.profilePic.contains('default.png');

    // Condition/disease string formatting
    final condition = patient.pastHistory.isNotEmpty
        ? patient.pastHistory
        : 'none'.tr;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.lightGray),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Left: details Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${'mhc_id'.tr} ${patient.mhcId}',
                  style: TextStyle(fontSize: 14, color: AppColors.navy),
                ),
                if (patient.mhcEmail.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    patient.mhcEmail,
                    style: TextStyle(fontSize: 14, color: AppColors.navy),
                  ),
                ],
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      'mobile_no_label'.tr,
                      style: TextStyle(fontSize: 14, color: AppColors.navy),
                    ),
                    const SizedBox(width: 4),
                    InkWell(
                      onTap: () => controller.callNumber(patient.mobileNo),
                      child: Text(
                        patient.mobileNo,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.error,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  condition,
                  style: TextStyle(fontSize: 14, color: AppColors.navy),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Right Column: Profile photo on top (if present), View Details button at the bottom
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hasProfilePic) ...[
                AppNetworkAvatar(
                  imageUrl: patient.profilePic,
                  size: 72,
                  borderRadius: 6,
                ),
                const SizedBox(height: 12),
              ],
              SizedBox(
                height: 34,
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed('/patient-dashboard', arguments: {
                      'patientId': patient.id,
                      'userName': '${patient.firstName} ${patient.lastName}',
                      'userAge': patient.age,
                      'userGender': patient.gender,
                      'type': controller.userType.value,
                      'leaderId': '',
                      'isFrom': 'doctor',
                      'doctorId': controller.doctorId.value,
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.teal,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: Text(
                    'view_details'.tr,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showContactSupportDialog(BuildContext context) {
    AppDialog.show(
      title: 'contact_support'.tr,
      confirmLabel: 'okay'.tr,
      onConfirm: () => Get.back(),
      body: Text(
        'contact_support_desc'.tr,
        style: const TextStyle(fontSize: 14, color: AppColors.navy),
      ),
    );
  }
}


