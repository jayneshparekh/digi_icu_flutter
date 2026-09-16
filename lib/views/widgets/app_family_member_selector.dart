import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/views/widgets/app_labeled_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A standardized reusable widget for selecting affected family members
/// (Father, Mother, Brother, Sister, Grandparents) along with age text fields.
class AppFamilyMemberSelector extends StatelessWidget {
  final RxBool fatherSelected;
  final TextEditingController fatherAgeController;
  final RxBool motherSelected;
  final TextEditingController motherAgeController;
  final RxBool brotherSelected;
  final TextEditingController brotherAgeController;
  final RxBool sisterSelected;
  final TextEditingController sisterAgeController;
  final RxBool grandparentsSelected;
  final TextEditingController grandparentsAgeController;

  const AppFamilyMemberSelector({
    super.key,
    required this.fatherSelected,
    required this.fatherAgeController,
    required this.motherSelected,
    required this.motherAgeController,
    required this.brotherSelected,
    required this.brotherAgeController,
    required this.sisterSelected,
    required this.sisterAgeController,
    required this.grandparentsSelected,
    required this.grandparentsAgeController,
  });

  Widget _buildMemberTile({
    required String labelKey,
    required RxBool isSelected,
    required TextEditingController ageController,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => Row(
            children: [
              Checkbox(
                value: isSelected.value,
                onChanged: (val) => isSelected.value = val ?? false,
                activeColor: AppColors.teal,
              ),
              Text(
                labelKey.tr,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.navy,
                ),
              ),
            ],
          ),
        ),
        Obx(() {
          if (!isSelected.value) return const SizedBox.shrink();
          return Padding(
            padding: const EdgeInsets.only(left: 32.0, bottom: 8.0, right: 16.0),
            child: AppLabeledTextField(
              controller: ageController,
              label: 'age_at_that_time'.tr,
              hint: 'e.g. 55',
              keyboardType: TextInputType.number,
            ),
          );
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'who_label'.tr,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.navy,
          ),
        ),
        const SizedBox(height: 6),
        _buildMemberTile(
          labelKey: 'father',
          isSelected: fatherSelected,
          ageController: fatherAgeController,
        ),
        _buildMemberTile(
          labelKey: 'mother',
          isSelected: motherSelected,
          ageController: motherAgeController,
        ),
        _buildMemberTile(
          labelKey: 'brother',
          isSelected: brotherSelected,
          ageController: brotherAgeController,
        ),
        _buildMemberTile(
          labelKey: 'sister',
          isSelected: sisterSelected,
          ageController: sisterAgeController,
        ),
        _buildMemberTile(
          labelKey: 'grandparents',
          isSelected: grandparentsSelected,
          ageController: grandparentsAgeController,
        ),
      ],
    );
  }
}
