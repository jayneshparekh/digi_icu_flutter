import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/views/widgets/app_dialog.dart';
import 'package:digi_icu_flutter/views/widgets/app_radio.dart';
import 'package:digi_icu_flutter/views/widgets/app_rich_editor_dialog.dart';
import 'package:digi_icu_flutter/views/widgets/app_speech_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/discharge_summary_controller.dart';
import '../../models/response/doctor/ipd_investigation_response.dart';
import 'serving_patient_prescription_view.dart';

class DischargeSummaryScreen extends GetView<DischargeSummaryController> {
  const DischargeSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        backgroundColor: AppColors.teal,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Get.back(),
        ),
        title: Obx(() {
          final genderDisplay =
              controller.gender.value.toLowerCase() == 'male'
                  ? 'M'
                  : (controller.gender.value.toLowerCase() == 'female'
                      ? 'F'
                      : 'O');
          final ageText = controller.age.value.isNotEmpty
              ? '${controller.age.value}/'
              : '';
          final subTitle =
              '${controller.patientName.value} / $ageText$genderDisplay';

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'discharge_summary'.tr,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (controller.patientName.value.isNotEmpty)
                Text(
                  subTitle,
                  style: TextStyle(
                    color: AppColors.white.withValues(alpha: 0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
            ],
          );
        }),
      ),
      body: Column(
        children: [
          // Top Action Tabs Row (Prepare DS, Upload DS, Death Summary)
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Obx(() {
              final active = controller.activeTab.value;
              final isPrepareEnabled = controller.isPrepareDsEnabled.value;

              return Row(
                children: [
                  Expanded(
                    child: _buildTopTab(
                      label: 'prepare_ds'.tr,
                      isSelected: active == 'prepare',
                      isEnabled: isPrepareEnabled,
                      onTap: controller.onPrepareDsTabSelected,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTopTab(
                      label: 'upload_ds'.tr,
                      isSelected: active == 'upload',
                      onTap: () => controller.onUploadDsTabSelected(context),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTopTab(
                      label: 'death_summary'.tr,
                      isSelected: active == 'death',
                      onTap: () => controller.setTab('death'),
                    ),
                  ),
                ],
              );
            }),
          ),
          const Divider(height: 1, thickness: 1, color: AppColors.medicalGray),

          // Main Tab Content
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.teal),
                );
              }

              final active = controller.activeTab.value;
              if (active == 'prepare') {
                return _buildPrepareDsContent(context);
              } else if (active == 'upload') {
                return _buildUploadDsContent(context);
              } else {
                return Center(
                  child: Text(
                    '${'death_summary'.tr} (${'coming_soon'.tr})',
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.coolGray,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTopTab({
    required String label,
    required bool isSelected,
    bool isEnabled = true,
    required VoidCallback onTap,
  }) {
    Color bgColor = isSelected ? AppColors.warning : AppColors.teal;
    if (!isEnabled && !isSelected) {
      bgColor = AppColors.teal.withValues(alpha: 0.45);
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        height: 38,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(6),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isEnabled
                ? AppColors.white
                : AppColors.white.withValues(alpha: 0.7),
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildUploadDsContent(BuildContext context) {
    return Obx(() {
      if (controller.isUploadingPdf.value) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: AppColors.teal),
              const SizedBox(height: 16),
              Text(
                'ds_uploading_pdf'.tr,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.navy,
                ),
              ),
            ],
          ),
        );
      }

      final hasPdf = controller.dischargePath.value.isNotEmpty;

      if (hasPdf) {
        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 30),
                      // PDF card surface
                      Material(
                        color: AppColors.white,
                        elevation: 3,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          onTap: controller.openPdf,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 32,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.teal,
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppColors.teal.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.picture_as_pdf,
                                    size: 56,
                                    color: AppColors.teal,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  controller.dischargePath.value,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.navy,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'ds_pdf_view_hint'.tr,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.coolGray,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Share Button
                      Center(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.teal,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          onPressed: controller.sharePdf,
                          icon: const Icon(Icons.share, size: 18),
                          label: Text(
                            'ds_share_btn'.tr,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Floating Action Button at bottom right to add/replace PDF
            Positioned(
              right: 20,
              bottom: 20,
              child: FloatingActionButton(
                backgroundColor: AppColors.teal,
                foregroundColor: AppColors.white,
                elevation: 4,
                onPressed: () => controller.onAddOrReplacePdfClicked(context),
                tooltip: 'ds_upload_pdf_btn'.tr,
                child: const Icon(Icons.add),
              ),
            ),
          ],
        );
      }

      // Empty State (No PDF uploaded yet)
      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Container(
              padding: const EdgeInsets.all(28.0),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.medicalGray),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.navy.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: AppColors.lightGray,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.upload_file_outlined,
                      size: 52,
                      color: AppColors.coolGray,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'ds_no_pdf_uploaded'.tr,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ds_upload_pdf_desc'.tr,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.coolGray,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.teal,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () => controller.onAddOrReplacePdfClicked(context),
                    icon: const Icon(Icons.file_upload_outlined, size: 20),
                    label: Text(
                      'ds_upload_pdf_btn'.tr,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildPrepareDsContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Diagnosis Section
          _buildSectionCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'diagnosis_label'.tr,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.navy,
                  ),
                ),
                const Icon(
                  Icons.info_outline,
                  size: 16,
                  color: AppColors.coolGray,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Obx(() {
                    return Text(
                      controller.diagnosisText.value,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.navy,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }),
                ),
                IconButton(
                  icon: SvgPicture.asset(
                    'assets/icons/svg/ic_add_circle.svg',
                    width: 26,
                    height: 26,
                    colorFilter: const ColorFilter.mode(
                      AppColors.teal,
                      BlendMode.srcIn,
                    ),
                  ),
                  onPressed: controller.openDiagnosisScreen,
                  tooltip: 'diagnosis'.tr,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 2. Patient Condition Section
          _buildSectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'ds_patient_condition_label'.tr,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.info_outline,
                      size: 16,
                      color: AppColors.coolGray,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Obx(() {
                  return RadioGroup<String>(
                    groupValue: controller.patientCondition.value,
                    onChanged: (val) {
                      if (val != null) {
                        controller.patientCondition.value = val;
                      }
                    },
                    child: Row(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const AppRadio<String>(value: 'Stable'),
                            const SizedBox(width: 4),
                            Text(
                              'stable'.tr,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.navy,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 24),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const AppRadio<String>(value: 'Unstable'),
                            const SizedBox(width: 4),
                            Text(
                              'unstable'.tr,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.navy,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 3. Past History Section
          _buildSectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'ds_past_history_label'.tr,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.info_outline,
                      size: 16,
                      color: AppColors.coolGray,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                AppSpeechInputWidget(
                  controller: controller.pastHistoryController,
                  hintText: 'past_history_hint'.tr,
                  maxLines: 3,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 4. Symptoms Section
          _buildSectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'ds_symptoms_label'.tr,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.info_outline,
                      size: 16,
                      color: AppColors.coolGray,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildSymptomsGrid(),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 5. At Presentation Complaints Section
          _buildSectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'ds_at_presentation_complaints_label'.tr,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.info_outline,
                      size: 16,
                      color: AppColors.coolGray,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                AppSpeechInputWidget(
                  controller: controller.atPresentationComplaintsController,
                  hintText: 'ds_at_presentation_complaints_hint'.tr,
                  maxLines: 3,
                  onChanged: (val) {
                    controller.syncSymptomCheckboxesFromText(val);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 6. Vitals At Presentation Section
          _buildVitalsAtPresentationSection(),
          const SizedBox(height: 12),

          // 7. Vitals At Discharge Section
          _buildVitalsAtDischargeSection(),
          const SizedBox(height: 12),

          // 8. Investigations Section
          _buildInvestigationsSection(),
          const SizedBox(height: 12),

          // 9. ECG Section
          _buildEcgSection(),
          const SizedBox(height: 12),

          // 10. Surgical Procedures Section
          _buildSurgicalProceduresSection(),
          const SizedBox(height: 12),

          // 11. Discharge Type Section
          _buildDischargeTypeSection(),
          const SizedBox(height: 12),

          // 12. Course In The Hospital Section
          _buildCourseInHospitalSection(),
          const SizedBox(height: 12),

          // 13. Advice at Discharge Section
          _buildAdviceAtDischargeSection(),
          const SizedBox(height: 12),

          // 14. Discharge Rx Section
          _buildDischargeRxSection(context),
          const SizedBox(height: 12),

          // 15. Follow Up Section
          _buildFollowUpSection(context),
          const SizedBox(height: 12),

          // 16. Institute Doctors Section
          _buildInstituteDoctorsSection(),
          const SizedBox(height: 12),

          // 17. Prepared By & Footer Actions (Print Draft, Save Draft, Final Discharge Summary)
          _buildPreparedByAndFooterSection(context),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.medicalGray),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSymptomsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 700
            ? 4
            : (constraints.maxWidth > 480 ? 3 : 2);
        final childAspectRatio = constraints.maxWidth > 700
            ? 4.2
            : (constraints.maxWidth > 480 ? 3.5 : 3.8);

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: 8,
            mainAxisSpacing: 6,
          ),
          itemCount: controller.standardSymptoms.length,
          itemBuilder: (context, index) {
            final symptom = controller.standardSymptoms[index];
            return Obx(() {
              final isChecked = controller.selectedSymptoms.contains(symptom);
              return InkWell(
                onTap: () => controller.toggleSymptom(symptom, !isChecked),
                borderRadius: BorderRadius.circular(4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: isChecked,
                      activeColor: AppColors.teal,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                      onChanged: (val) {
                        controller.toggleSymptom(symptom, val ?? false);
                      },
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        _getSymptomLabel(symptom),
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: AppColors.navy,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ],
                ),
              );
            });
          },
        );
      },
    );
  }

  Widget _buildVitalsAtPresentationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 1,
          color: AppColors.medicalGray,
          margin: const EdgeInsets.symmetric(vertical: 6),
        ),
        const SizedBox(height: 6),
        Text(
          'vitals_at_presentation_label'.tr,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.teal,
          ),
        ),
        const SizedBox(height: 10),
        _buildSectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BP Row
              Row(
                children: [
                  Expanded(
                    child: _buildNumberInputField(
                      label: 'systolic_bp_hint'.tr,
                      textController: controller.presSystolicController,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildNumberInputField(
                      label: 'diastolic_bp_hint'.tr,
                      textController: controller.presDiastolicController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Pulse & SPO2 Row
              Row(
                children: [
                  Expanded(
                    child: _buildNumberInputField(
                      label: 'pulse_rate_hint'.tr,
                      textController: controller.presPulseController,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildNumberInputField(
                      label: 'spo2_room_air_hint'.tr,
                      textController: controller.presSpo2Controller,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // CVS
              _buildExamSystemSection(
                title: 'cvs_label'.tr,
                selectedVal: controller.presCvs,
                onSelect: controller.setPresCvs,
                textController: controller.presCvsController,
              ),
              const SizedBox(height: 12),

              // RS
              _buildExamSystemSection(
                title: 'rs_label'.tr,
                selectedVal: controller.presRs,
                onSelect: controller.setPresRs,
                textController: controller.presRsController,
              ),
              const SizedBox(height: 12),

              // CNS
              _buildExamSystemSection(
                title: 'cns_label'.tr,
                selectedVal: controller.presCns,
                onSelect: controller.setPresCns,
                textController: controller.presCnsController,
              ),
              const SizedBox(height: 12),

              // PA
              _buildExamSystemSection(
                title: 'pa_label'.tr,
                selectedVal: controller.presPa,
                onSelect: controller.setPresPa,
                textController: controller.presPaController,
              ),
              const SizedBox(height: 12),

              // Other Present Vitals
              AppSpeechInputWidget(
                controller: controller.presOtherVitalsController,
                hintText: 'other_present_vitals_hint'.tr,
                maxLines: 2,
              ),
              const SizedBox(height: 14),

              // Volume
              _buildRadioOptionRow(
                title: 'volume_label'.tr,
                selectedVal: controller.presVolume,
                options: controller.volumeOptions,
                onSelect: (val) => controller.presVolume.value = val,
              ),
              const SizedBox(height: 12),

              // Pallor
              _buildRadioOptionRow(
                title: 'pallor_label'.tr,
                selectedVal: controller.presPallor,
                options: controller.signOptions,
                onSelect: (val) => controller.presPallor.value = val,
              ),
              const SizedBox(height: 12),

              // Icterus
              _buildRadioOptionRow(
                title: 'icterus_label'.tr,
                selectedVal: controller.presIcterus,
                options: controller.signOptions,
                onSelect: (val) => controller.presIcterus.value = val,
              ),
              const SizedBox(height: 12),

              // Cyanosis
              _buildRadioOptionRow(
                title: 'cyanosis_label'.tr,
                selectedVal: controller.presCyanosis,
                options: controller.signOptions,
                onSelect: (val) => controller.presCyanosis.value = val,
              ),
              const SizedBox(height: 14),

              // GC
              _buildGcGridSection(
                title: 'gc_label'.tr,
                selectedVal: controller.presGc,
                onSelect: (val) => controller.presGc.value = val,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVitalsAtDischargeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 1,
          color: AppColors.medicalGray,
          margin: const EdgeInsets.symmetric(vertical: 6),
        ),
        const SizedBox(height: 6),
        Text(
          'vitals_at_discharge_label'.tr,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.teal,
          ),
        ),
        const SizedBox(height: 10),
        _buildSectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BP Row
              Row(
                children: [
                  Expanded(
                    child: _buildNumberInputField(
                      label: 'systolic_bp_hint'.tr,
                      textController: controller.discSystolicController,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildNumberInputField(
                      label: 'diastolic_bp_hint'.tr,
                      textController: controller.discDiastolicController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Pulse & SPO2 Row
              Row(
                children: [
                  Expanded(
                    child: _buildNumberInputField(
                      label: 'pulse_rate_hint'.tr,
                      textController: controller.discPulseController,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildNumberInputField(
                      label: 'spo2_room_air_hint'.tr,
                      textController: controller.discSpo2Controller,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // CVS
              _buildExamSystemSection(
                title: 'cvs_label'.tr,
                selectedVal: controller.discCvs,
                onSelect: controller.setDiscCvs,
                textController: controller.discCvsController,
              ),
              const SizedBox(height: 12),

              // RS
              _buildExamSystemSection(
                title: 'rs_label'.tr,
                selectedVal: controller.discRs,
                onSelect: controller.setDiscRs,
                textController: controller.discRsController,
              ),
              const SizedBox(height: 12),

              // CNS
              _buildExamSystemSection(
                title: 'cns_label'.tr,
                selectedVal: controller.discCns,
                onSelect: controller.setDiscCns,
                textController: controller.discCnsController,
              ),
              const SizedBox(height: 12),

              // PA
              _buildExamSystemSection(
                title: 'pa_label'.tr,
                selectedVal: controller.discPa,
                onSelect: controller.setDiscPa,
                textController: controller.discPaController,
              ),
              const SizedBox(height: 12),

              // Other Discharge Vitals
              AppSpeechInputWidget(
                controller: controller.discOtherVitalsController,
                hintText: 'other_discharge_vitals_hint'.tr,
                maxLines: 2,
              ),
              const SizedBox(height: 14),

              // Volume
              _buildRadioOptionRow(
                title: 'volume_label'.tr,
                selectedVal: controller.discVolume,
                options: controller.volumeOptions,
                onSelect: (val) => controller.discVolume.value = val,
              ),
              const SizedBox(height: 12),

              // Pallor
              _buildRadioOptionRow(
                title: 'pallor_label'.tr,
                selectedVal: controller.discPallor,
                options: controller.signOptions,
                onSelect: (val) => controller.discPallor.value = val,
              ),
              const SizedBox(height: 12),

              // Icterus
              _buildRadioOptionRow(
                title: 'icterus_label'.tr,
                selectedVal: controller.discIcterus,
                options: controller.signOptions,
                onSelect: (val) => controller.discIcterus.value = val,
              ),
              const SizedBox(height: 12),

              // Cyanosis
              _buildRadioOptionRow(
                title: 'cyanosis_label'.tr,
                selectedVal: controller.discCyanosis,
                options: controller.signOptions,
                onSelect: (val) => controller.discCyanosis.value = val,
              ),
              const SizedBox(height: 14),

              // GC
              _buildGcGridSection(
                title: 'gc_label'.tr,
                selectedVal: controller.discGc,
                onSelect: (val) => controller.discGc.value = val,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNumberInputField({
    required String label,
    required TextEditingController textController,
  }) {
    return TextFormField(
      controller: textController,
      keyboardType: TextInputType.number,
      style: const TextStyle(
        fontSize: 13,
        color: AppColors.navy,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontSize: 12,
          color: AppColors.coolGray,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColors.medicalGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColors.medicalGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: AppColors.teal, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildExamSystemSection({
    required String title,
    required RxString selectedVal,
    required Function(String) onSelect,
    required TextEditingController textController,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.info_outline,
              size: 14,
              color: AppColors.coolGray,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Obx(() {
                return RadioGroup<String>(
                  groupValue: selectedVal.value,
                  onChanged: (val) {
                    if (val != null) {
                      onSelect(val);
                    }
                  },
                  child: Row(
                    children: controller.nadOtherOptions.map((opt) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 14.0),
                        child: InkWell(
                          onTap: () => onSelect(opt),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppRadio<String>(value: opt),
                              const SizedBox(width: 3),
                              Text(
                                opt == 'NAD' ? 'nad'.tr : 'ds_other'.tr,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  color: AppColors.navy,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }),
            ),
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: textController,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.navy,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: AppColors.medicalGray),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: AppColors.medicalGray),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: AppColors.teal, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRadioOptionRow({
    required String title,
    required RxString selectedVal,
    required List<String> options,
    required Function(String) onSelect,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.info_outline,
              size: 14,
              color: AppColors.coolGray,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Obx(() {
          return RadioGroup<String>(
            groupValue: selectedVal.value,
            onChanged: (val) {
              if (val != null) {
                onSelect(val);
              }
            },
            child: Wrap(
              spacing: 12,
              runSpacing: 4,
              children: options.map((opt) {
                return InkWell(
                  onTap: () => onSelect(opt),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppRadio<String>(value: opt),
                      const SizedBox(width: 2),
                      Text(
                        _getOptionLabel(opt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.navy,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildGcGridSection({
    required String title,
    required RxString selectedVal,
    required Function(String) onSelect,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.info_outline,
              size: 14,
              color: AppColors.coolGray,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Obx(() {
          return RadioGroup<String>(
            groupValue: selectedVal.value,
            onChanged: (val) {
              if (val != null) {
                onSelect(val);
              }
            },
            child: Wrap(
              spacing: 10,
              runSpacing: 6,
              children: controller.gcOptions.map((opt) {
                return InkWell(
                  onTap: () => onSelect(opt),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppRadio<String>(value: opt),
                      const SizedBox(width: 2),
                      Text(
                        _getOptionLabel(opt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.navy,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        }),
      ],
    );
  }

  String _getOptionLabel(String opt) {
    switch (opt) {
      case 'Good':
        return 'gc_good'.tr;
      case 'Conscious':
        return 'gc_conscious'.tr;
      case 'Fair':
        return 'gc_fair'.tr;
      case 'Bad':
        return 'gc_bad'.tr;
      case 'Worst':
        return 'gc_worst'.tr;
      case 'Unconscious':
        return 'gc_unconscious'.tr;
      case 'Brought dead':
        return 'gc_brought_dead'.tr;
      case 'Low':
        return 'vol_low'.tr;
      case 'Feeble':
        return 'vol_feeble'.tr;
      case 'Not Palpable':
        return 'vol_not_palpable'.tr;
      case 'No':
        return 'no_opt'.tr;
      case 'Yes':
        return 'ds_yes_opt'.tr;
      case '+':
        return 'plus_opt'.tr;
      case '++':
        return 'double_plus_opt'.tr;
      default:
        return opt;
    }
  }

  String _getSymptomLabel(String symptom) {
    switch (symptom) {
      case 'Fever':
        return 'fever'.tr;
      case 'Chest Pain':
        return 'chest_pain'.tr;
      case 'Dyspnea':
        return 'dyspnea'.tr;
      case 'Cough':
        return 'cough'.tr;
      case 'Bodyache':
        return 'bodyache'.tr;
      case 'Giddiness':
        return 'giddiness'.tr;
      case 'Leg Pain':
        return 'leg_pain'.tr;
      case 'Headache':
        return 'headache'.tr;
      case 'Abdominal Pain':
        return 'abdominal_pain'.tr;
      case 'Vomitting':
        return 'vomitting'.tr;
      case 'Loose Motions':
        return 'loose_motions'.tr;
      case 'Asymptomatic':
        return 'asymptomatic'.tr;
      default:
        return symptom;
    }
  }

  String _getEcgLabel(String opt) {
    switch (opt) {
      case 'Normal':
        return 'ds_ecg_normal'.tr;
      case 'Abnormal':
        return 'ds_ecg_abnormal'.tr;
      case 'Not Available':
        return 'ds_ecg_na'.tr;
      default:
        return opt;
    }
  }

  String _getDischargeTypeLabel(String opt) {
    switch (opt) {
      case 'Regular':
        return 'ds_dt_regular'.tr;
      case 'On Request':
        return 'ds_dt_on_request'.tr;
      case 'Against Medical Advice':
        return 'ds_dt_ama'.tr;
      case 'Referred':
        return 'ds_dt_referred'.tr;
      default:
        return opt;
    }
  }

  Widget _buildInvestigationsSection() {
    return _buildSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'ds_investigations_label'.tr,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.info_outline,
                size: 16,
                color: AppColors.coolGray,
              ),
            ],
          ),
          const SizedBox(height: 8),
          AppSpeechInputWidget(
            controller: controller.investigationsController,
            hintText: 'ds_investigations_hint'.tr,
            maxLines: 3,
          ),
          Obx(() {
            if (controller.isLoadingInvestigations.value) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.teal,
                    ),
                  ),
                ),
              );
            }

            if (controller.inbetweenInvestigations.isEmpty) {
              return const SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.only(top: 14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ds_inbetween_investigations_desc'.tr,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.coolGray,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildInbetweenInvestigationsList(
                    controller.inbetweenInvestigations,
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildInbetweenInvestigationsList(List<IpdInvestigationItem> data) {
    const excludedTests = {
      'HCT(PCV)',
      'MCV',
      'MCH',
      'MCHC',
      'Neutrophils',
      'Lymphocytes',
      'Eosinophils',
      'Monocytes',
      'Basophil',
      'INDIRECT BILIRUBIN',
      'SGPT [A L T]',
      'SGOT [A S T]',
      'ALKALINE PHOSPHATASE',
      'TOTAL PROTIENS',
      'ALBUMIN',
      'GLOBULIN',
      'A/G RATIO',
      'Urea',
      'Electrolytes',
    };

    final Map<String, List<IpdInvestigationItem>> grouped = {};
    for (final item in data) {
      final key = '${item.category} (${item.created})';
      grouped.putIfAbsent(key, () => []).add(item);
    }

    final validEntries = grouped.entries.where((entry) {
      return entry.value.any((item) => !excludedTests.contains(item.testName));
    }).toList();

    if (validEntries.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: validEntries.map((entry) {
        final header = entry.key;
        final tests = entry.value
            .where((item) => !excludedTests.contains(item.testName))
            .toList();

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.medicalGray),
            boxShadow: [
              BoxShadow(
                color: AppColors.navy.withValues(alpha: 0.04),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                header,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(height: 6),
              const Divider(height: 1, color: AppColors.medicalGray),
              const SizedBox(height: 6),
              ...tests.map((test) {
                final testVal = double.tryParse(test.testValue) ?? 0.0;
                final fromRange = double.tryParse(test.fromRange) ?? 0.0;
                final toRange = double.tryParse(test.toRange) ?? 0.0;

                final isOutOfRange =
                    (fromRange != 0.0 || toRange != 0.0) &&
                    (testVal < fromRange || testVal > toRange);

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isOutOfRange
                        ? AppColors.warning.withValues(alpha: 0.18)
                        : AppColors.white.withValues(alpha: 0),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          test.testName,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.navy,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        test.testValue,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.navy,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEcgSection() {
    return _buildSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'ds_ecg_label'.tr,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.info_outline,
                size: 16,
                color: AppColors.coolGray,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Obx(() {
            return RadioGroup<String>(
              groupValue: controller.ecgSelection.value,
              onChanged: (val) {
                if (val != null) {
                  controller.ecgSelection.value = val;
                }
              },
              child: Wrap(
                spacing: 12,
                runSpacing: 6,
                children: controller.ecgOptions.map((opt) {
                  return InkWell(
                    onTap: () => controller.ecgSelection.value = opt,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppRadio<String>(value: opt),
                        const SizedBox(width: 2),
                        Text(
                          _getEcgLabel(opt),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.navy,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          }),
          Obx(() {
            if (controller.ecgSelection.value == 'Abnormal') {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: AppSpeechInputWidget(
                  controller: controller.ecgDetailsController,
                  hintText: 'ds_enter_details_hint'.tr,
                  maxLines: 2,
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildSurgicalProceduresSection() {
    return _buildSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'ds_surgical_procedures_label'.tr,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.info_outline,
                size: 16,
                color: AppColors.coolGray,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Obx(() {
            return RadioGroup<String>(
              groupValue: controller.surgicalProcedureSelection.value,
              onChanged: (val) {
                if (val != null) {
                  controller.surgicalProcedureSelection.value = val;
                }
              },
              child: Row(
                children: controller.yesNoOptions.map((opt) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: InkWell(
                      onTap: () =>
                          controller.surgicalProcedureSelection.value = opt,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppRadio<String>(value: opt),
                          const SizedBox(width: 2),
                          Text(
                            _getOptionLabel(opt),
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.navy,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          }),
          Obx(() {
            if (controller.surgicalProcedureSelection.value == 'Yes') {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  children: [
                    AppSpeechInputWidget(
                      controller: controller.surgeonNameController,
                      hintText: 'ds_enter_surgeon_name_hint'.tr,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 8),
                    AppSpeechInputWidget(
                      controller: controller.surgicalProcedureController,
                      hintText: 'ds_enter_surgical_procedure_hint'.tr,
                      maxLines: 3,
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildDischargeTypeSection() {
    return _buildSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'ds_discharge_type_label'.tr,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.info_outline,
                size: 16,
                color: AppColors.coolGray,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Obx(() {
            return RadioGroup<String>(
              groupValue: controller.dischargeTypeSelection.value,
              onChanged: (val) {
                if (val != null) {
                  controller.setDischargeType(val);
                }
              },
              child: Wrap(
                spacing: 12,
                runSpacing: 6,
                children: controller.dischargeTypeOptions.map((opt) {
                  return InkWell(
                    onTap: () => controller.setDischargeType(opt),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppRadio<String>(value: opt),
                        const SizedBox(width: 2),
                        Text(
                          _getDischargeTypeLabel(opt),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.navy,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCourseInHospitalSection() {
    return _buildSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'ds_course_in_hospital_label'.tr,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.info_outline,
                size: 16,
                color: AppColors.coolGray,
              ),
            ],
          ),
          const SizedBox(height: 8),
          AppSpeechInputWidget(
            controller: controller.courseInHospitalController,
            hintText: 'ds_course_in_hospital_hint'.tr,
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildAdviceAtDischargeSection() {
    return _buildSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'ds_advice_at_discharge_label'.tr,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.info_outline,
                size: 16,
                color: AppColors.coolGray,
              ),
            ],
          ),
          const SizedBox(height: 8),
          AppSpeechInputWidget(
            controller: controller.adviceAtDischargeController,
            hintText: 'ds_advice_at_discharge_hint'.tr,
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildDischargeRxSection(BuildContext context) {
    return _buildSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'ds_discharge_rx_label'.tr,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.info_outline,
                size: 16,
                color: AppColors.coolGray,
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.teal,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: () {
                  Get.to(
                    () => const ServingPatientPrescriptionView(),
                    arguments: {
                      'patientId': controller.patientId.value,
                      'bookingId': controller.appointmentId.value,
                      'appointmentId': controller.appointmentId.value,
                      'patientName': controller.patientName.value,
                      'age': controller.age.value,
                      'gender': controller.gender.value,
                      'mhcId': controller.mhcId.value,
                      'admitId': controller.admitId.value,
                      'openFrom': 'discharge',
                    },
                  );
                },
                child: Text(
                  'ds_add_rx'.tr,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.teal,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: () {
                  final lastManualRx = controller.dischargeRxList
                      .firstWhereOrNull((item) => item.isManual)
                      ?.manualRx;

                  AppRichEditorDialog.show(
                    initialHtml: lastManualRx,
                    onSave: (html) => controller.saveManualRx(content: html),
                  );
                },
                child: Text(
                  'ds_manual_rx'.tr,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Obx(() {
            if (controller.isLoadingDischargeRx.value) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.teal,
                    ),
                  ),
                ),
              );
            }

            if (controller.dischargeRxList.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'ds_no_prescriptions'.tr,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.coolGray,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              );
            }

            return Column(
              children: controller.dischargeRxList.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;

                if (item.isManual) {
                  return Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: AppColors.lightGray,
                          width: 1,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              AppRichEditorDialog.show(
                                initialHtml: item.manualRx,
                                manualRxId: item.id,
                                onSave: (html) => controller.saveManualRx(
                                  manualRxId: item.id,
                                  content: html,
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.lightGray,
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                          color: AppColors.medicalGray,
                                        ),
                                      ),
                                      child: Text(
                                        'ds_manual_rx'.tr,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.navy,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Icon(
                                      Icons.edit_outlined,
                                      size: 13,
                                      color: AppColors.coolGray,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _cleanHtmlTags(item.manualRx),
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.navy,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: AppColors.error,
                            size: 20,
                          ),
                          onPressed: () => _showDeleteRxConfirmation(
                            context,
                            item.id,
                          ),
                          tooltip: 'delete'.tr,
                        ),
                      ],
                    ),
                  );
                } else if (item.medicines.isNotEmpty) {
                  final med = item.medicines.first;
                  final medInfo = '${med.form} ${med.medicineName} ${med.dose}'
                      .trim();
                  if (med.medicineName.isEmpty || med.medicineName == 'null') {
                    return const SizedBox.shrink();
                  }

                  return Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: AppColors.lightGray,
                          width: 1,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${index + 1}. ',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.navy,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            medInfo,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.navy,
                            ),
                          ),
                        ),
                        if (item.frequency.isNotEmpty &&
                            item.frequency != 'null')
                          Expanded(
                            flex: 2,
                            child: Text(
                              item.frequency,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.coolGray,
                              ),
                            ),
                          ),
                        if (item.days.isNotEmpty && item.days != 'null')
                          Expanded(
                            flex: 2,
                            child: Text(
                              'ds_rx_days_count'.trParams({'days': item.days}),
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.coolGray,
                              ),
                            ),
                          ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: AppColors.error,
                            size: 20,
                          ),
                          onPressed: () => _showDeleteRxConfirmation(
                            context,
                            item.id,
                          ),
                          tooltip: 'delete'.tr,
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  void _showDeleteRxConfirmation(BuildContext context, String medicineId) {
    AppDialog.show(
      title: 'confirmation'.tr,
      body: Text(
        'ds_delete_prescription_confirm'.tr,
        style: const TextStyle(fontSize: 14, color: AppColors.navy),
      ),
      confirmLabel: 'ds_yes_opt'.tr,
      cancelLabel: 'no_opt'.tr,
      onConfirm: () {
        Get.back();
        controller.deleteDischargePrescription(medicineId);
      },
      onCancel: () => Get.back(),
    );
  }

  String _cleanHtmlTags(String html) {
    return html
        .replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  Widget _buildFollowUpSection(BuildContext context) {
    return _buildSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'ds_follow_up_label'.tr,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.navy,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.info_outline,
                size: 16,
                color: AppColors.coolGray,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Obx(() {
                  return RadioGroup<String>(
                    groupValue: controller.selectedFollowUpOption.value,
                    onChanged: (val) {
                      if (val != null) {
                        int days = 7;
                        if (val == '15 Days') days = 15;
                        if (val == '1 Month') days = 30;
                        if (val == '2 Month') days = 60;
                        controller.setFollowUpDays(val, days);
                      }
                    },
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 6,
                      children: controller.followUpDaysOptions.map((opt) {
                        int days = 7;
                        if (opt == '15 Days') days = 15;
                        if (opt == '1 Month') days = 30;
                        if (opt == '2 Month') days = 60;

                        return InkWell(
                          onTap: () => controller.setFollowUpDays(opt, days),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppRadio<String>(value: opt),
                              const SizedBox(width: 2),
                              Text(
                                _getFollowUpLabel(opt),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.navy,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }),
              ),
              const SizedBox(width: 8),
              Obx(() {
                final displayDate = controller.followUpDate.value.isNotEmpty
                    ? controller.followUpDate.value
                    : 'DD-MM-YYYY';

                return InkWell(
                  onTap: () async {
                    final now = DateTime.now();
                    DateTime initial = now.add(const Duration(days: 7));
                    if (controller.followUpDate.value.isNotEmpty) {
                      try {
                        initial = DateFormat('dd-MM-yyyy')
                            .parse(controller.followUpDate.value);
                      } catch (_) {}
                    }
                    if (initial.isBefore(now)) initial = now;

                    final picked = await showDatePicker(
                      context: context,
                      initialDate: initial,
                      firstDate: now,
                      lastDate: now.add(const Duration(days: 365)),
                      builder: (ctx, child) => Theme(
                        data: Theme.of(ctx).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: AppColors.teal,
                            onPrimary: AppColors.white,
                            onSurface: AppColors.navy,
                          ),
                        ),
                        child: child!,
                      ),
                    );

                    if (picked != null) {
                      controller.setManualFollowUpDate(picked);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.lightGray,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.medicalGray),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          displayDate,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: controller.followUpDate.value.isNotEmpty
                                ? AppColors.navy
                                : AppColors.coolGray,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: AppColors.coolGray,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  String _getFollowUpLabel(String opt) {
    switch (opt) {
      case '7 Days':
        return 'ds_follow_7_days'.tr;
      case '15 Days':
        return 'ds_follow_15_days'.tr;
      case '1 Month':
        return 'ds_follow_1_month'.tr;
      case '2 Month':
        return 'ds_follow_2_month'.tr;
      default:
        return opt;
    }
  }

  Widget _buildInstituteDoctorsSection() {
    return Obx(() {
      if (controller.instituteDoctors.isEmpty &&
          !controller.isLoadingInstituteDoctors.value) {
        return const SizedBox.shrink();
      }

      if (controller.isLoadingInstituteDoctors.value) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0),
          child: Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.teal,
              ),
            ),
          ),
        );
      }

      return _buildSectionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'ds_institute_doctors_label'.tr,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.info_outline,
                  size: 16,
                  color: AppColors.coolGray,
                ),
              ],
            ),
            const SizedBox(height: 8),
            LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth > 500 ? 2 : 1;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: crossAxisCount == 2 ? 4.5 : 6.0,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 4,
                  ),
                  itemCount: controller.instituteDoctors.length,
                  itemBuilder: (context, index) {
                    final doc = controller.instituteDoctors[index];
                    final docName = doc.displayName;

                    return Obx(() {
                      final isSelected = controller
                          .selectedInstituteDoctorNames
                          .contains(docName);

                      return InkWell(
                        onTap: () {
                          controller.toggleInstituteDoctor(
                            docName,
                            !isSelected,
                          );
                        },
                        child: Row(
                          children: [
                            Checkbox(
                              value: isSelected,
                              activeColor: AppColors.teal,
                              checkColor: AppColors.white,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              onChanged: (val) {
                                controller.toggleInstituteDoctor(
                                  docName,
                                  val ?? false,
                                );
                              },
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                docName,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.navy,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    });
                  },
                );
              },
            ),
          ],
        ),
      );
    });
  }

  Widget _buildPreparedByAndFooterSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        const Divider(color: AppColors.medicalGray, thickness: 1),
        const SizedBox(height: 12),

        // Row 1: Print Draft + Prepared By
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(() {
              final isSaving = controller.isSavingDischarge.value;
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.teal,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                onPressed: isSaving ? null : controller.printDraft,
                child: isSaving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.white,
                        ),
                      )
                    : Text(
                        'ds_print_draft'.tr,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              );
            }),
            const SizedBox(width: 12),
            Text(
              'ds_prepared_by'.tr,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.coolGray,
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Obx(() {
                return Text(
                  controller.preparedByName.value.isNotEmpty
                      ? controller.preparedByName.value
                      : '-',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.navy,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                );
              }),
            ),
            IconButton(
              icon: const Icon(
                Icons.edit,
                color: AppColors.teal,
                size: 20,
              ),
              onPressed: () => controller.showPreparedByDialog(context),
              tooltip: 'edit'.tr,
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Row 2: Save Draft + Final Discharge Summary
        Row(
          children: [
            Expanded(
              child: Obx(() {
                final isSaving = controller.isSavingDischarge.value;
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.teal,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: isSaving ? null : controller.saveDraft,
                  child: Text(
                    'ds_save_draft'.tr,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Obx(() {
                final isSaving = controller.isSavingDischarge.value;
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: isSaving ? null : controller.finalizeDischarge,
                  child: Text(
                    'ds_final_discharge_summary'.tr,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
