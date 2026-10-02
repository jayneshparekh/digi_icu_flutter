import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/views/widgets/app_dialog.dart';
import 'package:digi_icu_flutter/views/widgets/app_primary_button.dart';
import 'package:digi_icu_flutter/views/widgets/app_radio.dart';
import 'package:digi_icu_flutter/views/widgets/app_secondary_button.dart';
import 'package:digi_icu_flutter/views/widgets/app_snackbars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Modal dialog presented when the chest pain evaluation requires missing medical history.
class MedicalFormChestPainDialog extends StatefulWidget {
  final Function(String pastHistory, String pastSurgery, String familyAttack)
  onSubmit;

  const MedicalFormChestPainDialog({super.key, required this.onSubmit});

  static Future<void> show({
    required Function(
      String pastHistory,
      String pastSurgery,
      String familyAttack,
    )
    onSubmit,
  }) {
    return AppDialog.show(
      title: 'medical_form_missing_title'.tr,
      body: MedicalFormChestPainDialog(onSubmit: onSubmit),
      showCloseButton: true,
    );
  }

  @override
  State<MedicalFormChestPainDialog> createState() =>
      _MedicalFormChestPainDialogState();
}

class _MedicalFormChestPainDialogState
    extends State<MedicalFormChestPainDialog> {
  String? _pastHistory;
  String? _pastSurgery;
  String? _familyAttack;

  void _handleSubmit() {
    if (_pastHistory == null || _pastSurgery == null || _familyAttack == null) {
      AppSnackbars.showError(
        'validation_error'.tr,
        'please_answer_all_questions'.tr,
      );
      return;
    }

    Get.back();
    widget.onSubmit(_pastHistory!, _pastSurgery!, _familyAttack!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'medical_form_not_found_prompt'.tr,
          style: const TextStyle(fontSize: 13, color: AppColors.coolGray),
        ),
        const SizedBox(height: 16),

        // 1. Hypertension or Diabetes
        Text(
          'hypertension_or_diabetes_q'.tr,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.navy,
          ),
        ),
        const SizedBox(height: 6),
        RadioGroup<String>(
          groupValue: _pastHistory,
          onChanged: (val) => setState(() => _pastHistory = val),
          child: Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AppRadio<String>(value: 'Yes'),
                  const SizedBox(width: 4),
                  Text('yes'.tr, style: const TextStyle(color: AppColors.navy)),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AppRadio<String>(value: 'No'),
                  const SizedBox(width: 4),
                  Text('no'.tr, style: const TextStyle(color: AppColors.navy)),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AppRadio<String>(value: 'DontKnow'),
                  const SizedBox(width: 4),
                  Text(
                    'dont_know'.tr,
                    style: const TextStyle(color: AppColors.navy),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 2. Past Heart Surgery / Attack
        Text(
          'past_heart_surgery_q'.tr,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.navy,
          ),
        ),
        const SizedBox(height: 6),
        RadioGroup<String>(
          groupValue: _pastSurgery,
          onChanged: (val) => setState(() => _pastSurgery = val),
          child: Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AppRadio<String>(value: 'Yes'),
                  const SizedBox(width: 4),
                  Text('yes'.tr, style: const TextStyle(color: AppColors.navy)),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AppRadio<String>(value: 'No'),
                  const SizedBox(width: 4),
                  Text('no'.tr, style: const TextStyle(color: AppColors.navy)),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AppRadio<String>(value: 'DontKnow'),
                  const SizedBox(width: 4),
                  Text(
                    'dont_know'.tr,
                    style: const TextStyle(color: AppColors.navy),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 3. Family Heart Attack before 55
        Text(
          'chest_pain_family_attack_q'.tr,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.navy,
          ),
        ),
        const SizedBox(height: 6),
        RadioGroup<String>(
          groupValue: _familyAttack,
          onChanged: (val) => setState(() => _familyAttack = val),
          child: Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AppRadio<String>(value: 'Yes'),
                  const SizedBox(width: 4),
                  Text('yes'.tr, style: const TextStyle(color: AppColors.navy)),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AppRadio<String>(value: 'No'),
                  const SizedBox(width: 4),
                  Text('no'.tr, style: const TextStyle(color: AppColors.navy)),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AppRadio<String>(value: 'DontKnow'),
                  const SizedBox(width: 4),
                  Text(
                    'dont_know'.tr,
                    style: const TextStyle(color: AppColors.navy),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Action Buttons
        Row(
          children: [
            Expanded(
              child: AppSecondaryButton(
                label: 'cancel'.tr,
                onPressed: () => Get.back(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppPrimaryButton(
                label: 'submit'.tr,
                onPressed: _handleSubmit,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
