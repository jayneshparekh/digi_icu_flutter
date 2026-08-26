import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/models/response/doctors/statuswise_patients_response.dart';
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

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title & Close Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'confirm_patient'.tr,
                    style: TextStyle(
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
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      color: AppColors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Patient Name, Age, Gender Row
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    fullName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy,
                    ),
                  ),
                  Text(
                    ' / ${patient.age} / ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy,
                    ),
                  ),
                  Text(
                    genderText,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Mobile, Taluka, District, State Row
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    patient.mobileNo,
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.navy,
                    ),
                  ),
                  if (patient.taluka.isNotEmpty)
                    Text(
                      ' / ${patient.taluka}',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.navy,
                      ),
                    ),
                  if (patient.district.isNotEmpty)
                    Text(
                      ' / ${patient.district}',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.navy,
                      ),
                    ),
                  if (patient.state.isNotEmpty)
                    Text(
                      ' / ${patient.state}',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.navy,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Cancel and Confirm Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    'cancel'.tr,
                    style: TextStyle(
                      color: AppColors.error,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                    onConfirm();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.teal,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: Text(
                    'confirm'.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
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
