import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/controllers/serving_patient_controller.dart';

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

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text('admit'.tr),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Institute Dropdown
            Obx(() => DropdownButtonFormField<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'institute'.tr,
                    border: OutlineInputBorder(),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  initialValue: controller.selectedInstituteId.value.isNotEmpty
                      ? controller.selectedInstituteName.value
                      : null,
                  hint: Text('please_select_institute'.tr),
                  items: institutes.map((inst) {
                    return DropdownMenuItem<String>(
                      value: inst['institute_id']?.toString(),
                      child: Text(inst['institute_name']?.toString() ?? ''),
                    );
                  }).toList(),
                  onChanged: (value) {
                    final index = institutes
                        .indexWhere((i) => i['institute_id']?.toString() == value);
                    if (index >= 0) {
                      controller.selectedInstituteId.value =
                          institutes[index]['institute_id']?.toString() ?? '';
                      controller.selectedInstituteName.value =
                          institutes[index]['institute_name']?.toString() ?? '';
                    }
                  },
                )),
            const SizedBox(height: 16),
            // Day Care Toggle
            Obx(() => Row(
                  children: [
                    Checkbox(
                      value: controller.isDayCare.value,
                      onChanged: (val) {
                        controller.isDayCare.value = val ?? false;
                      },
                      activeColor: AppColors.teal,
                    ),
                    Expanded(
                      child: Text('day_care'.tr),
                    ),
                  ],
                )),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('cancel'.tr),
        ),
        Obx(() => ElevatedButton(
              onPressed: controller.selectedInstituteId.value.isNotEmpty
                  ? onSubmit
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.teal,
              ),
              child: Text('submit'.tr),
            )),
      ],
    );
  }
}