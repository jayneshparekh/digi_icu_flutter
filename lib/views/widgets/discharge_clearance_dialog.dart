import 'package:digi_icu_flutter/controllers/discharge_request_controller.dart';
import 'package:digi_icu_flutter/core/constants/app_constants.dart';
import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/models/response/patient/discharge_request_response.dart';
import 'package:digi_icu_flutter/views/widgets/app_primary_button.dart';
import 'package:digi_icu_flutter/views/widgets/app_radio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

/// Modal dialog for reviewing and completing clearance checks (Pharmacy, Summary, Lab, Other bills)
/// and submitting the final discharge for an IPD patient.
class DischargeClearanceDialog extends StatelessWidget {
  final DischargeRequestPatientItem item;
  final DischargeRequestController controller;

  const DischargeClearanceDialog({
    super.key,
    required this.item,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'discharge_request_details'.tr,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.coolGray),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 1. Pharmacy Bill Section
              Text(
                'pharmacy_bill'.tr,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 6),
              Obx(
                () => RadioGroup<String>(
                  groupValue: controller.pharmacyBillStatus.value,
                  onChanged: (val) {
                    if (val != null) {
                      controller.pharmacyBillStatus.value = val;
                    }
                  },
                  child: Row(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppRadio<String>(value: 'paid'),
                          Text(
                            'paid'.tr,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(width: 24),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppRadio<String>(value: 'due'),
                          Text(
                            'due'.tr,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Obx(() {
                if (controller.pharmacyBillStatus.value == 'due') {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: TextField(
                      controller: controller.pharmacyDueController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        hintText: 'enter_due_pharmacy_amount'.tr,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),

              const Divider(height: 24, thickness: 0.5),

              // 2. Discharge Summary Section
              Text(
                'discharge_summary'.tr,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 6),
              Obx(() {
                if (controller.isLoadingDischargeSummary.value) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: LinearProgressIndicator(color: AppColors.teal),
                  );
                }

                final path = controller.activeDischargePath.value;
                if (path.isNotEmpty) {
                  return Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            final fullUrl =
                                '${AppConstants.patientReportUrl}$path';
                            launchUrl(
                              Uri.parse(fullUrl),
                              mode: LaunchMode.externalApplication,
                            );
                          },
                          child: Text(
                            path,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.teal,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(
                          Icons.open_in_new,
                          size: 20,
                          color: AppColors.teal,
                        ),
                        tooltip: 'view_summary'.tr,
                        onPressed: () {
                          final fullUrl =
                              '${AppConstants.patientReportUrl}$path';
                          launchUrl(
                            Uri.parse(fullUrl),
                            mode: LaunchMode.externalApplication,
                          );
                        },
                      ),
                    ],
                  );
                } else {
                  return Row(
                    children: [
                      Expanded(
                        child: Text(
                          'no_discharge_summary_uploaded'.tr,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.coolGray,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          await Get.toNamed(
                            '/discharge-summary',
                            arguments: {
                              'patient_id': item.patientId ?? '',
                              'admit_id': item.admitId ?? '',
                              'patient_name': item.patientName ?? '',
                              'age': item.age ?? '',
                              'gender': item.gender ?? '',
                            },
                          );
                          controller.fetchDischargeSummary(
                            item.admitId ?? '',
                          );
                        },
                        child: Text(
                          'upload_summary'.tr,
                          style: const TextStyle(
                            color: AppColors.teal,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  );
                }
              }),

              const Divider(height: 24, thickness: 0.5),

              // 3. Lab Bill Section
              Text(
                'lab_bill'.tr,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 6),
              Obx(
                () => RadioGroup<String>(
                  groupValue: controller.labBillStatus.value,
                  onChanged: (val) {
                    if (val != null) controller.labBillStatus.value = val;
                  },
                  child: Row(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppRadio<String>(value: 'paid'),
                          Text(
                            'paid'.tr,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(width: 24),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppRadio<String>(value: 'due'),
                          Text(
                            'due'.tr,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Obx(() {
                if (controller.labBillStatus.value == 'due') {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: TextField(
                      controller: controller.labDueController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        hintText: 'enter_due_lab_amount'.tr,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),

              const Divider(height: 24, thickness: 0.5),

              // 4. Other Bill Section
              Text(
                'other_bill'.tr,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 6),
              Obx(
                () => RadioGroup<String>(
                  groupValue: controller.otherBillStatus.value,
                  onChanged: (val) {
                    if (val != null) {
                      controller.otherBillStatus.value = val;
                    }
                  },
                  child: Row(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppRadio<String>(value: 'paid'),
                          Text(
                            'paid'.tr,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(width: 24),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppRadio<String>(value: 'due'),
                          Text(
                            'due'.tr,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Obx(() {
                if (controller.otherBillStatus.value == 'due') {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: TextField(
                      controller: controller.otherDueController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        hintText: 'enter_due_other_amount'.tr,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),

              const SizedBox(height: 24),

              // Submit Button using AppPrimaryButton
              Obx(
                () => AppPrimaryButton(
                  label: 'discharge_btn'.tr,
                  isLoading: controller.isSubmittingDischarge.value,
                  onPressed: () => controller.submitFinalDischarge(item),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
