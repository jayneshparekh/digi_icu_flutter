import 'package:digi_icu_flutter/controllers/diagnosis_controller.dart';
import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DiagnosisScreen extends GetView<DiagnosisController> {
  const DiagnosisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Diagnosis',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white),
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
              color: Colors.grey.shade100,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Diagnosis:  ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                  ),
                  Expanded(
                    child: Text(
                      controller.rxDiagnosisText.value.isNotEmpty ? controller.rxDiagnosisText.value : 'NA',
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Save Floating Button
                  ElevatedButton(
                    onPressed: () => controller.submitDiagnosis(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    child: const Icon(Icons.save, color: Colors.white, size: 20),
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
                                const Text('Other', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
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
                                            labelText: 'Other Diagnosis ${index + 1}',
                                            border: const OutlineInputBorder(),
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                            suffixIcon: const Icon(Icons.mic, color: AppColors.primary, size: 20),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      GestureDetector(
                                        onTap: () => controller.toggleOtherSlot(index),
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: isAdded ? Colors.red : Colors.green,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            isAdded ? Icons.close : Icons.add,
                                            color: Colors.white,
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
                                const Text('Hypertension', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              ],
                            ),
                          ),
                          if (controller.cbHypertension.value) ...[
                            const SizedBox(height: 8),
                            // Sub-checkboxes
                            Wrap(
                              spacing: 16,
                              children: [
                                _buildCheckbox('Essential', controller.cbHypertensionEssential),
                                _buildCheckbox('Secondary', controller.cbHypertensionSecondary),
                                _buildCheckbox('White coat', controller.cbHypertensionWhiteCoat),
                                _buildCheckbox('Resistant', controller.cbBPHypertensionResistant),
                                _buildCheckbox('Pregnancy induced', controller.cbHypertensionPregnancy),
                                _buildCheckbox('Malignant', controller.cbHypertensionMalignant),
                                _buildCheckbox('HTNsive Emergency', controller.cbHypertensionEmergency),
                                _buildCheckbox('Accelarated', controller.cbHypertensionAccelarated),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Treatment options radio
                            const Text('Treatment Options:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
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
                                  Expanded(child: RadioListTile<String>(value: 'On Rx', title: const Text('On Rx', style: TextStyle(fontSize: 12)), contentPadding: EdgeInsets.zero)),
                                  Expanded(child: RadioListTile<String>(value: 'On Observation', title: const Text('On Obs', style: TextStyle(fontSize: 12)), contentPadding: EdgeInsets.zero)),
                                  Expanded(child: RadioListTile<String>(value: 'On Therapeutic', title: const Text('On Therapeutic', style: TextStyle(fontSize: 12)), contentPadding: EdgeInsets.zero)),
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
                                const Text('Diabetes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              ],
                            ),
                          ),
                          if (controller.cbDiabetes.value) ...[
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 16,
                              children: [
                                _buildCheckbox('Type I', controller.cbDMType1),
                                _buildCheckbox('Type II', controller.cbDmType2),
                                _buildCheckbox('PreDiabetic', controller.cbPreDiabetic),
                                _buildCheckbox('Pregnancy induced', controller.cbDMPregnancy),
                                _buildCheckbox('Diabetic Foot', controller.cbDiabeticFoot),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text('Treatment Options:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
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
                                  Expanded(child: RadioListTile<String>(value: 'On Rx', title: const Text('On Rx', style: TextStyle(fontSize: 12)), contentPadding: EdgeInsets.zero)),
                                  Expanded(child: RadioListTile<String>(value: 'On Observation', title: const Text('On Obs', style: TextStyle(fontSize: 12)), contentPadding: EdgeInsets.zero)),
                                  Expanded(child: RadioListTile<String>(value: 'On TLS', title: const Text('On TLS', style: TextStyle(fontSize: 12)), contentPadding: EdgeInsets.zero)),
                                  Expanded(child: RadioListTile<String>(value: 'On Diet', title: const Text('On Diet', style: TextStyle(fontSize: 12)), contentPadding: EdgeInsets.zero)),
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
                                const Text('Stroke', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              ],
                            ),
                          ),
                          if (controller.cbStroke.value) ...[
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 16,
                              children: [
                                _buildCheckbox('Acute', controller.cbStrokeAcute),
                                _buildCheckbox('Recent', controller.cbStrokeRecent),
                                _buildCheckbox('Old', controller.cbStrokeOld),
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
                                const Text('Ischemic Heart Disease (MI)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              ],
                            ),
                          ),
                          if (controller.cbIschemic.value) ...[
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 16,
                              children: [
                                _buildCheckbox('Acute', controller.cbIschemicAcute),
                                _buildCheckbox('Recent', controller.cbIschemicRecent),
                                _buildCheckbox('ECG changes', controller.cbIhdECG),
                                _buildCheckbox('Old', controller.cbIschemicOld),
                                _buildCheckbox('NSTEMI', controller.cbIschemicNSTEMI),
                                _buildCheckbox('Unstable Angina', controller.cbUnstableAngina),
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
                                const Text('Coronary Artery Disease (CAD)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              ],
                            ),
                          ),
                          if (controller.cbCoronary.value) ...[
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 16,
                              children: [
                                _buildCheckbox('Post CABG', controller.cbCoronaryPostCABG),
                                _buildCheckbox('DVD', controller.cbCoronaryDVD),
                                _buildCheckbox('SVD', controller.cbCoronarySVD),
                                _buildCheckbox('TVD', controller.cbCoronaryTVD),
                                _buildCheckbox('Post PCI', controller.cbCoronaryPostPCI),
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
                                const Text('Rhythm issues', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              ],
                            ),
                          ),
                          if (controller.cbRhythm.value) ...[
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 16,
                              children: [
                                _buildCheckbox('Brady arrhythmia', controller.cbRhythmBrady),
                                _buildCheckbox('Atrial flutter', controller.cbRhythmAtrialFlutter),
                                _buildCheckbox('Atrial Fibrillation', controller.cbRhythmAtrialFibrillation),
                                _buildCheckbox('Sinus Tachycardia', controller.cbRhythmSinus),
                                _buildCheckbox('2nd degree heart block', controller.cbRhythmBrady2nd),
                                _buildCheckbox('CHB', controller.cbRhythmBradyCHB),
                                _buildCheckbox('1st degree heart block', controller.cbRhythmBrady1st),
                                _buildCheckbox('SVT', controller.cbRhythmSVT),
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
                                const Text('Retinopathy', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              ],
                            ),
                          ),
                          if (controller.cbRetinopathy.value) ...[
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 16,
                              children: [
                                _buildCheckbox('Hypertensive', controller.cbRetinopathyHypertensive),
                                _buildCheckbox('Diabetic', controller.cbRetinopathyDiabetic),
                                _buildCheckbox('Other', controller.cbRetinopathyOther),
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
                          _buildCheckbox('CKD', controller.cbHtnCKD),
                          _buildCheckbox('Hypothyroid', controller.cbHypothyroid),
                          _buildCheckbox('HyperThyroid', controller.cbHyperThyroid),
                          _buildCheckbox('Hyperuricemia', controller.cbHyperuricemia),
                          _buildCheckbox('PAD', controller.cbPeripheral),
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
                                const Text('Left Ventricular dysfunction (LVD)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
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
                                    decoration: const InputDecoration(
                                      labelText: 'EF Value (%)',
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                    ),
                                    onChanged: (_) => controller.compileDiagnosis(),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () => controller.addLvdEf(),
                                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                                  child: const Text('Add', style: TextStyle(color: Colors.white)),
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
                                const Text('NYHA', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
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
                                  Expanded(child: RadioListTile<String>(value: 'I', title: const Text('I', style: TextStyle(fontSize: 12)), contentPadding: EdgeInsets.zero)),
                                  Expanded(child: RadioListTile<String>(value: 'II', title: const Text('II', style: TextStyle(fontSize: 12)), contentPadding: EdgeInsets.zero)),
                                  Expanded(child: RadioListTile<String>(value: 'III', title: const Text('III', style: TextStyle(fontSize: 12)), contentPadding: EdgeInsets.zero)),
                                  Expanded(child: RadioListTile<String>(value: 'IV', title: const Text('IV', style: TextStyle(fontSize: 12)), contentPadding: EdgeInsets.zero)),
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
                                const Text('Dyslipidemia', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
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
                                  Expanded(child: RadioListTile<String>(value: 'On Rx', title: const Text('On Rx', style: TextStyle(fontSize: 12)), contentPadding: EdgeInsets.zero)),
                                  Expanded(child: RadioListTile<String>(value: 'On Observation', title: const Text('On Obs', style: TextStyle(fontSize: 12)), contentPadding: EdgeInsets.zero)),
                                  Expanded(child: RadioListTile<String>(value: 'On TLS', title: const Text('On TLS', style: TextStyle(fontSize: 12)), contentPadding: EdgeInsets.zero)),
                                  Expanded(child: RadioListTile<String>(value: 'On Diet', title: const Text('On Diet', style: TextStyle(fontSize: 12)), contentPadding: EdgeInsets.zero)),
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
        border: Border.all(color: Colors.grey.shade300),
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
