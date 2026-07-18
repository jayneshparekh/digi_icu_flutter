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
                const Expanded(
                  child: Text(
                    'Patient Important',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Header Choose your rating
            const Text(
              'Choose your rating',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
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
                            activeColor: AppColors.primary,
                            visualDensity: VisualDensity.compact,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            rate,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? AppColors.primary : Colors.black87,
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
                      message: 'Please choose a rating before submitting.',
                      backgroundColor: Colors.red,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
