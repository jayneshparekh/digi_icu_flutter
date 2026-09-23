import 'package:digi_icu_flutter/controllers/serving_patient_controller.dart';
import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/views/widgets/app_primary_button.dart';
import 'package:digi_icu_flutter/views/widgets/app_radio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PreAdmitDialog extends StatelessWidget {
  final List<dynamic> institutes;
  final VoidCallback onSubmit;

  const PreAdmitDialog({
    super.key,
    required this.institutes,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ServingPatientController>();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        width: MediaQuery.of(context).size.width * 0.85,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Title and Close Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'admit'.tr,
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
              const SizedBox(height: 16),

              // Institute Dropdown
              Obx(() {
                final String? initialId =
                    controller.selectedInstituteId.value.isNotEmpty &&
                        institutes.any(
                          (i) =>
                              (i['id']?.toString() ==
                                  controller.selectedInstituteId.value ||
                              i['institute_id']?.toString() ==
                                  controller.selectedInstituteId.value),
                        )
                    ? controller.selectedInstituteId.value
                    : null;

                return DropdownButtonFormField<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'institute'.tr,
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  initialValue: initialId,
                  hint: Text('please_select_institute'.tr),
                  items: institutes.map((inst) {
                    final idVal =
                        (inst['id'] ?? inst['institute_id'])?.toString() ?? '';
                    return DropdownMenuItem<String>(
                      value: idVal,
                      child: Text(inst['institute_name']?.toString() ?? ''),
                    );
                  }).toList(),
                  onChanged: (value) {
                    final index = institutes.indexWhere(
                      (i) =>
                          (i['id']?.toString() == value ||
                          i['institute_id']?.toString() == value),
                    );
                    if (index >= 0) {
                      final instId =
                          (institutes[index]['id'] ??
                                  institutes[index]['institute_id'])
                              ?.toString() ??
                          '';
                      final instName =
                          institutes[index]['institute_name']?.toString() ?? '';
                      controller.selectedInstituteId.value = instId;
                      controller.selectedInstituteName.value = instName;
                      controller.checkDayCareAvailability(instId);
                    }
                  },
                );
              }),
              const SizedBox(height: 16),

              // Day Care vs Others Radio Selection
              Obx(() {
                final isAvailable = controller.isDayCareAvailable.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'day_care_vs_others'.tr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 8),
                    RadioGroup<String>(
                      groupValue: controller.dayCareOption.value,
                      onChanged: (val) {
                        if (val != null) {
                          if (val == 'day_care' && !isAvailable) return;
                          controller.dayCareOption.value = val;
                          controller.isDayCare.value = (val == 'day_care');
                        }
                      },
                      child: Column(
                        children: [
                          AppRadioListTile<String>(
                            value: 'day_care',
                            title: Text('day_care'.tr),
                            enabled: isAvailable,
                          ),
                          const SizedBox(height: 4),
                          AppRadioListTile<String>(
                            value: 'others',
                            title: Text('others'.tr),
                          ),
                        ],
                      ),
                    ),
                    if (!isAvailable &&
                        controller.selectedInstituteId.value.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        'no_day_care_warning'.tr,
                        style: const TextStyle(
                          color: AppColors.error,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                );
              }),
              const SizedBox(height: 24),

              // Footer Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      'cancel'.tr,
                      style: const TextStyle(
                        color: AppColors.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Obx(
                    () => SizedBox(
                      width: 120,
                      child: AppPrimaryButton(
                        label: 'submit'.tr,
                        height: 40,
                        onPressed:
                            controller.selectedInstituteId.value.isNotEmpty
                            ? onSubmit
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
