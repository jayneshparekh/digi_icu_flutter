import 'package:digi_icu_flutter/controllers/diagnosis_controller.dart';
import 'package:digi_icu_flutter/views/widgets/app_radio.dart';
import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DiagnosisScreen extends GetView<DiagnosisController> {
  const DiagnosisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.teal,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'diagnosis'.tr,
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.home, color: AppColors.white),
            onPressed: () => Get.offAllNamed('/doctor-dashboard'),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // Compiled Diagnosis Summary Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: AppColors.lightGray,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'diagnosis_label'.tr,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.navy),
                  ),
                  Expanded(
                    child: Text(
                      controller.rxDiagnosisText.value.isNotEmpty ? controller.rxDiagnosisText.value : 'na'.tr,
                      style: TextStyle(fontSize: 14, color: AppColors.navy),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Save Floating Button
                  ElevatedButton(
                    onPressed: () => controller.submitDiagnosis(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    child: Icon(Icons.save, color: AppColors.white, size: 20),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1),

            // Scrollable Forms List
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    // 1. Other Diagnosis Section
                    _buildSectionWrapper(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () => controller.cbOtherDiagnosis.value = !controller.cbOtherDiagnosis.value,
                            child: Row(
                              children: [
                                Checkbox(
                                  value: controller.cbOtherDiagnosis.value,
                                  onChanged: (val) {
                                    if (val != null) {
                                      controller.cbOtherDiagnosis.value = val;
                                    }
                                  },
                                ),
                                Text('other'.tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              ],
                            ),
                          ),
                          if (controller.cbOtherDiagnosis.value) ...[
                            const SizedBox(height: 8),
                            Column(
                              children: List.generate(5, (index) {
                                if (!controller.otherSlotsVisible[index]) return const SizedBox.shrink();

                                final isAdded = controller.otherSlotsAdded[index];

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: controller.otherControllers[index],
                                          decoration: InputDecoration(
                                            labelText: '${'other_diagnosis'.tr} ${index + 1}',
                                            border: const OutlineInputBorder(),
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                            suffixIcon: Icon(Icons.mic, color: AppColors.teal, size: 20),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      GestureDetector(
                                        onTap: () => controller.toggleOtherSlot(index),
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: isAdded ? AppColors.error : AppColors.success,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            isAdded ? Icons.close : Icons.add,
                                            color: AppColors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ],
                        ],
                      ),
                    ),

                    // 2. Hypertension Section
                    _buildSectionWrapper(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () => controller.cbHypertension.value = !controller.cbHypertension.value,
                            child: Row(
                              children: [
                                Checkbox(
                                  value: controller.cbHypertension.value,
                                  onChanged: (val) => controller.cbHypertension.value = val ?? false,
                                ),
                                Text('hypertension'.tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              ],
                            ),
                          ),
                          if (controller.cbHypertension.value) ...[
                            const SizedBox(height: 8),
                            // Sub-checkboxes
                            Wrap(
                              spacing: 16,
                              children: [
                                _buildCheckbox('essential'.tr, controller.cbHypertensionEssential),
                                _buildCheckbox('secondary'.tr, controller.cbHypertensionSecondary),
                                _buildCheckbox('white_coat'.tr, controller.cbHypertensionWhiteCoat),
                                _buildCheckbox('resistant'.tr, controller.cbBPHypertensionResistant),
                                _buildCheckbox('pregnancy_induced'.tr, controller.cbHypertensionPregnancy),
                                _buildCheckbox('malignant'.tr, controller.cbHypertensionMalignant),
                                _buildCheckbox('htnsive_emergency'.tr, controller.cbHypertensionEmergency),
                                _buildCheckbox('accelarated'.tr, controller.cbHypertensionAccelarated),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Treatment options radio
                            Text('treatment_options'.tr, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                            const SizedBox(height: 6),
                            RadioGroup<String>(
                              groupValue: controller.selectedHTNTreatment.value,
                              onChanged: (val) {
                                if (val != null) {
                                  controller.selectedHTNTreatment.value = val;
                                }
                              },
                              child: Row(
                                children: [
                                  Expanded(child: AppRadioListTile<String>(value: 'On Rx', title: Text('on_rx'.tr, style: const TextStyle(fontSize: 12)), contentPadding: EdgeInsets.zero)),
                                  Expanded(child: AppRadioListTile<String>(value: 'On Observation', title: Text('on_obs'.tr, style: const TextStyle(fontSize: 12)), contentPadding: EdgeInsets.zero)),
                                  Expanded(child: AppRadioListTile<String>(value: 'On Therapeutic', title: Text('on_therapeutic'.tr, style: const TextStyle(fontSize: 12)), contentPadding: EdgeInsets.zero)),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    // 3. Diabetes Section
                    _buildSectionWrapper(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () => controller.cbDiabetes.value = !controller.cbDiabetes.value,
                            child: Row(
                              children: [
                                Checkbox(
                                  value: controller.cbDiabetes.value,
                                  onChanged: (val) => controller.cbDiabetes.value = val ?? false,
                                ),
                                Text('diabetes_label'.tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              ],
                            ),
                          ),
                          if (controller.cbDiabetes.value) ...[
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 16,
                              children: [
                                _buildCheckbox('type_i'.tr, controller.cbDMType1),
                                _buildCheckbox('type_ii'.tr, controller.cbDmType2),
                                _buildCheckbox('prediabetic'.tr, controller.cbPreDiabetic),
                                _buildCheckbox('pregnancy_induced'.tr, controller.cbDMPregnancy),
                                _buildCheckbox('diabetic_foot'.tr, controller.cbDiabeticFoot),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text('treatment_options'.tr, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                            const SizedBox(height: 6),
                            RadioGroup<String>(
                              groupValue: controller.selectedDMTreatment.value,
                              onChanged: (val) {
                                if (val != null) {
                                  controller.selectedDMTreatment.value = val;
                                }
                              },
                              child: Row(
                                children: [
                                  Expanded(child: AppRadioListTile<String>(value: 'On Rx', title: Text('on_rx'.tr, style: const TextStyle(fontSize: 12)), contentPadding: EdgeInsets.zero)),
                                  Expanded(child: AppRadioListTile<String>(value: 'On Observation', title: Text('on_obs'.tr, style: const TextStyle(fontSize: 12)), contentPadding: EdgeInsets.zero)),
                                  Expanded(child: AppRadioListTile<String>(value: 'On TLS', title: Text('on_tls'.tr, style: const TextStyle(fontSize: 12)), contentPadding: EdgeInsets.zero)),
                                  Expanded(child: AppRadioListTile<String>(value: 'On Diet', title: Text('on_diet'.tr, style: const TextStyle(fontSize: 12)), contentPadding: EdgeInsets.zero)),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    // 4. Stroke Section
                    _buildSectionWrapper(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () => controller.cbStroke.value = !controller.cbStroke.value,
                            child: Row(
                              children: [
                                Checkbox(
                                  value: controller.cbStroke.value,
                                  onChanged: (val) => controller.cbStroke.value = val ?? false,
                                ),
                                Text('stroke_label'.tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              ],
                            ),
                          ),
                          if (controller.cbStroke.value) ...[
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 16,
                              children: [
                                _buildCheckbox('acute'.tr, controller.cbStrokeAcute),
                                _buildCheckbox('recent'.tr, controller.cbStrokeRecent),
                                _buildCheckbox('old'.tr, controller.cbStrokeOld),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),

                    // 5. Ischemic Section
                    _buildSectionWrapper(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () => controller.cbIschemic.value = !controller.cbIschemic.value,
                            child: Row(
                              children: [
                                Checkbox(
                                  value: controller.cbIschemic.value,
                                  onChanged: (val) => controller.cbIschemic.value = val ?? false,
                                ),
                                Text('ischemic_heart_disease'.tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              ],
                            ),
                          ),
                          if (controller.cbIschemic.value) ...[
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 16,
                              children: [
                                _buildCheckbox('acute'.tr, controller.cbIschemicAcute),
                                _buildCheckbox('recent'.tr, controller.cbIschemicRecent),
                                _buildCheckbox('ecg_changes'.tr, controller.cbIhdECG),
                                _buildCheckbox('old'.tr, controller.cbIschemicOld),
                                _buildCheckbox('nstemi'.tr, controller.cbIschemicNSTEMI),
                                _buildCheckbox('unstable_angina'.tr, controller.cbUnstableAngina),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),

                    // 6. Coronary (CAD) Section
                    _buildSectionWrapper(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () => controller.cbCoronary.value = !controller.cbCoronary.value,
                            child: Row(
                              children: [
                                Checkbox(
                                  value: controller.cbCoronary.value,
                                  onChanged: (val) => controller.cbCoronary.value = val ?? false,
                                ),
                                Text('cad'.tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              ],
                            ),
                          ),
                          if (controller.cbCoronary.value) ...[
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 16,
                              children: [
                                _buildCheckbox('post_cabg'.tr, controller.cbCoronaryPostCABG),
                                _buildCheckbox('dvd'.tr, controller.cbCoronaryDVD),
                                _buildCheckbox('svd'.tr, controller.cbCoronarySVD),
                                _buildCheckbox('tvd'.tr, controller.cbCoronaryTVD),
                                _buildCheckbox('post_pci'.tr, controller.cbCoronaryPostPCI),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),

                    // 7. Rhythm Section
                    _buildSectionWrapper(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () => controller.cbRhythm.value = !controller.cbRhythm.value,
                            child: Row(
                              children: [
                                Checkbox(
                                  value: controller.cbRhythm.value,
                                  onChanged: (val) => controller.cbRhythm.value = val ?? false,
                                ),
                                Text('rhythm_issues'.tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              ],
                            ),
                          ),
                          if (controller.cbRhythm.value) ...[
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 16,
                              children: [
                                _buildCheckbox('brady_arrhythmia'.tr, controller.cbRhythmBrady),
                                _buildCheckbox('atrial_flutter'.tr, controller.cbRhythmAtrialFlutter),
                                _buildCheckbox('atrial_fibrillation'.tr, controller.cbRhythmAtrialFibrillation),
                                _buildCheckbox('sinus_tachycardia'.tr, controller.cbRhythmSinus),
                                _buildCheckbox('second_degree_heart_block'.tr, controller.cbRhythmBrady2nd),
                                _buildCheckbox('chb'.tr, controller.cbRhythmBradyCHB),
                                _buildCheckbox('first_degree_heart_block'.tr, controller.cbRhythmBrady1st),
                                _buildCheckbox('svt'.tr, controller.cbRhythmSVT),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),

                    // 8. Retinopathy Section
                    _buildSectionWrapper(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () => controller.cbRetinopathy.value = !controller.cbRetinopathy.value,
                            child: Row(
                              children: [
                                Checkbox(
                                  value: controller.cbRetinopathy.value,
                                  onChanged: (val) => controller.cbRetinopathy.value = val ?? false,
                                ),
                                Text('retinopathy'.tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              ],
                            ),
                          ),
                          if (controller.cbRetinopathy.value) ...[
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 16,
                              children: [
                                _buildCheckbox('hypertensive'.tr, controller.cbRetinopathyHypertensive),
                                _buildCheckbox('diabetic'.tr, controller.cbRetinopathyDiabetic),
                                _buildCheckbox('other'.tr, controller.cbRetinopathyOther),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),

                    // 9. Individual boxes section
                    _buildSectionWrapper(
                      child: Wrap(
                        spacing: 16,
                        children: [
                          _buildCheckbox('ckd'.tr, controller.cbHtnCKD),
                          _buildCheckbox('hypothyroid'.tr, controller.cbHypothyroid),
                          _buildCheckbox('hyperthyroid'.tr, controller.cbHyperThyroid),
                          _buildCheckbox('hyperuricemia'.tr, controller.cbHyperuricemia),
                          _buildCheckbox('pad'.tr, controller.cbPeripheral),
                        ],
                      ),
                    ),

                    // 10. Left Ventricular dysfunction (LVD)
                    _buildSectionWrapper(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () => controller.cbLV.value = !controller.cbLV.value,
                            child: Row(
                              children: [
                                Checkbox(
                                  value: controller.cbLV.value,
                                  onChanged: (val) => controller.cbLV.value = val ?? false,
                                ),
                                Text('lvd'.tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              ],
                            ),
                          ),
                          if (controller.cbLV.value) ...[
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: controller.etEF,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: 'ef_value'.tr,
                                      border: const OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                    ),
                                    onChanged: (_) => controller.compileDiagnosis(),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () => controller.addLvdEf(),
                                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal),
                                  child: Text('add'.tr, style: TextStyle(color: AppColors.white)),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),

                    // 11. NYHA Section
                    _buildSectionWrapper(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () => controller.cbNYHA.value = !controller.cbNYHA.value,
                            child: Row(
                              children: [
                                Checkbox(
                                  value: controller.cbNYHA.value,
                                  onChanged: (val) => controller.cbNYHA.value = val ?? false,
                                ),
                                Text('nyha'.tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              ],
                            ),
                          ),
                          if (controller.cbNYHA.value) ...[
                            const SizedBox(height: 8),
                            RadioGroup<String>(
                              groupValue: controller.selectedNYHA.value,
                              onChanged: (val) {
                                if (val != null) {
                                  controller.selectedNYHA.value = val;
                                }
                              },
                              child: Row(
                                children: [
                                  Expanded(child: AppRadioListTile<String>(value: 'I', title: const Text('I', style: TextStyle(fontSize: 12)), contentPadding: EdgeInsets.zero)),
                                  Expanded(child: AppRadioListTile<String>(value: 'II', title: const Text('II', style: TextStyle(fontSize: 12)), contentPadding: EdgeInsets.zero)),
                                  Expanded(child: AppRadioListTile<String>(value: 'III', title: const Text('III', style: TextStyle(fontSize: 12)), contentPadding: EdgeInsets.zero)),
                                  Expanded(child: AppRadioListTile<String>(value: 'IV', title: const Text('IV', style: TextStyle(fontSize: 12)), contentPadding: EdgeInsets.zero)),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    // 12. Dyslipidemia Section
                    _buildSectionWrapper(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () => controller.cbDyslipidemia.value = !controller.cbDyslipidemia.value,
                            child: Row(
                              children: [
                                Checkbox(
                                  value: controller.cbDyslipidemia.value,
                                  onChanged: (val) => controller.cbDyslipidemia.value = val ?? false,
                                ),
                                Text('dyslipidemia'.tr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              ],
                            ),
                          ),
                          if (controller.cbDyslipidemia.value) ...[
                            const SizedBox(height: 8),
                            RadioGroup<String>(
                              groupValue: controller.selectedDLPTreatment.value,
                              onChanged: (val) {
                                if (val != null) {
                                  controller.selectedDLPTreatment.value = val;
                                }
                              },
                              child: Row(
                                children: [
                                  Expanded(child: AppRadioListTile<String>(value: 'On Rx', title: Text('on_rx'.tr, style: const TextStyle(fontSize: 12)), contentPadding: EdgeInsets.zero)),
                                  Expanded(child: AppRadioListTile<String>(value: 'On Observation', title: Text('on_obs'.tr, style: const TextStyle(fontSize: 12)), contentPadding: EdgeInsets.zero)),
                                  Expanded(child: AppRadioListTile<String>(value: 'On TLS', title: Text('on_tls'.tr, style: const TextStyle(fontSize: 12)), contentPadding: EdgeInsets.zero)),
                                  Expanded(child: AppRadioListTile<String>(value: 'On Diet', title: Text('on_diet'.tr, style: const TextStyle(fontSize: 12)), contentPadding: EdgeInsets.zero)),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSectionWrapper({required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.medicalGray),
        borderRadius: BorderRadius.circular(6),
      ),
      child: child,
    );
  }

  Widget _buildCheckbox(String label, RxBool state) {
    return InkWell(
      onTap: () => state.value = !state.value,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: state.value,
            onChanged: (val) => state.value = val ?? false,
          ),
          Text(label, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}
