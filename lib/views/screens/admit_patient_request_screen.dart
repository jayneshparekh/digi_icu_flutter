import 'package:digi_icu_flutter/controllers/admit_patient_request_controller.dart';
import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/models/response/patient/admit_request_response.dart';
import 'package:digi_icu_flutter/views/widgets/app_primary_button.dart';
import 'package:digi_icu_flutter/views/widgets/app_status_badge.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AdmitPatientRequestScreen extends GetView<AdmitPatientRequestController> {
  const AdmitPatientRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        backgroundColor: AppColors.teal,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'admit_requests'.tr,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // Filter & Search bar header
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                // Search row with Reload button
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller.searchController,
                        decoration: InputDecoration(
                          hintText: 'search_patients_hint'.tr,
                          hintStyle: const TextStyle(color: AppColors.medicalGray, fontSize: 14),
                          prefixIcon: const Icon(Icons.search, color: AppColors.medicalGray),
                          filled: true,
                          fillColor: AppColors.lightGray,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.teal,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.refresh, color: AppColors.white),
                        tooltip: 'reload'.tr,
                        onPressed: () {
                          controller.searchController.clear();
                          controller.loadAdmitRequests();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Status Segment Buttons: 'Admit Requested' vs 'Admitted'
                Obx(() {
                  final isRequested = controller.currentStatus.value == 'Admit Requested';
                  return Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: isRequested ? AppColors.warning : AppColors.white,
                            side: BorderSide(
                              color: isRequested ? AppColors.warning : AppColors.teal,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () => controller.switchTab('Admit Requested'),
                          child: Text(
                            'admit_requested'.tr,
                            style: TextStyle(
                              color: isRequested ? AppColors.white : AppColors.teal,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: !isRequested ? AppColors.warning : AppColors.white,
                            side: BorderSide(
                              color: !isRequested ? AppColors.warning : AppColors.teal,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () => controller.switchTab('Admitted'),
                          child: Text(
                            'admitted'.tr,
                            style: TextStyle(
                              color: !isRequested ? AppColors.white : AppColors.teal,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),

          // Patients List view
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.teal),
                );
              }

              if (controller.filteredPatients.isEmpty) {
                return Center(
                  child: Text(
                    'no_admit_requests_found'.tr,
                    style: const TextStyle(fontSize: 15, color: AppColors.medicalGray),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.loadAdmitRequests,
                color: AppColors.teal,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  itemCount: controller.filteredPatients.length,
                  itemBuilder: (context, index) {
                    final patient = controller.filteredPatients[index];
                    return _buildPatientCard(context, patient);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientCard(BuildContext context, AdmitRequestPatientItem patient) {
    final displayGender = patient.gender == 'Male'
        ? 'M'
        : patient.gender == 'Female'
            ? 'F'
            : (patient.gender ?? 'O');

    final isAdmitted = patient.requestStatus == '1';

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Patient Name, Age, Gender & Status Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    '${patient.patientName ?? ''} ${patient.age ?? ''}/$displayGender',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy,
                    ),
                  ),
                ),
                AppStatusBadge(
                  label: isAdmitted ? 'admitted'.tr : 'admit_requested'.tr,
                  color: isAdmitted ? AppColors.teal : AppColors.warning,
                ),
              ],
            ),
            const SizedBox(height: 8),

            // MHC ID & Patient Mobile
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${'mhc_id'.tr} ${patient.mhcId ?? '-'}',
                    style: const TextStyle(fontSize: 13, color: AppColors.medicalGray),
                  ),
                ),
                InkWell(
                  onTap: () {
                    final mob = patient.mobileNo ?? '';
                    if (mob.isNotEmpty) {
                      launchUrl(Uri.parse('tel:$mob'));
                    }
                  },
                  child: Text(
                    '${'mobile_label'.tr} ${patient.mobileNo ?? '-'}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.teal,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Doctor Name & Doctor Mobile
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${'doctor_label'.tr} ${patient.doctorName ?? '-'}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.navy,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    final mob = patient.doctorMobileNo ?? '';
                    if (mob.isNotEmpty) {
                      launchUrl(Uri.parse('tel:$mob'));
                    }
                  },
                  child: Text(
                    '${'doc_mobile_label'.tr} ${patient.doctorMobileNo ?? '-'}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.teal,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),

            // Institute row
            Row(
              children: [
                Text(
                  '${'institute'.tr}: ',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.medicalGray),
                ),
                Expanded(
                  child: Text(
                    patient.instituteName ?? '-',
                    style: const TextStyle(fontSize: 13, color: AppColors.navy),
                  ),
                ),
              ],
            ),

            // Current Bed info (if Admitted)
            if (isAdmitted && patient.currentPlace != null && patient.currentPlace!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  Text(
                    '${'place_label'.tr} ',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.medicalGray),
                  ),
                  Expanded(
                    child: Text(
                      '${patient.currentPlace}${patient.currentName != null ? " (${patient.currentName})" : ""}${patient.currentBedNo != null ? " - ${'bed'.tr} ${patient.currentBedNo}" : ""}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 12),

            // Action Button
            if (!isAdmitted) ...[
              AppPrimaryButton(
                label: 'admit_patient_btn'.tr,
                onPressed: () => controller.onAdmitPatientClick(patient),
              ),
            ] else ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.teal,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  icon: const Icon(Icons.bed, color: AppColors.white, size: 20),
                  label: Text(
                    'change_place_and_bed'.tr,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => controller.onChangeBedClick(patient),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
