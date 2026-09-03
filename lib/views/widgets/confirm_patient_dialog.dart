import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/models/response/doctors/statuswise_patients_response.dart';
import 'package:digi_icu_flutter/views/widgets/app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmPatientDialog extends StatelessWidget {
  final PatientAppointmentData patient;
  final VoidCallback onConfirm;

  const ConfirmPatientDialog({
    super.key,
    required this.patient,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final fullName = '${patient.firstName} ${patient.midName} ${patient.lastName}'.trim();
    final genderText = patient.gender == 'Male'
        ? 'M'
        : (patient.gender == 'Female' ? 'F' : 'O');

    return AppDialog(
      title: 'confirm_patient'.tr,
      confirmLabel: 'confirm'.tr,
      cancelLabel: 'cancel'.tr,
      onConfirm: () {
        Get.back();
        onConfirm();
      },
      onCancel: () => Get.back(),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  fullName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.navy,
                  ),
                ),
                Text(
                  ' / ${patient.age} / ',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.navy,
                  ),
                ),
                Text(
                  genderText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.navy,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  patient.mobileNo,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.navy,
                  ),
                ),
                if (patient.taluka.isNotEmpty)
                  Text(
                    ' / ${patient.taluka}',
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.navy,
                    ),
                  ),
                if (patient.district.isNotEmpty)
                  Text(
                    ' / ${patient.district}',
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.navy,
                    ),
                  ),
                if (patient.state.isNotEmpty)
                  Text(
                    ' / ${patient.state}',
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.navy,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
