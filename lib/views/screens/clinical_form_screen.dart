import 'dart:io';
import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/views/widgets/app_dialog.dart';
import 'package:digi_icu_flutter/views/widgets/app_form_section_header.dart';
import 'package:digi_icu_flutter/views/widgets/app_loading_overlay.dart';
import 'package:digi_icu_flutter/views/widgets/app_primary_button.dart';
import 'package:digi_icu_flutter/views/widgets/app_radio.dart';
import 'package:digi_icu_flutter/views/widgets/app_snackbars.dart';
import 'package:digi_icu_flutter/views/widgets/app_teal_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../controllers/clinical_form_controller.dart';

class ClinicalFormScreen extends GetView<ClinicalFormController> {
  const ClinicalFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          AppSnackbars.showWarning('action_required'.tr, 'cannot_go_back'.tr);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => Text(
                    controller.isFrom == 'Doctor'
                        ? controller.patientName
                        : controller.patientName.isNotEmpty
                            ? controller.patientName
                            : 'patient_name_default'.tr,
                    style: const TextStyle(
                      color: AppColors.navy,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              if (controller.doctorName.isNotEmpty)
                Text(
                  controller.doctorName,
                  style: const TextStyle(
                    color: AppColors.medicalGray,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ),
        body: Obx(() {
          final showSpecialityFields = controller.speciality.isEmpty;
          final showSmoking = controller.mClinicalFormData.smoking == 'Yes';
          final showAlcohol = controller.mClinicalFormData.alcohol == 'Yes';

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ==========================================
                    // SECTION 1: BP, Oxygen & Weight
                    // ==========================================
                    AppFormSectionHeader(
                      subtitle: 'clinical_form_sec1'.tr,
                      title: 'bp_oxygen_weight'.tr,
                    ),
                    const SizedBox(height: 24),

                    // --- 1st BP ---
                    _buildSubHeader('first_bp_question'.tr),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset('assets/images/m_bp.png', width: 65, height: 65),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: !controller.haveBPApparatus.value,
                                    onChanged: (val) => controller.toggleBPApparatus(!(val ?? false)),
                                    activeColor: AppColors.teal,
                                  ),
                                  Expanded(
                                    child: Text(
                                      'no_bp_apparatus'.tr,
                                      style: const TextStyle(fontSize: 13, color: AppColors.navy),
                                    ),
                                  ),
                                ],
                              ),
                              if (controller.haveBPApparatus.value) ...[
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: controller.systolicController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText: 'systolic_bp'.tr,
                                          border: const OutlineInputBorder(),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: TextField(
                                        controller: controller.diastolicController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText: 'diastolic_bp'.tr,
                                          border: const OutlineInputBorder(),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: TextField(
                                        controller: controller.pulseRateController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText: 'pulse_rate'.tr,
                                          border: const OutlineInputBorder(),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    AppTealIconButton(
                                      assetPath: 'assets/icons/svg/ic_power_button.svg',
                                      onTap: () {},
                                      size: 40,
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),

                    // --- Oxygen Level ---
                    _buildSubHeader('oxygen_level_question'.tr),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset('assets/images/ic_spo2.png', width: 65, height: 65),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RadioGroup<String>(
                                groupValue: controller.spo2Choice.value,
                                onChanged: (val) => controller.selectSpo2Choice(val ?? ''),
                                child: Row(
                                  children: [
                                    AppRadio<String>(value: 'Yes'),
                                    Text('yes'.tr),
                                    const SizedBox(width: 16),
                                    AppRadio<String>(value: 'No'),
                                    Text('no'.tr),
                                  ],
                                ),
                              ),
                              if (controller.spo2Choice.value == 'Yes') ...[
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: controller.spo2Controller,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText: 'spo2'.tr,
                                          border: const OutlineInputBorder(),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    AppTealIconButton(
                                      assetPath: 'assets/icons/svg/ic_power_button.svg',
                                      onTap: () {},
                                      size: 44,
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),

                    // --- Height & Weight ---
                    _buildSubHeader('height_weight'.tr),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset('assets/images/m_height.png', width: 65, height: 65),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: controller.heightController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'height_cm'.tr,
                                    border: const OutlineInputBorder(),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: controller.weightController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'weight_kg'.tr,
                                    border: const OutlineInputBorder(),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // ==========================================
                    // SECTION 2: Investigations
                    // ==========================================
                    AppFormSectionHeader(
                      subtitle: 'clinical_form_sec2'.tr,
                      title: 'investigations'.tr,
                    ),
                    const SizedBox(height: 24),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/m_glucometer.png', width: 65, height: 65),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'have_blood_investigations'.tr,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.navy,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),

                    // --- Blood Sugar Level ---
                    Row(
                      children: [
                        Checkbox(
                          value: controller.checkSugarVal.value,
                          onChanged: (val) => controller.checkSugarVal.value = val ?? false,
                          activeColor: AppColors.teal,
                        ),
                        Text(
                          'blood_sugar_level'.tr,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy),
                        ),
                      ],
                    ),
                    if (controller.checkSugarVal.value) ...[
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextField(
                                controller: controller.fastingController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'fasting'.tr,
                                  border: const OutlineInputBorder(),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: TextField(
                                controller: controller.afterFoodController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'after_food'.tr,
                                  border: const OutlineInputBorder(),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: TextField(
                                controller: controller.randomController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'random'.tr,
                                  border: const OutlineInputBorder(),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            AppTealIconButton(
                              assetPath: 'assets/icons/svg/ic_power_button.svg',
                              onTap: () {},
                              size: 40,
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),

                    // --- Creatinine ---
                    Row(
                      children: [
                        Checkbox(
                          value: controller.cbCreatinine.value,
                          onChanged: (val) => controller.cbCreatinine.value = val ?? false,
                          activeColor: AppColors.teal,
                        ),
                        Text(
                          'creatinine'.tr,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy),
                        ),
                      ],
                    ),
                    if (controller.cbCreatinine.value) ...[
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: TextField(
                          controller: controller.creatinineController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'creatinine_kidney_function'.tr,
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.info, color: AppColors.medicalGray),
                              onPressed: () => _showInfoDialog('Creatinine', 'Creatinine is a chemical waste product that\'s created by your muscle metabolism and to a smaller extent by eating meat. Healthy kidneys filter creatinine and other waste products from your blood.'),
                            ),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),

                    // --- HbA1c ---
                    Row(
                      children: [
                        Checkbox(
                          value: controller.cbHba1c.value,
                          onChanged: (val) => controller.cbHba1c.value = val ?? false,
                          activeColor: AppColors.teal,
                        ),
                        Text(
                          'hba1c'.tr,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy),
                        ),
                      ],
                    ),
                    if (controller.cbHba1c.value) ...[
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: controller.hba1cController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'hba1c'.tr,
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.info, color: AppColors.medicalGray),
                                  onPressed: () => _showInfoDialog('HbA1c', 'The HbA1c test shows your average blood sugar level over the past 2 to 3 months. It\'s a common test used to diagnose prediabetes and diabetes.'),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                RadioGroup<String>(
                                  groupValue: controller.hba1cDateChoice.value,
                                  onChanged: (val) => controller.hba1cDateChoice.value = val ?? '',
                                  child: Row(
                                    children: [
                                      Row(
                                        children: [
                                          AppRadio<String>(value: 'Today'),
                                          Text('today'.tr),
                                        ],
                                      ),
                                      const SizedBox(width: 8),
                                      Row(
                                        children: [
                                          AppRadio<String>(value: 'Yesterday'),
                                          Text('yesterday'.tr),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => _showDatePicker(context),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: AppColors.medicalGray),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            controller.hba1cDateChoice.value == 'Today' ? 'today'.tr : controller.hba1cDateChoice.value == 'Yesterday' ? 'yesterday'.tr : controller.hba1cDateChoice.value,
                                            style: const TextStyle(fontSize: 13, color: AppColors.navy),
                                          ),
                                          const Icon(Icons.calendar_today, size: 16, color: AppColors.medicalGray),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),

                    // --- Total Cholesterol ---
                    Row(
                      children: [
                        Checkbox(
                          value: controller.cbCholesterol.value,
                          onChanged: (val) => controller.cbCholesterol.value = val ?? false,
                          activeColor: AppColors.teal,
                        ),
                        Text(
                          'total_cholesterol'.tr,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy),
                        ),
                      ],
                    ),
                    if (controller.cbCholesterol.value) ...[
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Column(
                          children: [
                            TextField(
                              controller: controller.totalCholesterolController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'total_cholesterol_lipid'.tr,
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.info, color: AppColors.medicalGray),
                                  onPressed: () => _showInfoDialog('Total Cholesterol', 'Total cholesterol is a measure of the total amount of cholesterol in your blood, including LDL (bad) cholesterol and HDL (good) cholesterol.'),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: controller.hdlController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: 'hdl'.tr,
                                      border: const OutlineInputBorder(),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: TextField(
                                    controller: controller.ldlController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: 'ldl'.tr,
                                      border: const OutlineInputBorder(),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: TextField(
                                    controller: controller.vldlController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: 'vldl'.tr,
                                      border: const OutlineInputBorder(),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),

                    // --- Urine Albumin ---
                    Row(
                      children: [
                        Checkbox(
                          value: controller.cbUrineAlbumin.value,
                          onChanged: (val) => controller.cbUrineAlbumin.value = val ?? false,
                          activeColor: AppColors.teal,
                        ),
                        Text(
                          'urine_albumin'.tr,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy),
                        ),
                      ],
                    ),
                    if (controller.cbUrineAlbumin.value) ...[
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('urine_albumin'.tr, style: const TextStyle(fontSize: 13, color: AppColors.coolGray)),
                            RadioGroup<String>(
                              groupValue: controller.urineAlbuminType.value,
                              onChanged: (val) => controller.urineAlbuminType.value = val ?? '',
                              child: Row(
                                children: [
                                  Row(
                                    children: [
                                      AppRadio<String>(value: 'Numeric'),
                                      Text('numeric'.tr),
                                    ],
                                  ),
                                  const SizedBox(width: 16),
                                  Row(
                                    children: [
                                      AppRadio<String>(value: 'Value'),
                                      Text('value'.tr),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (controller.urineAlbuminType.value == 'Numeric') ...[
                              TextField(
                                controller: controller.urineAlbuminNumericController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'enter_numeric'.tr,
                                  border: const OutlineInputBorder(),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.info, color: AppColors.medicalGray),
                                    onPressed: () => _showInfoDialog('Urine Albumin', 'Urine albumin is a test to detect small amounts of a blood protein (albumin) in your urine. An albumin test helps identify kidney disease.'),
                                  ),
                                ),
                              ),
                            ] else ...[
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.medicalGray),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: controller.urineAlbuminValueSelected.value,
                                    isExpanded: true,
                                    items: ['Select', 'Negative', 'Trace', 'Positive']
                                        .map((v) => DropdownMenuItem(value: v, child: Text(v == 'Select' ? 'select'.tr : v == 'Negative' ? 'negative'.tr : v == 'Trace' ? 'trace'.tr : v == 'Positive' ? 'positive'.tr : v)))
                                        .toList(),
                                    onChanged: (val) => controller.urineAlbuminValueSelected.value = val ?? 'Select',
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),

                    // --- ECG ---
                    Row(
                      children: [
                        Checkbox(
                          value: controller.cbEcg.value,
                          onChanged: (val) => controller.cbEcg.value = val ?? false,
                          activeColor: AppColors.teal,
                        ),
                        Text(
                          'ecg'.tr,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy),
                        ),
                        IconButton(
                          icon: const Icon(Icons.info, color: AppColors.medicalGray, size: 20),
                          onPressed: () => _showInfoDialog('ECG', 'An electrocardiogram (ECG) records the electrical signals in your heart. It\'s a common and painless test used to quickly detect heart problems and monitor your heart\'s health.'),
                        ),
                      ],
                    ),
                    if (controller.cbEcg.value) ...[
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('upload_image'.tr, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.navy)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => controller.pickEcgImage(ImageSource.gallery),
                                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: AppColors.white),
                                    icon: const Icon(Icons.photo_library),
                                    label: Text('gallery'.tr),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => controller.pickEcgImage(ImageSource.camera),
                                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: AppColors.white),
                                    icon: const Icon(Icons.camera_alt),
                                    label: Text('camera'.tr),
                                  ),
                                ),
                              ],
                            ),
                            if (controller.ecgReportImages.isNotEmpty) ...[
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 80,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: controller.ecgReportImages.length,
                                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                                  itemBuilder: (context, index) {
                                    final img = controller.ecgReportImages[index];
                                    return Stack(
                                      children: [
                                        Image.file(File(img.path), width: 80, height: 80, fit: BoxFit.cover),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () => controller.removeEcgImage(index),
                                            child: Container(
                                              color: AppColors.coolGray,
                                              child: const Icon(Icons.close, color: AppColors.white, size: 16),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                            const SizedBox(height: 16),
                            Text('record_ecg'.tr, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.navy)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: AppColors.white),
                                    child: Text('short_ecg'.tr, style: const TextStyle(fontSize: 11)),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: AppColors.white),
                                    child: Text('record_12_lead_ecg'.tr, style: const TextStyle(fontSize: 11)),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              height: 120,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.medicalGray),
                                color: AppColors.lightGray,
                              ),
                              child: GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 20,
                                ),
                                itemCount: 100,
                                itemBuilder: (context, index) => Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(color: AppColors.lightGray),
                                      right: BorderSide(color: AppColors.lightGray),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),

                    // --- Thyroid ---
                    Row(
                      children: [
                        Checkbox(
                          value: controller.cbThyroid.value,
                          onChanged: (val) => controller.cbThyroid.value = val ?? false,
                          activeColor: AppColors.teal,
                        ),
                        Text(
                          'thyroid'.tr,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy),
                        ),
                      ],
                    ),
                    if (controller.cbThyroid.value) ...[
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: controller.t3Controller,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 't3'.tr,
                                  border: const OutlineInputBorder(),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: TextField(
                                controller: controller.t4Controller,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 't4'.tr,
                                  border: const OutlineInputBorder(),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: TextField(
                                controller: controller.tshController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'tsh'.tr,
                                  border: const OutlineInputBorder(),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),

                    // --- Uric Acid ---
                    Row(
                      children: [
                        Checkbox(
                          value: controller.cbUricAcid.value,
                          onChanged: (val) => controller.cbUricAcid.value = val ?? false,
                          activeColor: AppColors.teal,
                        ),
                        Text(
                          'uric_acid'.tr,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy),
                        ),
                      ],
                    ),
                    if (controller.cbUricAcid.value) ...[
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: TextField(
                          controller: controller.uricAcidController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'uric_acid'.tr,
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.info, color: AppColors.medicalGray),
                              onPressed: () => _showInfoDialog('Uric Acid', 'Uric acid is a waste product found in blood. It\'s created when the body breaks down chemicals called purines. Most uric acid dissolves in blood, passes through the kidneys and leaves the body in urine.'),
                            ),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),

                    // --- Other Investigations ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'other_investigations'.tr,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy),
                        ),
                        RadioGroup<String>(
                          groupValue: controller.otherInvestigationsChoice.value,
                          onChanged: (val) => controller.otherInvestigationsChoice.value = val ?? 'No',
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  AppRadio<String>(value: 'Yes'),
                                  Text('yes'.tr),
                                ],
                              ),
                              const SizedBox(width: 8),
                              Row(
                                children: [
                                  AppRadio<String>(value: 'No'),
                                  Text('no'.tr),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (controller.otherInvestigationsChoice.value == 'Yes') ...[
                      const SizedBox(height: 12),
                      TextField(
                        controller: controller.otherInvestigationsController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'enter_details_other_investigations'.tr,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => controller.pickOtherImage(ImageSource.gallery),
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: AppColors.white),
                              icon: const Icon(Icons.photo_library),
                              label: Text('gallery'.tr),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => controller.pickOtherImage(ImageSource.camera),
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.teal, foregroundColor: AppColors.white),
                              icon: const Icon(Icons.camera_alt),
                              label: Text('camera'.tr),
                            ),
                          ),
                        ],
                      ),
                      if (controller.otherReportImages.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 80,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.otherReportImages.length,
                            separatorBuilder: (context, index) => const SizedBox(width: 8),
                            itemBuilder: (context, index) {
                              final img = controller.otherReportImages[index];
                              return Stack(
                                children: [
                                  Image.file(File(img.path), width: 80, height: 80, fit: BoxFit.cover),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () => controller.removeOtherImage(index),
                                      child: Container(
                                        color: AppColors.coolGray,
                                        child: const Icon(Icons.close, color: AppColors.white, size: 16),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                    const SizedBox(height: 32),

                    // ==========================================
                    // SECTION 3: Symptoms
                    // ==========================================
                    AppFormSectionHeader(
                      subtitle: 'clinical_form_sec3'.tr,
                      title: 'symptoms'.tr,
                    ),
                    const SizedBox(height: 24),

                    // --- Feeling compared to last visit ---
                    if (showSpecialityFields) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset('assets/images/m_feeling.png', width: 65, height: 65),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'how_feeling_compared'.tr,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy),
                                ),
                                const SizedBox(height: 8),
                                RadioGroup<String>(
                                  groupValue: controller.improvement.value,
                                  onChanged: (val) => controller.improvement.value = val ?? '',
                                  child: Column(
                                    children: ['Good', 'Better', 'Same', 'More Suffering', 'This is my first consultation']
                                        .map((option) => Row(
                                              children: [
                                                AppRadio<String>(value: option),
                                                Text(option == 'Good' ? 'good'.tr : option == 'Better' ? 'better'.tr : option == 'Same' ? 'same'.tr : option == 'More Suffering' ? 'more_suffering'.tr : 'first_consultation'.tr),
                                              ],
                                            ))
                                        .toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                    ],

                    // --- Chest Pain ---
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset('assets/images/m_chest_pain.png', width: 65, height: 65),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'have_chest_pain'.tr,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy),
                              ),
                              const SizedBox(height: 8),
                              RadioGroup<String>(
                                groupValue: controller.chestPain.value,
                                onChanged: (val) => controller.chestPain.value = val ?? '',
                                child: Row(
                                  children: [
                                    AppRadio<String>(value: 'Yes'),
                                    Text('yes'.tr),
                                    const SizedBox(width: 24),
                                    AppRadio<String>(value: 'No'),
                                    Text('no'.tr),
                                  ],
                                ),
                              ),
                              if (controller.chestPain.value == 'Yes') ...[
                                const SizedBox(height: 12),
                                Text(
                                  'with_sweating'.tr,
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.coolGray),
                                ),
                                RadioGroup<String>(
                                  groupValue: controller.chestPainSweating.value,
                                  onChanged: (val) => controller.chestPainSweating.value = val ?? '',
                                  child: Row(
                                    children: [
                                      AppRadio<String>(value: 'Yes'),
                                      Text('yes'.tr),
                                      const SizedBox(width: 24),
                                      AppRadio<String>(value: 'No'),
                                      Text('no'.tr),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),

                    // --- Breathing Difficulty ---
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset('assets/images/m_breathing.png', width: 65, height: 65),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'difficulty_breathing'.tr,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy),
                              ),
                              const SizedBox(height: 8),
                              RadioGroup<String>(
                                groupValue: controller.breathlessness.value,
                                onChanged: (val) => controller.breathlessness.value = val ?? '',
                                child: Row(
                                  children: [
                                    AppRadio<String>(value: 'Yes'),
                                    Text('yes'.tr),
                                    const SizedBox(width: 24),
                                    AppRadio<String>(value: 'No'),
                                    Text('no'.tr),
                                  ],
                                ),
                              ),
                              if (controller.breathlessness.value == 'Yes') ...[
                                const SizedBox(height: 12),
                                RadioGroup<String>(
                                  groupValue: controller.breathlessWhile.value,
                                  onChanged: (val) => controller.breathlessWhile.value = val ?? '',
                                  child: Row(
                                    children: [
                                      AppRadio<String>(value: 'Walking'),
                                      Text('walking'.tr),
                                      const SizedBox(width: 16),
                                      AppRadio<String>(value: 'At Rest'),
                                      Text('at_rest'.tr),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),

                    // --- Palpitations ---
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset('assets/images/m_palpitations.png', width: 65, height: 65),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'have_palpitations'.tr,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy),
                              ),
                              const SizedBox(height: 8),
                              RadioGroup<String>(
                                groupValue: controller.palpitations.value,
                                onChanged: (val) => controller.palpitations.value = val ?? '',
                                child: Row(
                                  children: [
                                    AppRadio<String>(value: 'Yes'),
                                    Text('yes'.tr),
                                    const SizedBox(width: 24),
                                    AppRadio<String>(value: 'No'),
                                    Text('no'.tr),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),

                    // --- Giddiness ---
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset('assets/images/m_giddiness.png', width: 65, height: 65),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'have_giddiness'.tr,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy),
                              ),
                              const SizedBox(height: 8),
                              RadioGroup<String>(
                                groupValue: controller.giddiness.value,
                                onChanged: (val) => controller.giddiness.value = val ?? '',
                                child: Row(
                                  children: [
                                    AppRadio<String>(value: 'Yes'),
                                    Text('yes'.tr),
                                    const SizedBox(width: 24),
                                    AppRadio<String>(value: 'No'),
                                    Text('no'.tr),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),

                    // --- Headache ---
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset('assets/images/m_headache.png', width: 65, height: 65),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'have_headache'.tr,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy),
                              ),
                              const SizedBox(height: 8),
                              RadioGroup<String>(
                                groupValue: controller.headache.value,
                                onChanged: (val) => controller.headache.value = val ?? '',
                                child: Row(
                                  children: [
                                    AppRadio<String>(value: 'Yes'),
                                    Text('yes'.tr),
                                    const SizedBox(width: 24),
                                    AppRadio<String>(value: 'No'),
                                    Text('no'.tr),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),

                    // --- Dizziness on standing up ---
                    if (showSpecialityFields) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset('assets/images/m_feeling.png', width: 65, height: 65),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'dizziness_standing'.tr,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy),
                                ),
                                const SizedBox(height: 8),
                                RadioGroup<String>(
                                  groupValue: controller.dizziness.value,
                                  onChanged: (val) => controller.dizziness.value = val ?? '',
                                  child: Row(
                                    children: [
                                      AppRadio<String>(value: 'Yes'),
                                      const Text('Yes'),
                                      const SizedBox(width: 24),
                                      AppRadio<String>(value: 'No'),
                                      const Text('No'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                    ],

                    // --- Bleeding Episode ---
                    if (showSpecialityFields) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset('assets/images/m_bleeding_tendencny.png', width: 65, height: 65),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'bleeding_episode'.tr,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy),
                                ),
                                const SizedBox(height: 8),
                                RadioGroup<String>(
                                  groupValue: controller.bleedingEpisode.value,
                                  onChanged: (val) => controller.bleedingEpisode.value = val ?? '',
                                  child: Row(
                                    children: [
                                      AppRadio<String>(value: 'Yes'),
                                      const Text('Yes'),
                                      const SizedBox(width: 24),
                                      AppRadio<String>(value: 'No'),
                                      const Text('No'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                    ],

                    // --- Other Symptoms ---
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset('assets/images/m_feeling.png', width: 65, height: 65),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'other_symptoms_if_any'.tr,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy),
                              ),
                              const SizedBox(height: 8),
                              RadioGroup<String>(
                                groupValue: controller.otherSymptomsChoice.value,
                                onChanged: (val) => controller.otherSymptomsChoice.value = val ?? '',
                                child: Row(
                                  children: [
                                    AppRadio<String>(value: 'Yes'),
                                    Text('yes'.tr),
                                    const SizedBox(width: 24),
                                    AppRadio<String>(value: 'None'),
                                    Text('none'.tr),
                                  ],
                                ),
                              ),
                              if (controller.otherSymptomsChoice.value == 'Yes') ...[
                                const SizedBox(height: 8),
                                TextField(
                                  controller: controller.otherSymptomsController,
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                    labelText: 'enter_details_other_symptoms'.tr,
                                    border: const OutlineInputBorder(),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // ==========================================
                    // SECTION 4: About Habits & Vitals Again
                    // ==========================================
                    AppFormSectionHeader(
                      subtitle: 'clinical_form_sec4'.tr,
                      title: 'about_habits'.tr,
                    ),
                    const SizedBox(height: 24),

                    // --- OPTIONAL: Smoking ---
                    if (showSmoking) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset('assets/images/m_feeling.png', width: 65, height: 65),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'did_you_stop_smoking'.tr,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy),
                                ),
                                const SizedBox(height: 8),
                                RadioGroup<String>(
                                  groupValue: controller.smoking.value,
                                  onChanged: (val) {
                                    controller.smoking.value = val ?? '';
                                    if (val == 'No') {
                                      _showHabitSuggestionDialog(
                                        'suggestion'.tr,
                                        'quitting_smoking_msg'.tr,
                                      );
                                    }
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: ['Yes', 'No', 'I need help'].map((option) => Row(
                                      children: [
                                        AppRadio<String>(value: option),
                                        Text(option == 'Yes' ? 'yes'.tr : option == 'No' ? 'no'.tr : 'i_need_help'.tr),
                                      ],
                                    )).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                    ],

                    // --- OPTIONAL: Alcohol ---
                    if (showAlcohol) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset('assets/images/m_feeling.png', width: 65, height: 65),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'did_you_stop_alcohol'.tr,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy),
                                ),
                                const SizedBox(height: 8),
                                RadioGroup<String>(
                                  groupValue: controller.alcohol.value,
                                  onChanged: (val) {
                                    controller.alcohol.value = val ?? '';
                                    if (val == 'No') {
                                      _showHabitSuggestionDialog(
                                        'suggestion'.tr,
                                        'limiting_alcohol_msg'.tr,
                                      );
                                    }
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: ['Yes', 'No', 'I need help'].map((option) => Row(
                                      children: [
                                        AppRadio<String>(value: option),
                                        Text(option == 'Yes' ? 'yes'.tr : option == 'No' ? 'no'.tr : 'i_need_help'.tr),
                                      ],
                                    )).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                    ],

                    // --- Reduce Salt Intake ---
                    if (showSpecialityFields) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset('assets/images/m_salt_intake.png', width: 65, height: 65),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'reduce_salt_intake'.tr,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy),
                                ),
                                const SizedBox(height: 8),
                                RadioGroup<String>(
                                  groupValue: controller.reduceSalt.value,
                                  onChanged: (val) => controller.reduceSalt.value = val ?? '',
                                  child: Row(
                                    children: [
                                      AppRadio<String>(value: 'Yes'),
                                      Text('yes'.tr),
                                      const SizedBox(width: 24),
                                      AppRadio<String>(value: 'No'),
                                      Text('no'.tr),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                    ],

                    // --- Morning Walk ---
                    if (showSpecialityFields) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset('assets/images/m_morning_walk.png', width: 65, height: 65),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'morning_walk_daily'.tr,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy),
                                ),
                                const SizedBox(height: 8),
                                RadioGroup<String>(
                                  groupValue: controller.exercise.value,
                                  onChanged: (val) => controller.exercise.value = val ?? '',
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: ['Yes', 'No', 'sometimes missing'].map((option) => Row(
                                      children: [
                                        AppRadio<String>(value: option),
                                        Text(option == 'Yes' ? 'yes'.tr : option == 'No' ? 'no'.tr : 'sometimes_missing'.tr),
                                      ],
                                    )).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                    ],

                    // --- Stress ---
                    if (showSpecialityFields) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset('assets/images/m_stress.png', width: 65, height: 65),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'are_you_in_stress'.tr,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy),
                                ),
                                const SizedBox(height: 8),
                                RadioGroup<String>(
                                  groupValue: controller.inStress.value,
                                  onChanged: (val) => controller.inStress.value = val ?? '',
                                  child: Row(
                                    children: [
                                      AppRadio<String>(value: 'Yes'),
                                      Text('yes'.tr),
                                      const SizedBox(width: 24),
                                      AppRadio<String>(value: 'No'),
                                      Text('no'.tr),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                    ],

                    // --- Miss Medication ---
                    if (showSpecialityFields) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset('assets/images/m_medicines.png', width: 65, height: 65),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'miss_medication_doses'.tr,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy),
                                ),
                                const SizedBox(height: 8),
                                RadioGroup<String>(
                                  groupValue: controller.missMedicine.value,
                                  onChanged: (val) {
                                    controller.missMedicine.value = val ?? '';
                                    if (val == 'Yes') {
                                      _showHabitSuggestionDialog(
                                        'medication_suggestion'.tr,
                                        'medication_suggestion_msg'.tr,
                                      );
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      AppRadio<String>(value: 'Yes'),
                                      Text('yes'.tr),
                                      const SizedBox(width: 24),
                                      AppRadio<String>(value: 'No'),
                                      Text('no'.tr),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 32),
                    ],

                    // --- VITALS AGAIN SECTION ---
                    Text(
                      'vitals_again'.tr,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.teal,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 100,
                      height: 2,
                      color: AppColors.teal,
                    ),
                    const SizedBox(height: 24),

                    // --- Last Hospitalization ---
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset('assets/images/m_feeling.png', width: 65, height: 65),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'last_hospitalization'.tr,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy),
                              ),
                              const SizedBox(height: 8),
                              RadioGroup<String>(
                                groupValue: controller.lastHospitalization.value,
                                onChanged: (val) => controller.lastHospitalization.value = val ?? '',
                                child: Row(
                                  children: [
                                    AppRadio<String>(value: 'Yes'),
                                    Text('yes'.tr),
                                    const SizedBox(width: 24),
                                    AppRadio<String>(value: 'No'),
                                    Text('no'.tr),
                                  ],
                                ),
                              ),
                              if (controller.lastHospitalization.value == 'Yes') ...[
                                const SizedBox(height: 12),
                                Text('reason_for_hospitalization'.tr, style: const TextStyle(fontSize: 13, color: AppColors.coolGray)),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.medicalGray),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: controller.hospitalizationReasonSelected.value,
                                      isExpanded: true,
                                      items: [
                                        'Select',
                                        'Heart attack',
                                        'Heart failure',
                                        'High blood pressure',
                                        'Stroke',
                                        'Diabetes complications',
                                        'other'
                                      ].map((v) => DropdownMenuItem(value: v, child: Text(v == 'Select' ? 'select'.tr : v == 'Heart attack' ? 'heart_attack'.tr : v == 'Heart failure' ? 'heart_failure'.tr : v == 'High blood pressure' ? 'high_blood_pressure'.tr : v == 'Stroke' ? 'stroke'.tr : v == 'Diabetes complications' ? 'diabetes_complications'.tr : 'other'.tr))).toList(),
                                      onChanged: (val) => controller.hospitalizationReasonSelected.value = val ?? 'Select',
                                    ),
                                  ),
                                ),
                                if (controller.hospitalizationReasonSelected.value == 'other') ...[
                                  const SizedBox(height: 12),
                                  TextField(
                                    controller: controller.hospitalizationReasonCustomController,
                                    decoration: InputDecoration(
                                      labelText: 'enter_other_hospitalization_reason'.tr,
                                      border: const OutlineInputBorder(),
                                    ),
                                  ),
                                ],
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),

                    // --- BP Measurement Vitals Again ---
                    if (controller.haveBPApparatus.value) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset('assets/images/m_bp.png', width: 65, height: 65),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'vitals_bp_measurement'.tr,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: controller.systolic3Controller,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText: 'systolic'.tr,
                                          border: const OutlineInputBorder(),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: TextField(
                                        controller: controller.diastolic3Controller,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText: 'diastolic'.tr,
                                          border: const OutlineInputBorder(),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: TextField(
                                        controller: controller.heartRate3Controller,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText: 'pulse_rate'.tr,
                                          border: const OutlineInputBorder(),
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.teal,
                                      foregroundColor: AppColors.white,
                                    ),
                                    icon: const Icon(Icons.bluetooth),
                                    label: Text('measure_bp'.tr),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                    ],

                    // Submit Button
                    AppPrimaryButton(
                      label: 'submit'.tr,
                      onPressed: () => controller.submitAll(),
                      backgroundColor: AppColors.success,
                      width: 160,
                      height: 46,
                      borderRadius: 6,
                      labelStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
              AppLoadingOverlay(isLoading: controller.isLoading.value),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildSubHeader(String title) {
    return Center(
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: AppColors.navy,
        ),
      ),
    );
  }

  void _showInfoDialog(String title, String message) {
    AppDialog.show(
      title: title,
      confirmLabel: 'ok'.tr,
      onConfirm: () => Get.back(),
      body: Text(message),
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: now,
    );
    if (picked != null) {
      controller.hba1cDateChoice.value = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  void _showHabitSuggestionDialog(String title, String message) {
    AppDialog.show(
      title: title,
      confirmLabel: 'ok_i_will_do'.tr,
      onConfirm: () => Get.back(),
      body: Text(message),
    );
  }
}
