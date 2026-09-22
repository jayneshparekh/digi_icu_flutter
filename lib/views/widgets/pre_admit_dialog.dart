import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/controllers/serving_patient_controller.dart';
import 'package:digi_icu_flutter/views/widgets/app_radio.dart';

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
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Institute Dropdown
              Obx(() {
                final String? initialId = controller.selectedInstituteId.value.isNotEmpty &&
                        institutes.any((i) =>
                            (i['id']?.toString() == controller.selectedInstituteId.value ||
                             i['institute_id']?.toString() == controller.selectedInstituteId.value))
                    ? controller.selectedInstituteId.value
                    : null;

                return DropdownButtonFormField<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'institute'.tr,
                    border: const OutlineInputBorder(),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  initialValue: initialId,
                  hint: Text('please_select_institute'.tr),
                  items: institutes.map((inst) {
                    final idVal = (inst['id'] ?? inst['institute_id'])?.toString() ?? '';
                    return DropdownMenuItem<String>(
                      value: idVal,
                      child: Text(inst['institute_name']?.toString() ?? ''),
                    );
                  }).toList(),
                  onChanged: (value) {
                    final index = institutes.indexWhere((i) =>
                        (i['id']?.toString() == value || i['institute_id']?.toString() == value));
                    if (index >= 0) {
                      final instId = (institutes[index]['id'] ?? institutes[index]['institute_id'])?.toString() ?? '';
                      final instName = institutes[index]['institute_name']?.toString() ?? '';
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
                    RadioGroup<String>(
                      groupValue: controller.dayCareOption.value,
                      onChanged: (val) {
                        if (val != null) {
                          if (val == 'day_care' && !isAvailable) return;
                          controller.dayCareOption.value = val;
                          controller.isDayCare.value = (val == 'day_care');
                        }
                      },
                      child: Row(
                        children: [
                          const AppRadio<String>(value: 'day_care'),
                          Text(
                            'day_care'.tr,
                            style: TextStyle(
                              color: isAvailable ? Colors.black : Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const AppRadio<String>(value: 'others'),
                          Text('others'.tr),
                        ],
                      ),
                    ),
                    if (!isAvailable && controller.selectedInstituteId.value.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      const Text(
                        'This institute has no Day Care available.',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ],
                  ],
                );
              }),
            ],
          ),
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