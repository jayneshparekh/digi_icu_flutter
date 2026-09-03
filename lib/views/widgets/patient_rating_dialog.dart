import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/views/widgets/app_dialog.dart';
import 'package:digi_icu_flutter/views/widgets/app_snackbars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PatientRatingDialog extends StatefulWidget {
  final String initialRating;
  final Function(String) onSubmit;

  const PatientRatingDialog({
    super.key,
    required this.initialRating,
    required this.onSubmit,
  });

  @override
  State<PatientRatingDialog> createState() => _PatientRatingDialogState();
}

class _PatientRatingDialogState extends State<PatientRatingDialog> {
  late final RxString selectedRating;

  @override
  void initState() {
    super.initState();
    selectedRating = widget.initialRating.obs;
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: 'patient_important'.tr,
      confirmLabel: 'submit'.tr,
      onConfirm: () {
        if (selectedRating.value.isNotEmpty && selectedRating.value != '0') {
          Get.back();
          widget.onSubmit(selectedRating.value);
        } else {
          AppSnackbars.showError('validation_error'.tr, 'choose_rating_validation'.tr);
        }
      },
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Choose your rating
          Text(
            'choose_rating'.tr,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.navy,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Radio Buttons 1 to 5 inside RadioGroup wrapper (to satisfy AGENTS.md rule 9)
          Obx(() {
            // Rule 9: Do NOT use groupValue and onChanged directly on Radio List Tiles,
            // wrap in RadioGroup ancestor.
            return RadioGroup<String>(
              groupValue: selectedRating.value,
              onChanged: (val) {
                if (val != null) {
                  selectedRating.value = val;
                }
              },
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: ['1', '2', '3', '4', '5'].map((rate) {
                    final isSelected = selectedRating.value == rate;
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio<String>(
                          value: rate,
                          activeColor: AppColors.teal,
                          visualDensity: VisualDensity.compact,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          rate,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? AppColors.teal : AppColors.navy,
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                    );
                  }).toList(),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
