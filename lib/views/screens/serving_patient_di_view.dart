import 'package:digi_icu_flutter/controllers/serving_patient_controller.dart';
import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/views/widgets/app_dialog.dart';
import 'package:digi_icu_flutter/views/widgets/app_form_section_header.dart';
import 'package:digi_icu_flutter/views/widgets/app_labeled_text_field.dart';
import 'package:digi_icu_flutter/views/widgets/app_primary_button.dart';
import 'package:digi_icu_flutter/views/widgets/app_radio.dart';
import 'package:digi_icu_flutter/views/widgets/app_speech_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServingPatientDiView extends GetView<ServingPatientController> {
  const ServingPatientDiView({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.diagnosisText.value.isEmpty) {
        controller.fetchDiagnosisData();
      }
      if (controller.ecgReportImageUrl.value.isEmpty) {
        controller.fetchEcgReport();
      }
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Diagnosis Section
          Obx(() {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.medicalGray),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'diagnosis'.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    controller.diagnosisText.value.isNotEmpty
                        ? controller.diagnosisText.value
                        : 'no_data_available'.tr,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.navy,
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 12),

          // Primary Sub-Tabs Navigation (Notes, Self Notes, Event)
          Obx(() {
            return Row(
              children: [
                _buildTopTabButton('Notes', 'btn_notes'.tr),
                const SizedBox(width: 8),
                _buildTopTabButton('Self Notes', 'self_notes'.tr),
                const SizedBox(width: 8),
                _buildTopTabButton('Event', 'event'.tr),
              ],
            );
          }),
          const SizedBox(height: 12),

          // Primary Sub-Tab View Container
          Obx(() {
            switch (controller.selectedTopDiTab.value) {
              case 'Notes':
                return _buildNotesView();
              case 'Self Notes':
                return _buildSelfNotesView();
              case 'Event':
                return _buildEventView();
              default:
                return _buildNotesView();
            }
          }),

          const Divider(height: 24, thickness: 1, color: AppColors.medicalGray),

          // Secondary Sub-Tabs Navigation (ECG, Target BP, TMT)
          Obx(() {
            return Row(
              children: [
                _buildBottomTabButton('ECG', 'ecg_tab'.tr),
                const SizedBox(width: 8),
                _buildBottomTabButton('Target BP', 'target_bp'.tr),
                const SizedBox(width: 8),
                _buildBottomTabButton('TMT', 'tmt'.tr),
              ],
            );
          }),
          const SizedBox(height: 12),

          // Secondary Sub-Tab View Container
          Obx(() {
            switch (controller.selectedBottomDiTab.value) {
              case 'ECG':
                return _buildEcgView(context);
              case 'Target BP':
                return _buildTargetBpView();
              case 'TMT':
                return _buildTmtView();
              default:
                return _buildEcgView(context);
            }
          }),
        ],
      ),
    );
  }

  Widget _buildTopTabButton(String tabKey, String label) {
    final isSelected = controller.selectedTopDiTab.value == tabKey;
    final bg = isSelected ? AppColors.warning : AppColors.teal;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.selectedTopDiTab.value = tabKey,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomTabButton(String tabKey, String label) {
    final isSelected = controller.selectedBottomDiTab.value == tabKey;
    final bg = isSelected ? AppColors.warning : AppColors.teal;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.selectedBottomDiTab.value = tabKey,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // Primary Sub-Tab 1: Patient Notes View
  // ==========================================
  Widget _buildNotesView() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.medicalGray),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => controller.showRecentNotesDialog(),
                child: Text(
                  'recent_notes'.tr,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blue,
                  ),
                ),
              ),
              Obx(() {
                return AppPrimaryButton(
                  label: 'submit'.tr,
                  width: 105,
                  height: 36,
                  labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.white),
                  isLoading: controller.isLoadingDi.value,
                  onPressed: () => controller.submitPatientNote(),
                );
              }),
            ],
          ),
          const SizedBox(height: 12),
          AppSpeechInputWidget(
            controller: controller.patientNoteController,
            label: 'btn_notes'.tr,
            hintText: 'type_or_speak_notes'.tr,
            maxLines: 3,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton(
              onPressed: () => controller.fetchNoteTemplates(),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.teal),
              ),
              child: Text(
                'template'.tr,
                style: const TextStyle(color: AppColors.teal),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // Primary Sub-Tab 2: Self Notes View
  // ==========================================
  Widget _buildSelfNotesView() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.medicalGray),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => controller.showSelfNotesDialog(),
                child: Text(
                  'view_all'.tr,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blue,
                  ),
                ),
              ),
              Obx(() {
                return AppPrimaryButton(
                  label: 'submit'.tr,
                  width: 105,
                  height: 36,
                  labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.white),
                  isLoading: controller.isLoadingDi.value,
                  onPressed: () => controller.submitSelfNote(),
                );
              }),
            ],
          ),
          const SizedBox(height: 12),
          AppSpeechInputWidget(
            controller: controller.selfNoteController,
            label: 'myself_notes'.tr,
            hintText: 'type_or_speak_notes'.tr,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  // ==========================================
  // Primary Sub-Tab 3: Event View
  // ==========================================
  Widget _buildEventView() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.medicalGray),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => controller.showEventsDetailDialog(),
                child: Text(
                  'view_all'.tr,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blue,
                  ),
                ),
              ),
              Obx(() {
                return AppPrimaryButton(
                  label: 'submit'.tr,
                  width: 105,
                  height: 36,
                  labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.white),
                  isLoading: controller.isLoadingDi.value,
                  onPressed: () => controller.submitEvent(),
                );
              }),
            ],
          ),
          const SizedBox(height: 12),

          // Event Selection Radio Group
          const AppFormSectionHeader(title: 'Event Selection'),
          Obx(() {
            return RadioGroup<String>(
              groupValue: controller.eventType.value,
              onChanged: (val) {
                if (val != null) {
                  controller.eventType.value = val;
                }
              },
              child: Column(
                children: [
                  AppRadioListTile<String>(
                    value: 'None',
                    title: Text('none'.tr),
                  ),
                  AppRadioListTile<String>(
                    value: 'Hospitalisation',
                    title: Text('hospitalization'.tr),
                  ),
                  AppRadioListTile<String>(
                    value: 'Non-Hospitalisation',
                    title: Text('non_hospitalization'.tr),
                  ),
                  AppRadioListTile<String>(
                    value: 'Death',
                    title: Text('death'.tr),
                  ),
                ],
              ),
            );
          }),

          // Hospitalisation Options
          Obx(() {
            if (controller.eventType.value != 'Hospitalisation') {
              return const SizedBox.shrink();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 4,
                  children: [
                    _buildCheckbox('MI', controller.cbMI),
                    _buildCheckbox('COA', controller.cbCOA),
                    _buildCheckbox('Stroke', controller.cbStroke),
                    _buildCheckbox('Ratinol', controller.cbRatinol),
                    _buildCheckbox('Hypoglycemia', controller.cbHypoglycemia),
                    _buildCheckbox('Hypotension', controller.cbHypotension),
                    _buildCheckbox('DKA', controller.cbDKA),
                    _buildCheckbox('Acc. HTN', controller.cbRegurgitation),
                    _buildCheckbox('PIH', controller.cbPIH),
                    _buildCheckbox('ICH', controller.cbICH),
                    _buildCheckbox('AkI', controller.cbAkI),
                    _buildCheckbox('other'.tr, controller.cbHospitalizationOther),
                  ],
                ),
                if (controller.cbHospitalizationOther.value) ...[
                  const SizedBox(height: 8),
                  AppLabeledTextField(
                    label: 'other'.tr,
                    controller: controller.hospitalizationOtherController,
                  ),
                ],
              ],
            );
          }),

          // Non-Hospitalisation Options
          Obx(() {
            if (controller.eventType.value != 'Non-Hospitalisation') {
              return const SizedBox.shrink();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 4,
                  children: [
                    _buildCheckbox('Postural Hypotension', controller.cbPostural),
                    _buildCheckbox('SVT', controller.cbSVT),
                    _buildCheckbox('Bleeding', controller.cbBleeding),
                    _buildCheckbox('other'.tr, controller.cbNonHospOther),
                  ],
                ),
                if (controller.cbNonHospOther.value) ...[
                  const SizedBox(height: 8),
                  AppLabeledTextField(
                    label: 'other'.tr,
                    controller: controller.nonHospOtherController,
                  ),
                ],
              ],
            );
          }),

          // Death Options
          Obx(() {
            if (controller.eventType.value != 'Death') {
              return const SizedBox.shrink();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                RadioGroup<String>(
                  groupValue: controller.deathType.value,
                  onChanged: (val) {
                    if (val != null) {
                      controller.deathType.value = val;
                    }
                  },
                  child: Column(
                    children: [
                      AppRadioListTile<String>(
                        value: 'Sudden death noncardiac',
                        title: Text('sudden_death_noncardiac'.tr),
                      ),
                      AppRadioListTile<String>(
                        value: 'Sudden death cardiac',
                        title: Text('sudden_death_cardiac'.tr),
                      ),
                      AppRadioListTile<String>(
                        value: 'All htn',
                        title: Text('all_htn'.tr),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),

          const SizedBox(height: 16),
          // Compliance & Lifestyle Section
          AppFormSectionHeader(title: 'compilation'.tr),
          const SizedBox(height: 8),

          // Medicine Effect
          Text(
            'medicine_effect'.tr,
            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy),
          ),
          Obx(() {
            return RadioGroup<String>(
              groupValue: controller.medicinesEffect.value,
              onChanged: (val) {
                if (val != null) controller.medicinesEffect.value = val;
              },
              child: Wrap(
                spacing: 8,
                children: [
                  _buildInlineRadio('Good', 'good'.tr, controller.medicinesEffect),
                  _buildInlineRadio('Intermittent', 'intermittent'.tr, controller.medicinesEffect),
                  _buildInlineRadio('NonCompliant', 'non_compliant'.tr, controller.medicinesEffect),
                  _buildInlineRadio('NA', 'na'.tr, controller.medicinesEffect),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),

          // Asked Investigation
          Text(
            'asked_investigate'.tr,
            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy),
          ),
          Obx(() {
            return RadioGroup<String>(
              groupValue: controller.askedInvestigations.value,
              onChanged: (val) {
                if (val != null) controller.askedInvestigations.value = val;
              },
              child: Wrap(
                spacing: 8,
                children: [
                  _buildInlineRadio('Yes', 'yes'.tr, controller.askedInvestigations),
                  _buildInlineRadio('No', 'no'.tr, controller.askedInvestigations),
                  _buildInlineRadio('Non Affording', 'non_afford'.tr, controller.askedInvestigations),
                  _buildInlineRadio('NA', 'na'.tr, controller.askedInvestigations),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),

          // Salt Reduction
          Text(
            'salt_reduce'.tr,
            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy),
          ),
          Obx(() {
            return RadioGroup<String>(
              groupValue: controller.saltReduction.value,
              onChanged: (val) {
                if (val != null) controller.saltReduction.value = val;
              },
              child: Row(
                children: [
                  _buildInlineRadio('Yes', 'yes'.tr, controller.saltReduction),
                  const SizedBox(width: 16),
                  _buildInlineRadio('No', 'no'.tr, controller.saltReduction),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),

          // Exercise
          Text(
            'exercise'.tr,
            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy),
          ),
          Obx(() {
            return RadioGroup<String>(
              groupValue: controller.exercise.value,
              onChanged: (val) {
                if (val != null) controller.exercise.value = val;
              },
              child: Row(
                children: [
                  _buildInlineRadio('Yes', 'yes'.tr, controller.exercise),
                  const SizedBox(width: 16),
                  _buildInlineRadio('No', 'no'.tr, controller.exercise),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ==========================================
  // Secondary Sub-Tab 1: ECG View
  // ==========================================
  Widget _buildEcgView(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.medicalGray),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => controller.showEcgDialog(),
                child: Text(
                  'view_all'.tr,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blue,
                  ),
                ),
              ),
              Obx(() {
                return AppPrimaryButton(
                  label: 'submit'.tr,
                  width: 105,
                  height: 36,
                  labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.white),
                  isLoading: controller.isLoadingDi.value,
                  onPressed: () => controller.submitEcg(),
                );
              }),
            ],
          ),
          const SizedBox(height: 12),

          // Report Image Preview
          Obx(() {
            if (controller.ecgReportImageUrl.value.isEmpty) {
              return const SizedBox.shrink();
            }
            return Container(
              height: 150,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.medicalGray),
                borderRadius: BorderRadius.circular(6),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  controller.ecgReportImageUrl.value,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Center(child: Icon(Icons.broken_image, color: AppColors.medicalGray)),
                ),
              ),
            );
          }),

          // Rhythm Dropdown
          Text(
            'rhythm'.tr,
            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy),
          ),
          const SizedBox(height: 4),
          Obx(() {
            return DropdownButtonFormField<String>(
              initialValue: controller.ecgRhythm.value,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              items: ['Sinus', 'AF', 'SVT', 'CHB', '1st HB', '2nd HB']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) {
                if (val != null) controller.ecgRhythm.value = val;
              },
            );
          }),
          const SizedBox(height: 12),

          // ST Segment Dropdown
          Text(
            'st_segment'.tr,
            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy),
          ),
          const SizedBox(height: 4),
          Obx(() {
            return DropdownButtonFormField<String>(
              initialValue: controller.stSegment.value,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              items: ['Normal', 'Elevated', 'Depressed']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) {
                if (val != null) {
                  controller.stSegment.value = val;
                  if (val == 'Elevated') {
                    controller.stSegmentLevel.value = 'Infe';
                  } else if (val == 'Depressed') {
                    controller.stSegmentLevel.value = 'Infe';
                  } else {
                    controller.stSegmentLevel.value = 'Select…';
                  }
                }
              },
            );
          }),

          // ST Level Sub-Dropdown
          Obx(() {
            if (controller.stSegment.value == 'Normal') {
              return const SizedBox.shrink();
            }
            final isElevated = controller.stSegment.value == 'Elevated';
            final options = isElevated
                ? ['Select…', 'Infe', 'Ante', 'Lateral', 'early repolarisation']
                : ['Select…', 'Infe', 'Ante', 'Lateral', 'Tschemic', 'Lv strain', 'Physiologic', 'invenile'];

            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: DropdownButtonFormField<String>(
                initialValue: options.contains(controller.stSegmentLevel.value)
                    ? controller.stSegmentLevel.value
                    : options.first,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                items: options
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) controller.stSegmentLevel.value = val;
                },
              ),
            );
          }),
          const SizedBox(height: 12),

          // Small Boxes Input
          AppLabeledTextField(
            label: 'small_boxes'.tr,
            controller: controller.sv2Rv5Controller,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),

          // ECG Impression Dropdown
          Text(
            'ecg_impression'.tr,
            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy),
          ),
          const SizedBox(height: 4),
          Obx(() {
            final impressions = [
              'Normal',
              'Abnormal',
              'Abnormal, IHD',
              'Abnormal Arrythmia',
              "Can't interprete",
              'LVH',
              'LVH with Strain',
              'LVH, Significant ST T changes',
              'Non significant ST T changes',
              'Significant ST T changes s/ o ischemia',
              'Other',
            ];
            return DropdownButtonFormField<String>(
              isExpanded: true,
              initialValue: impressions.contains(controller.ecgImpression.value)
                  ? controller.ecgImpression.value
                  : impressions.first,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              items: impressions
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e, overflow: TextOverflow.ellipsis),
                      ))
                  .toList(),
              onChanged: (val) {
                if (val != null) controller.ecgImpression.value = val;
              },
            );
          }),

          // Other Impression Text Input
          Obx(() {
            if (controller.ecgImpression.value != 'Other') {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: AppLabeledTextField(
                label: 'other_interpretation'.tr,
                controller: controller.otherInterpretationController,
              ),
            );
          }),
        ],
      ),
    );
  }

  // ==========================================
  // Secondary Sub-Tab 2: Target BP View
  // ==========================================
  Widget _buildTargetBpView() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.medicalGray),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => controller.showBpDialog(),
                child: Text(
                  'view_all'.tr,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blue,
                  ),
                ),
              ),
              Obx(() {
                return AppPrimaryButton(
                  label: 'submit'.tr,
                  width: 105,
                  height: 36,
                  labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.white),
                  isLoading: controller.isLoadingDi.value,
                  onPressed: () => controller.submitTargetBp(),
                );
              }),
            ],
          ),
          const SizedBox(height: 12),
          AppLabeledTextField(
            label: 'systolic'.tr,
            controller: controller.systolicController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          AppLabeledTextField(
            label: 'diastolic'.tr,
            controller: controller.diastolicController,
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

  // ==========================================
  // Secondary Sub-Tab 3: TMT View
  // ==========================================
  Widget _buildTmtView() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.medicalGray),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  AppDialog.show(
                    title: 'tmt'.tr,
                    body: Text(
                      'Result: ${controller.tmtResult.value}\nMETS: ${controller.metsController.text}',
                      style: const TextStyle(color: AppColors.navy),
                    ),
                  );
                },
                child: Text(
                  'view_all'.tr,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blue,
                  ),
                ),
              ),
              Obx(() {
                return AppPrimaryButton(
                  label: 'submit'.tr,
                  width: 105,
                  height: 36,
                  labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.white),
                  isLoading: controller.isLoadingDi.value,
                  onPressed: () => controller.submitTmt(),
                );
              }),
            ],
          ),
          const SizedBox(height: 12),

          // TMT Result Radio Group
          Text(
            'result'.tr,
            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy),
          ),
          Obx(() {
            return RadioGroup<String>(
              groupValue: controller.tmtResult.value,
              onChanged: (val) {
                if (val != null) controller.tmtResult.value = val;
              },
              child: Column(
                children: [
                  AppRadioListTile<String>(
                    value: 'Positive',
                    title: Text('positive'.tr),
                  ),
                  AppRadioListTile<String>(
                    value: 'Negative',
                    title: Text('negative'.tr),
                  ),
                  AppRadioListTile<String>(
                    value: 'Inconclusive',
                    title: Text('inconclusive'.tr),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 12),

          // METS Input
          AppLabeledTextField(
            label: 'mets'.tr,
            controller: controller.metsController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),

          // Other Input
          AppSpeechInputWidget(
            controller: controller.metOtherController,
            label: 'other'.tr,
            hintText: 'type_or_speak_notes'.tr,
          ),
        ],
      ),
    );
  }

  // Helper Widget: Checkbox
  Widget _buildCheckbox(String label, RxBool valueObs) {
    return Obx(() {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: valueObs.value,
            activeColor: AppColors.teal,
            onChanged: (val) => valueObs.value = val ?? false,
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: AppColors.navy),
          ),
        ],
      );
    });
  }

  // Helper Widget: Inline Radio
  Widget _buildInlineRadio(String val, String label, RxString selectedObs) {
    return GestureDetector(
      onTap: () => selectedObs.value = val,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppRadio<String>(value: val),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: AppColors.navy),
          ),
        ],
      ),
    );
  }
}
