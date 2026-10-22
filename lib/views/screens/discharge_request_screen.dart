import 'package:digi_icu_flutter/controllers/discharge_request_controller.dart';
import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/models/response/patient/discharge_request_response.dart';
import 'package:digi_icu_flutter/views/widgets/app_status_badge.dart';
import 'package:digi_icu_flutter/views/widgets/discharge_clearance_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class DischargeRequestScreen extends GetView<DischargeRequestController> {
  const DischargeRequestScreen({super.key});

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
          'discharge_requests'.tr,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // Filter & Search bar header (styled identically to admit_patient_request_screen)
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.searchController,
                    onChanged: (val) => controller.filterPatients(val),
                    decoration: InputDecoration(
                      hintText: 'search_patients_hint'.tr,
                      hintStyle: const TextStyle(
                        color: AppColors.medicalGray,
                        fontSize: 14,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.medicalGray,
                      ),
                      filled: true,
                      fillColor: AppColors.lightGray,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
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
                      controller.loadDischargeRequests();
                    },
                  ),
                ),
              ],
            ),
          ),

          // Patients List
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
                    'no_discharge_requests_found'.tr,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.medicalGray,
                    ),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.loadDischargeRequests,
                color: AppColors.teal,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  itemCount: controller.filteredPatients.length,
                  itemBuilder: (context, index) {
                    final item = controller.filteredPatients[index];
                    return _buildPatientCard(context, item);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientCard(
    BuildContext context,
    DischargeRequestPatientItem item,
  ) {
    final genderDisplay = switch ((item.gender ?? '').toLowerCase()) {
      'male' => 'M',
      'female' => 'F',
      _ => 'O',
    };

    final ageDisplay = (item.age != null && item.age!.isNotEmpty)
        ? ' ${item.age}/$genderDisplay'
        : ' $genderDisplay';

    final displayName = '${item.patientName ?? "-"}$ageDisplay';

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Patient Name, Age, Gender & Status Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    displayName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.navy,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                AppStatusBadge(
                  label: item.status ?? 'discharge_request'.tr,
                  color: AppColors.warning,
                ),
              ],
            ),
            const SizedBox(height: 8),

            // MHC ID & IPD ID
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${'mhc_id'.tr} ${item.mhcId ?? "-"}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.medicalGray,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    '${'ipd_id_label'.tr} ${item.ipdId ?? "-"}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.medicalGray,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Mobile No (clickable) & Place
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      final mob = (item.mobileNo ?? '').trim();
                      if (mob.isNotEmpty) {
                        launchUrl(Uri.parse('tel:$mob'));
                      }
                    },
                    child: Text(
                      '${'mobile_label'.tr} ${item.mobileNo ?? "-"}',
                      style: TextStyle(
                        fontSize: 13,
                        color: (item.mobileNo?.isNotEmpty == true)
                            ? AppColors.teal
                            : AppColors.medicalGray,
                        decoration: (item.mobileNo?.isNotEmpty == true)
                            ? TextDecoration.underline
                            : TextDecoration.none,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    '${'place_label_text'.tr} ${item.currentPlaceDetails ?? "-"}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.navy,
                    ),
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Institute Row
            if (item.instituteName?.isNotEmpty == true) ...[
              Row(
                children: [
                  Text(
                    '${'institute'.tr}: ',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.medicalGray,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item.instituteName!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.navy,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],

            const Divider(height: 20, thickness: 0.5),

            // Action Button: Discharge & Bill Clearance
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () {
                  _showDischargeDialog(context, item);
                },
                icon: const Icon(Icons.check_circle_outline, size: 16),
                label: Text('clearance_status'.tr),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.teal,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Dialog for Bill Clearance and Final Discharge submission
  void _showDischargeDialog(
    BuildContext context,
    DischargeRequestPatientItem item,
  ) {
    controller.prepareDischargeDialog(item);
    Get.dialog(
      DischargeClearanceDialog(item: item, controller: controller),
      barrierDismissible: true,
    );
  }
}
