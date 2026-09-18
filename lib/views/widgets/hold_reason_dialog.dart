import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/views/widgets/app_snackbars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Predefined hold reasons available for selection when putting an appointment on hold.
const List<String> holdReasons = [
  'Patient Not Available',
  'Asked to check BP',
  'Asked to check Sugar',
  'Asked to get ECG',
  'Advised Investigations',
  'Sample collected , results awaiting',
  'Request from  patient to hold for some time ',
  'Patients other relative want to talk ',
  'Asked my senior or colleague to see the patient ',
  'Waiting for leader',
  'Patient uploading report',
  'Other',
];

/// Dialog widget for selecting or specifying a reason for placing a patient appointment on hold.
/// Rendered within [AppDialog.show].
class HoldReasonDialog extends StatefulWidget {
  final Function(String reason, String ptStatus) onSubmit;
  final String status; // e.g. "In Process" or "Served"
  final VoidCallback? onGetReasonTemplateClick;
  final TextEditingController? otherReasonController;

  const HoldReasonDialog({
    super.key,
    required this.onSubmit,
    required this.status,
    this.onGetReasonTemplateClick,
    this.otherReasonController,
  });

  @override
  State<HoldReasonDialog> createState() => _HoldReasonDialogState();
}

class _HoldReasonDialogState extends State<HoldReasonDialog> {
  String _selectedReason = 'Patient Not Available';
  bool _isOtherSelected = false;
  bool _keepSameStatus = false;
  String _ptStatus = '2';

  TextEditingController get _otherReasonController =>
      widget.otherReasonController ?? _localController;

  final TextEditingController _localController = TextEditingController();
  bool get _ownsController => widget.otherReasonController == null;

  @override
  void initState() {
    super.initState();
    _selectedReason = holdReasons.first;
  }

  @override
  void dispose() {
    if (_ownsController) _localController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Keep on same status checkbox (only visible for "In Process")
        if (widget.status == 'In Process')
          Row(
            children: [
              Checkbox(
                value: _keepSameStatus,
                onChanged: (val) {
                  setState(() {
                    _keepSameStatus = val ?? false;
                    _ptStatus =
                        (_keepSameStatus && widget.status == 'In Process')
                        ? '0'
                        : '2';
                  });
                },
                activeColor: AppColors.info,
                checkColor: AppColors.white,
              ),
              Text(
                'keep_on_same_status'.tr,
                style: const TextStyle(fontSize: 14, color: AppColors.navy),
              ),
            ],
          ),
        const SizedBox(height: 8),

        // Spinner (DropdownButton)
        DropdownButtonFormField<String>(
          initialValue: _selectedReason,
          isExpanded: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
          items: holdReasons.map((reason) {
            return DropdownMenuItem<String>(value: reason, child: Text(reason));
          }).toList(),
          onChanged: (val) {
            setState(() {
              _selectedReason = val ?? holdReasons.first;
              _isOtherSelected = _selectedReason == 'Other';
            });
          },
        ),
        const SizedBox(height: 8),

        // Other Reason input + Template button (shown when "Other" is selected)
        if (_isOtherSelected) ...[
          TextField(
            controller: _otherReasonController,
            decoration: InputDecoration(
              hintText: 'enter_reason'.tr,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Template button
          SizedBox(
            height: 38,
            child: ElevatedButton.icon(
              onPressed: widget.onGetReasonTemplateClick ?? () {},
              icon: const Icon(Icons.list, size: 18, color: Colors.white),
              label: Text('template'.tr),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.navy,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
        ],
        const SizedBox(height: 16),

        // Submit / Cancel buttons (handled by AppDialog via confirmLabel/cancelLabel)
        // Since we need custom submit logic, we use our own buttons here.
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                'cancel'.tr,
                style: const TextStyle(color: AppColors.error, fontSize: 16),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                final reason = _isOtherSelected
                    ? (_otherReasonController.text.trim().isEmpty
                          ? 'Other'
                          : _otherReasonController.text.trim())
                    : _selectedReason;
                if (reason.isNotEmpty) {
                  Get.back(); // Close the dialog first
                  widget.onSubmit(reason, _ptStatus);
                } else {
                  AppSnackbars.showError(
                    'validation_error'.tr,
                    'please_select_reason'.tr,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.teal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
              ),
              child: Text(
                'submit'.tr,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
