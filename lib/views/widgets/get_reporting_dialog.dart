import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import 'app_dialog.dart';
import 'app_primary_button.dart';

/// Interactive dialog for submitting Cardiologist Report requests (GetReportingDialog).
class GetReportingDialog extends StatefulWidget {
  final Function({
    required String hypertension,
    required String diabetics,
    required String heartAttack,
    required String stroke,
    required String thyroid,
    required String systolicBp,
    required String diastolicBp,
    required String symptoms,
  }) onSubmit;

  const GetReportingDialog({
    super.key,
    required this.onSubmit,
  });

  static Future<void> show(
    BuildContext context, {
    required Function({
      required String hypertension,
      required String diabetics,
      required String heartAttack,
      required String stroke,
      required String thyroid,
      required String systolicBp,
      required String diastolicBp,
      required String symptoms,
    }) onSubmit,
  }) {
    return AppDialog.show(
      title: 'consult_cardiologist'.tr,
      showCloseButton: true,
      body: GetReportingDialog(onSubmit: onSubmit),
    );
  }

  @override
  State<GetReportingDialog> createState() => _GetReportingDialogState();
}

class _GetReportingDialogState extends State<GetReportingDialog> {
  String hypertension = '';
  String diabetics = '';
  String heartAttack = '';
  String stroke = '';
  String thyroid = '';

  final TextEditingController systolicBpCtrl = TextEditingController();
  final TextEditingController diastolicBpCtrl = TextEditingController();
  final TextEditingController otherSymptomsCtrl = TextEditingController();

  final List<String> selectedSymptoms = [];
  bool isOtherSelected = false;
  String errorMessage = '';

  Widget _buildYesNoDontKnowQuestion(
    String title,
    String currentValue,
    ValueChanged<String> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.navy),
        ),
        const SizedBox(height: 4),
        Row(
          children: ['Yes', 'No', "Don't Know"].map((option) {
            final isSelected = currentValue == option;
            return Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: InkWell(
                onTap: () => onChanged(option),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                        size: 18,
                        color: isSelected ? AppColors.teal : AppColors.coolGray,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        option,
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? AppColors.navy : AppColors.coolGray,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  void _onSymptomCheck(String symptom, bool? isChecked) {
    setState(() {
      if (isChecked == true) {
        if (symptom == 'None') {
          selectedSymptoms.clear();
          selectedSymptoms.add('None');
          isOtherSelected = false;
        } else {
          selectedSymptoms.remove('None');
          if (!selectedSymptoms.contains(symptom)) {
            selectedSymptoms.add(symptom);
          }
          if (symptom == 'Other') {
            isOtherSelected = true;
          }
        }
      } else {
        selectedSymptoms.remove(symptom);
        if (symptom == 'Other') {
          isOtherSelected = false;
        }
      }
    });
  }

  void _handleSubmit() {
    if (hypertension.isEmpty || diabetics.isEmpty || heartAttack.isEmpty || stroke.isEmpty || thyroid.isEmpty) {
      setState(() {
        errorMessage = 'Please answer all medical questions.';
      });
      return;
    }
    if (systolicBpCtrl.text.trim().isEmpty || diastolicBpCtrl.text.trim().isEmpty) {
      setState(() {
        errorMessage = 'Please enter both Systolic and Diastolic BP.';
      });
      return;
    }
    if (selectedSymptoms.isEmpty) {
      setState(() {
        errorMessage = 'Please select at least one symptom or None.';
      });
      return;
    }

    String finalSymptoms = selectedSymptoms.join(', ');
    if (isOtherSelected && otherSymptomsCtrl.text.trim().isNotEmpty) {
      finalSymptoms += ' (${otherSymptomsCtrl.text.trim()})';
    }

    Navigator.of(context).pop();
    widget.onSubmit(
      hypertension: hypertension,
      diabetics: diabetics,
      heartAttack: heartAttack,
      stroke: stroke,
      thyroid: thyroid,
      systolicBp: systolicBpCtrl.text.trim(),
      diastolicBp: diastolicBpCtrl.text.trim(),
      symptoms: finalSymptoms,
    );
  }

  @override
  Widget build(BuildContext context) {
    final symptomList = ['Chest Pain', 'Palpitations', 'Giddiness', 'Breathlessness', 'Headache', 'Other', 'None'];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildYesNoDontKnowQuestion('Do you have Hypertension?', hypertension, (val) {
            setState(() => hypertension = val);
          }),
          _buildYesNoDontKnowQuestion('Do you have Diabetes?', diabetics, (val) {
            setState(() => diabetics = val);
          }),
          _buildYesNoDontKnowQuestion('Have you had a Heart Attack?', heartAttack, (val) {
            setState(() => heartAttack = val);
          }),
          _buildYesNoDontKnowQuestion('Have you had a Stroke?', stroke, (val) {
            setState(() => stroke = val);
          }),
          _buildYesNoDontKnowQuestion('Do you have Thyroid disorder?', thyroid, (val) {
            setState(() => thyroid = val);
          }),
          const Divider(),
          const SizedBox(height: 8),
          const Text(
            'Blood Pressure:',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.navy),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: systolicBpCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Systolic BP (mmHg)',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: diastolicBpCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Diastolic BP (mmHg)',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(),
          const Text(
            'Symptoms:',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.navy),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: symptomList.map((sym) {
              final isChecked = selectedSymptoms.contains(sym);
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: isChecked,
                    activeColor: AppColors.teal,
                    onChanged: (val) => _onSymptomCheck(sym, val),
                  ),
                  Text(sym, style: const TextStyle(fontSize: 12)),
                ],
              );
            }).toList(),
          ),
          if (isOtherSelected) ...[
            const SizedBox(height: 8),
            TextField(
              controller: otherSymptomsCtrl,
              decoration: const InputDecoration(
                labelText: 'Specify Other Symptoms',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              ),
            ),
          ],
          if (errorMessage.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              errorMessage,
              style: const TextStyle(fontSize: 12, color: AppColors.error, fontWeight: FontWeight.bold),
            ),
          ],
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 130,
              child: AppPrimaryButton(
                label: 'submit'.tr,
                height: 38,
                onPressed: _handleSubmit,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
