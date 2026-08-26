import 'package:digi_icu_flutter/core/theme/app_colors.dart';
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
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title and Cancel Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'patient_important'.tr,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.teal,
                    ),
                    textAlign: TextAlign.center,
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
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Header Choose your rating
            Text(
              'choose_rating'.tr,
              style: TextStyle(
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
            const SizedBox(height: 24),
            // Submit Button
            SizedBox(
              width: 120,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  if (selectedRating.value.isNotEmpty && selectedRating.value != '0') {
                    Get.back();
                    widget.onSubmit(selectedRating.value);
                  } else {
                    Get.rawSnackbar(
                      message: 'choose_rating_validation'.tr,
                      backgroundColor: AppColors.error,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.teal,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Text(
                  'submit'.tr,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
