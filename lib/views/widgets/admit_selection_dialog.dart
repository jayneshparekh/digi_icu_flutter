import 'package:digi_icu_flutter/controllers/serving_patient_controller.dart';
import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/views/widgets/app_primary_button.dart';
import 'package:digi_icu_flutter/views/widgets/app_radio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdmitSelectionDialog extends StatelessWidget {
  final ServingPatientController controller = Get.find();
  final RxString selectedOption = 'admit_request'.obs;

  AdmitSelectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'admit_selection_title'.tr,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: AppColors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'admit_selection_subtitle'.tr,
              style: const TextStyle(fontSize: 14, color: AppColors.coolGray),
            ),
            const SizedBox(height: 16),
            Obx(
              () => RadioGroup<String>(
                groupValue: selectedOption.value,
                onChanged: (value) {
                  if (value != null) {
                    selectedOption.value = value;
                  }
                },
                child: Column(
                  children: [
                    AppRadioListTile<String>(
                      value: 'admit_request',
                      title: Text('admit_request'.tr),
                    ),
                    const SizedBox(height: 4),
                    AppRadioListTile<String>(
                      value: 'admit',
                      title: Text('admit'.tr),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    'cancel'.tr,
                    style: const TextStyle(
                      color: AppColors.error,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 120,
                  child: AppPrimaryButton(
                    label: 'submit'.tr,
                    height: 40,
                    onPressed: () {
                      Get.back();
                      if (selectedOption.value == 'admit_request') {
                        controller.confirmAndSubmitAdmitRequest();
                      } else if (selectedOption.value == 'admit') {
                        controller.getDiagnosisAndProceed();
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
