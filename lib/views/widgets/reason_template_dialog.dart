import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Flutter port of Android's reasonDialog().
/// Shows a list of template holding_reasons, inserts selected into [controller].
/// Returns body widget for use inside AppDialog.show().
class ReasonTemplateDialog extends StatefulWidget {
  final List<dynamic> templates;
  final TextEditingController controller;

  const ReasonTemplateDialog({
    super.key,
    required this.templates,
    required this.controller,
  });

  @override
  State<ReasonTemplateDialog> createState() => _ReasonTemplateDialogState();
}

class _ReasonTemplateDialogState extends State<ReasonTemplateDialog> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Template list
        if (widget.templates.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'No templates available',
                style: TextStyle(color: AppColors.coolGray),
              ),
            ),
          )
        else
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 300),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: widget.templates.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = widget.templates[index];
                final holdingReason = item['holding_reason']?.toString() ?? '';
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    holdingReason,
                    style: const TextStyle(fontSize: 14, color: AppColors.navy),
                  ),
                  onTap: () {
                    // Insert selected reason into the text field.
                    final textToInsert = holdingReason.split('. ').first;
                    widget.controller.text = textToInsert;
                    Get.back(); // Close the template dialog
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}
