import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/views/widgets/app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChooseFormOptionDialog extends StatelessWidget {
  final String formTypesString;
  final Function(String) onSelect;

  const ChooseFormOptionDialog({
    super.key,
    required this.formTypesString,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    // Parse the form types
    final List<String> forms = formTypesString
        .split(',')
        .map((f) => f.trim())
        .where((f) => f.isNotEmpty)
        .toList();

    return AppDialog(
      title: 'choose_consultation_type'.tr,
      cancelLabel: 'cancel'.tr,
      onCancel: () => Get.back(),
      body: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: forms.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('no_forms_available'.tr, style: const TextStyle(color: AppColors.medicalGray)),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: forms.length,
                itemBuilder: (context, index) {
                  final formName = forms[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: InkWell(
                      onTap: () {
                        Get.back();
                        onSelect(formName);
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                        decoration: BoxDecoration(
                          color: AppColors.lightGray,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.teal.withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                formName,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.teal,
                                ),
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.teal),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}


