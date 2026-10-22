import 'package:digi_icu_flutter/controllers/admit_patient_request_controller.dart';
import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/models/response/patient/admit_request_response.dart';
import 'package:digi_icu_flutter/views/widgets/app_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Modal dialog allowing hospital staff to modify a patient's current section and bed assignment.
class ChangeBedDialog extends StatelessWidget {
  final AdmitRequestPatientItem patient;
  final AdmitPatientRequestController controller;

  const ChangeBedDialog({
    super.key,
    required this.patient,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        padding: const EdgeInsets.all(20),
        child: Obx(() {
          final places = <String>[];
          places.addAll(
            controller.placeList
                .map((p) => p.place ?? '')
                .where((p) => p.isNotEmpty),
          );

          final placeObj = controller.placeList.firstWhereOrNull(
            (p) => p.place == controller.changeSelectedPlace.value,
          );
          final names = <String>[];
          if (placeObj != null) {
            names.addAll(
              placeObj.names.map((n) => n.name ?? '').where((n) => n.isNotEmpty),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'change_place_and_bed_title'.tr,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.error),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${patient.patientName ?? ''} (${patient.mhcId ?? '-'})',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.medicalGray,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${'current_label'.tr} ${patient.currentPlace ?? 'None'}${patient.currentName != null ? " (${patient.currentName})" : ""}${patient.currentBedNo != null ? " - ${'bed'.tr} ${patient.currentBedNo}" : ""}',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.teal,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Divider(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Place selector
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: 'place_label_text'.tr,
                          border: const OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        initialValue:
                            places.contains(controller.changeSelectedPlace.value)
                                ? controller.changeSelectedPlace.value
                                : null,
                        hint: Text('select_place_hint'.tr),
                        items: places
                            .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            controller.changeSelectedPlace.value = val;
                            controller.changeSelectedName.value = '';
                            controller.changeSelectedBedNo.value = '';
                            controller.changeAvailableBeds.clear();
                          }
                        },
                      ),
                      const SizedBox(height: 14),
                      // Name / Section selector
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: 'section_label_text'.tr,
                          border: const OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        initialValue:
                            names.contains(controller.changeSelectedName.value)
                                ? controller.changeSelectedName.value
                                : null,
                        hint: Text('select_name_hint'.tr),
                        items: names
                            .map((n) => DropdownMenuItem(value: n, child: Text(n)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            controller.changeSelectedName.value = val;
                            controller.changeSelectedBedNo.value = '';
                            controller.updateChangeBeds(
                              controller.changeSelectedPlace.value,
                              val,
                              patient.currentBedNo,
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'bed_number_label'.tr,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.navy,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (controller.changeAvailableBeds.isEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            controller.changeSelectedName.value.isEmpty
                                ? 'select_place_and_section_to_view_beds'.tr
                                : 'no_empty_beds_available'.tr,
                            style: TextStyle(
                              fontSize: 13,
                              color: controller.changeSelectedName.value.isEmpty
                                  ? AppColors.medicalGray
                                  : AppColors.error,
                            ),
                          ),
                        ),
                      ] else ...[
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: controller.changeAvailableBeds.map((bed) {
                            final isSelected =
                                controller.changeSelectedBedNo.value == bed;
                            return ChoiceChip(
                              label: Text('${'bed'.tr} $bed'),
                              selected: isSelected,
                              selectedColor: AppColors.teal,
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? AppColors.white
                                    : AppColors.navy,
                                fontWeight: FontWeight.w600,
                              ),
                              onSelected: (sel) {
                                if (sel) {
                                  controller.changeSelectedBedNo.value = bed;
                                }
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              AppPrimaryButton(
                label: 'submit'.tr.toUpperCase(),
                isLoading: controller.isSubmittingBedChange.value,
                onPressed: () => controller.submitBedChange(patient),
              ),
            ],
          );
        }),
      ),
    );
  }
}
