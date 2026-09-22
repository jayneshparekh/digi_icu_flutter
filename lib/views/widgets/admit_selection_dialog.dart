import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/controllers/serving_patient_controller.dart';

class AdmitSelectionDialog extends StatelessWidget {
  final ServingPatientController controller = Get.find();

  AdmitSelectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text('admit_selection_title'.tr),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              dense: true,
              leading: const Icon(Icons.person_add, color: AppColors.teal),
              title: Text('admit_request'.tr),
              onTap: () {
                Get.back();
                controller.confirmAndSubmitAdmitRequest();
              },
            ),
            ListTile(
              dense: true,
              leading: const Icon(Icons.local_hospital, color: AppColors.teal),
              title: Text('admit'.tr),
              onTap: () {
                Get.back();
                controller.getDiagnosisAndProceed();
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('cancel'.tr),
        ),
      ],
    );
  }
}