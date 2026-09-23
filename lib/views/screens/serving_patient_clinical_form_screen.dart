import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/controllers/serving_patient_clinical_form_controller.dart';
import 'package:digi_icu_flutter/views/widgets/app_form_section_header.dart';
import 'package:digi_icu_flutter/views/widgets/app_primary_button.dart';
import 'package:digi_icu_flutter/views/widgets/app_loading_overlay.dart';
import 'package:digi_icu_flutter/views/widgets/app_dialog.dart';
import 'package:digi_icu_flutter/views/widgets/app_radio.dart';

class ServingPatientClinicalFormScreen extends StatelessWidget {
  const ServingPatientClinicalFormScreen({super.key});

  void _showInfoDialog(String title, String message) {
    AppDialog.show(
      title: title,
      body: Text(
        message,
        style: const TextStyle(fontSize: 14, color: AppColors.navy),
      ),
    );
  }

  Widget _buildPlaceItem({
    required ServingPatientClinicalFormController controller,
    required String label,
    required String placeKey,
    required String imageAssetPath,
  }) {
    return Obx(() {
      final isSelected = controller.place.value == placeKey;
      final borderColor = isSelected ? AppColors.error : AppColors.medicalGray;
      final borderWidth = isSelected ? 2.0 : 1.0;

      return GestureDetector(
        onTap: () => controller.selectPlace(placeKey),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                border: Border.all(color: borderColor, width: borderWidth),
                shape: BoxShape.circle,
                color: isSelected
                    ? AppColors.error.withValues(alpha: 0.05)
                    : AppColors.white,
              ),
              padding: const EdgeInsets.all(6),
              child: ClipOval(
                child: Image.asset(
                  imageAssetPath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.location_city,
                    color: AppColors.navy,
                    size: 30,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppColors.error : AppColors.navy,
              ),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ServingPatientClinicalFormController());

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.navy),
          onPressed: () => Get.back(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.patientName.isNotEmpty
                  ? '${'clinical_form_title'.tr} - ${controller.patientName}'
                  : 'serving_patient_clinical_form'.tr,
              style: const TextStyle(
                color: AppColors.navy,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
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
        return Stack(
          children: [
            IgnorePointer(
              ignoring: controller.isPatientMode.value,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ==========================================
                    // PLACE
                    // ==========================================
                    AppFormSectionHeader(title: 'header_place'.tr),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        'where_are_you_question'.tr,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.navy,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildPlaceItem(
                          controller: controller,
                          label: 'home'.tr,
                          placeKey: 'Home',
                          imageAssetPath: 'assets/images/house.png',
                        ),
                        _buildPlaceItem(
                          controller: controller,
                          label: 'office'.tr,
                          placeKey: 'Office',
                          imageAssetPath: 'assets/images/building.png',
                        ),
                        _buildPlaceItem(
                          controller: controller,
                          label: 'clinic_home_visit'.tr,
                          placeKey: 'Clinic',
                          imageAssetPath: 'assets/images/health_clinic.png',
                        ),
                        _buildPlaceItem(
                          controller: controller,
                          label: 'outdoor'.tr,
                          placeKey: 'Outdoor',
                          imageAssetPath: 'assets/images/warehouse.png',
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // ==========================================
                    // BP & OXYGEN LEVEL
                    // ==========================================
                    AppFormSectionHeader(title: 'header_bp_oxygen'.tr),
                    const SizedBox(height: 16),

                    // 1st BP Reading
                    Text(
                      'bp_question_1'.tr,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Obx(
                              () => Checkbox(
                                value: !controller.haveBPApparatus.value,
                                onChanged: (val) => controller
                                    .toggleBPApparatus(!(val ?? false)),
                                activeColor: AppColors.teal,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'no_bp_apparatus'.tr,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.navy,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Obx(() {
                          if (!controller.haveBPApparatus.value) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: controller.systolicController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: 'systolic_bp'.tr,
                                      border: const OutlineInputBorder(),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 8,
                                          ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: TextField(
                                    controller: controller.diastolicController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: 'diastolic_bp'.tr,
                                      border: const OutlineInputBorder(),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 8,
                                          ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: TextField(
                                    controller: controller.pulseRateController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: 'pulse_rate'.tr,
                                      border: const OutlineInputBorder(),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 8,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                    const Divider(height: 32),

                    // Oxygen Level
                    Text(
                      'oxygen_level_question_2'.tr,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => RadioGroup<String>(
                            groupValue: controller.spo2Choice.value,
                            onChanged: (val) =>
                                controller.spo2Choice.value = val ?? 'No',
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
                        ),
                        Obx(() {
                          if (controller.spo2Choice.value != 'Yes') {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: TextField(
                              controller: controller.spo2Controller,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'spo2_level_pct'.tr,
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                    const Divider(height: 32),

                    // Height & Weight
                    Text(
                      'height_weight_3'.tr,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller.heightController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'height_cm'.tr,
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: controller.weightController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'weight_kg'.tr,
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Obx(() {
                      if (controller.calculatedBmi.value.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          '${'bmi'.tr}: ${controller.calculatedBmi.value}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.teal,
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 28),

                    // ==========================================
                    // INVESTIGATIONS & ECG
                    // ==========================================
                    AppFormSectionHeader(title: 'header_investigations_ecg'.tr),
                    const SizedBox(height: 16),

                    Text(
                      'blood_investigations_header'.tr,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navy,
                      ),
                    ),
                    const Divider(height: 24),

                    // Blood Sugar Level
                    Row(
                      children: [
                        Obx(
                          () => Checkbox(
                            value: controller.checkSugarVal.value,
                            onChanged: (val) =>
                                controller.checkSugarVal.value = val ?? false,
                            activeColor: AppColors.teal,
                          ),
                        ),
                        Text(
                          'blood_sugar_level'.tr,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.navy,
                          ),
                        ),
                      ],
                    ),
                    Obx(() {
                      if (!controller.checkSugarVal.value) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(left: 12.0, top: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: controller.fastingController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'fasting'.tr,
                                  border: const OutlineInputBorder(),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 8,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: TextField(
                                controller: controller.afterFoodController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'after_food'.tr,
                                  border: const OutlineInputBorder(),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 8,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: TextField(
                                controller: controller.randomController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'random'.tr,
                                  border: const OutlineInputBorder(),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 8,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 12),

                    // Creatinine
                    Row(
                      children: [
                        Obx(
                          () => Checkbox(
                            value: controller.cbCreatinine.value,
                            onChanged: (val) =>
                                controller.cbCreatinine.value = val ?? false,
                            activeColor: AppColors.teal,
                          ),
                        ),
                        Text(
                          'creatinine'.tr,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.navy,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.info_outline,
                            color: AppColors.medicalGray,
                            size: 20,
                          ),
                          onPressed: () => _showInfoDialog(
                            'creatinine'.tr,
                            'creatinine_info_msg'.tr,
                          ),
                        ),
                      ],
                    ),
                    Obx(() {
                      if (!controller.cbCreatinine.value) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(left: 12.0, top: 8.0),
                        child: TextField(
                          controller: controller.creatinineController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'creatinine_unit'.tr,
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 12),

                    // HbA1c
                    Row(
                      children: [
                        Obx(
                          () => Checkbox(
                            value: controller.cbHba1c.value,
                            onChanged: (val) =>
                                controller.cbHba1c.value = val ?? false,
                            activeColor: AppColors.teal,
                          ),
                        ),
                        Text(
                          'hba1c'.tr,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.navy,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.info_outline,
                            color: AppColors.medicalGray,
                            size: 20,
                          ),
                          onPressed: () =>
                              _showInfoDialog('hba1c'.tr, 'hba1c_info_msg'.tr),
                        ),
                      ],
                    ),
                    Obx(() {
                      if (!controller.cbHba1c.value) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(left: 12.0, top: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: controller.hba1cController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'hba1c_unit'.tr,
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Obx(
                                  () => RadioGroup<String>(
                                    groupValue:
                                        controller.hba1cDateChoice.value,
                                    onChanged: (val) =>
                                        controller.hba1cDateChoice.value =
                                            val ?? 'Today',
                                    child: Row(
                                      children: [
                                        AppRadio<String>(value: 'Today'),
                                        Text('today'.tr),
                                        const SizedBox(width: 8),
                                        AppRadio<String>(value: 'Yesterday'),
                                        Text('yesterday'.tr),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () =>
                                        controller.selectHba1cDate(context),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: AppColors.medicalGray,
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Obx(
                                            () => Text(
                                              controller
                                                          .hba1cDateChoice
                                                          .value ==
                                                      'Today'
                                                  ? 'today'.tr
                                                  : controller
                                                            .hba1cDateChoice
                                                            .value ==
                                                        'Yesterday'
                                                  ? 'yesterday'.tr
                                                  : controller
                                                        .hba1cDateChoice
                                                        .value,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: AppColors.navy,
                                              ),
                                            ),
                                          ),
                                          const Icon(
                                            Icons.calendar_today,
                                            size: 16,
                                            color: AppColors.medicalGray,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 12),

                    // Total Cholesterol
                    Row(
                      children: [
                        Obx(
                          () => Checkbox(
                            value: controller.cbCholesterol.value,
                            onChanged: (val) =>
                                controller.cbCholesterol.value = val ?? false,
                            activeColor: AppColors.teal,
                          ),
                        ),
                        Text(
                          'total_cholesterol'.tr,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.navy,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.info_outline,
                            color: AppColors.medicalGray,
                            size: 20,
                          ),
                          onPressed: () => _showInfoDialog(
                            'total_cholesterol'.tr,
                            'total_cholesterol_info_msg'.tr,
                          ),
                        ),
                      ],
                    ),
                    Obx(() {
                      if (!controller.cbCholesterol.value) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(left: 12.0, top: 8.0),
                        child: Column(
                          children: [
                            TextField(
                              controller: controller.totalCholesterolController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'total_cholesterol_unit'.tr,
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
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
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 8,
                                          ),
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
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 8,
                                          ),
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
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 8,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 12),

                    // Uric Acid
                    Row(
                      children: [
                        Obx(
                          () => Checkbox(
                            value: controller.cbUricAcid.value,
                            onChanged: (val) =>
                                controller.cbUricAcid.value = val ?? false,
                            activeColor: AppColors.teal,
                          ),
                        ),
                        Text(
                          'uric_acid'.tr,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.navy,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.info_outline,
                            color: AppColors.medicalGray,
                            size: 20,
                          ),
                          onPressed: () => _showInfoDialog(
                            'uric_acid'.tr,
                            'uric_acid_info_msg'.tr,
                          ),
                        ),
                      ],
                    ),
                    Obx(() {
                      if (!controller.cbUricAcid.value) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(left: 12.0, top: 8.0),
                        child: TextField(
                          controller: controller.uricAcidController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'uric_acid_unit'.tr,
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 12),

                    // Urine Albumin
                    Row(
                      children: [
                        Obx(
                          () => Checkbox(
                            value: controller.cbUrineAlbumin.value,
                            onChanged: (val) =>
                                controller.cbUrineAlbumin.value = val ?? false,
                            activeColor: AppColors.teal,
                          ),
                        ),
                        Text(
                          'urine_albumin'.tr,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.navy,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.info_outline,
                            color: AppColors.medicalGray,
                            size: 20,
                          ),
                          onPressed: () => _showInfoDialog(
                            'urine_albumin'.tr,
                            'urine_albumin_info_msg'.tr,
                          ),
                        ),
                      ],
                    ),
                    Obx(() {
                      if (!controller.cbUrineAlbumin.value) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(left: 12.0, top: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RadioGroup<String>(
                              groupValue: controller.urineAlbuminType.value,
                              onChanged: (val) =>
                                  controller.urineAlbuminType.value =
                                      val ?? 'Numeric',
                              child: Row(
                                children: [
                                  AppRadio<String>(value: 'Numeric'),
                                  Text('numeric'.tr),
                                  const SizedBox(width: 16),
                                  AppRadio<String>(value: 'Value'),
                                  Text('value'.tr),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (controller.urineAlbuminType.value == 'Numeric')
                              TextField(
                                controller:
                                    controller.urineAlbuminNumericController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'enter_numeric_value'.tr,
                                  border: const OutlineInputBorder(),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                              )
                            else
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.medicalGray,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: controller
                                        .urineAlbuminValueSelected
                                        .value,
                                    isExpanded: true,
                                    items: [
                                      DropdownMenuItem(
                                        value: 'Select',
                                        child: Text('select'.tr),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Negative',
                                        child: Text('negative'.tr),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Trace',
                                        child: Text('trace'.tr),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Positive',
                                        child: Text('positive'.tr),
                                      ),
                                    ],
                                    onChanged: (val) =>
                                        controller
                                                .urineAlbuminValueSelected
                                                .value =
                                            val ?? 'Select',
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 12),

                    // ECG Section
                    Row(
                      children: [
                        Obx(
                          () => Checkbox(
                            value: controller.cbEcg.value,
                            onChanged: (val) =>
                                controller.cbEcg.value = val ?? false,
                            activeColor: AppColors.teal,
                          ),
                        ),
                        Text(
                          'ecg'.tr,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.navy,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.info_outline,
                            color: AppColors.medicalGray,
                            size: 20,
                          ),
                          onPressed: () =>
                              _showInfoDialog('ecg'.tr, 'ecg_info_msg'.tr),
                        ),
                      ],
                    ),
                    Obx(() {
                      if (!controller.cbEcg.value) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(left: 12.0, top: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'upload_ecg_image'.tr,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.navy,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => controller.pickEcgImage(
                                      ImageSource.gallery,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.teal,
                                      foregroundColor: AppColors.white,
                                    ),
                                    icon: const Icon(
                                      Icons.photo_library,
                                      size: 18,
                                    ),
                                    label: Text('gallery'.tr),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => controller.pickEcgImage(
                                      ImageSource.camera,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.teal,
                                      foregroundColor: AppColors.white,
                                    ),
                                    icon: const Icon(
                                      Icons.camera_alt,
                                      size: 18,
                                    ),
                                    label: Text('camera'.tr),
                                  ),
                                ),
                              ],
                            ),
                            Obx(() {
                              if (controller.ecgReportImages.isEmpty) {
                                return const SizedBox.shrink();
                              }
                              return Container(
                                height: 80,
                                margin: const EdgeInsets.only(top: 12),
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: controller.ecgReportImages.length,
                                  separatorBuilder: (context, itemIndex) =>
                                      const SizedBox(width: 8),
                                  itemBuilder: (context, index) {
                                    final img =
                                        controller.ecgReportImages[index];
                                    return Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                          child: Image.file(
                                            File(img.path),
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () => controller
                                                .removeEcgImage(index),
                                            child: Container(
                                              color: AppColors.coolGray,
                                              child: const Icon(
                                                Icons.close,
                                                color: AppColors.white,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              );
                            }),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.teal,
                                      foregroundColor: AppColors.white,
                                    ),
                                    child: Text(
                                      'short_ecg'.tr,
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.teal,
                                      foregroundColor: AppColors.white,
                                    ),
                                    child: Text(
                                      'record_12_lead_ecg'.tr,
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 12),

                    // Thyroid
                    Row(
                      children: [
                        Obx(
                          () => Checkbox(
                            value: controller.cbThyroid.value,
                            onChanged: (val) =>
                                controller.cbThyroid.value = val ?? false,
                            activeColor: AppColors.teal,
                          ),
                        ),
                        Text(
                          'thyroid'.tr,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.navy,
                          ),
                        ),
                      ],
                    ),
                    Obx(() {
                      if (!controller.cbThyroid.value) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(left: 12.0, top: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: controller.t3Controller,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 't3'.tr,
                                  border: const OutlineInputBorder(),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 8,
                                  ),
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
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 8,
                                  ),
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
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 8,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 28),

                    // ==========================================
                    // SYMPTOMS
                    // ==========================================
                    AppFormSectionHeader(title: 'header_symptoms'.tr),
                    const SizedBox(height: 16),

                    // 1. Feeling compared to last visit
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'pt_feeling_as_compared_to_last_visit'.tr,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.navy,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Obx(
                          () => RadioGroup<String>(
                            groupValue: controller.feelingCompared.value,
                            onChanged: (val) =>
                                controller.feelingCompared.value =
                                    val ?? 'Good',
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    AppRadio<String>(value: 'Good'),
                                    Text('pt_good'.tr),
                                  ],
                                ),
                                Row(
                                  children: [
                                    AppRadio<String>(value: 'Better'),
                                    Text('pt_better'.tr),
                                  ],
                                ),
                                Row(
                                  children: [
                                    AppRadio<String>(value: 'Same'),
                                    Text('pt_same'.tr),
                                  ],
                                ),
                                Row(
                                  children: [
                                    AppRadio<String>(value: 'More Suffering'),
                                    Text('pt_more_suffering'.tr),
                                  ],
                                ),
                                Row(
                                  children: [
                                    AppRadio<String>(
                                      value: 'First Consultation',
                                    ),
                                    Text('pt_this_is_my_first_consultation'.tr),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),

                    // 2. Chest Pain
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'pt_do_you_chest_pain'.tr,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.navy,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Obx(
                          () => RadioGroup<String>(
                            groupValue: controller.chestPain.value,
                            onChanged: (val) =>
                                controller.chestPain.value = val ?? 'No',
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
                        ),
                        Obx(() {
                          if (controller.chestPain.value != 'Yes') {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'pt_with_sweating'.tr,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.navy,
                                  ),
                                ),
                                RadioGroup<String>(
                                  groupValue:
                                      controller.chestPainSweating.value,
                                  onChanged: (val) =>
                                      controller.chestPainSweating.value =
                                          val ?? 'No',
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
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                    const Divider(height: 24),

                    // 3. Difficulty in Breathing
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'pt_difficulty_in_breathing'.tr,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.navy,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Obx(
                          () => RadioGroup<String>(
                            groupValue: controller.difficultyBreathing.value,
                            onChanged: (val) =>
                                controller.difficultyBreathing.value =
                                    val ?? 'No',
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
                        ),
                        Obx(() {
                          if (controller.difficultyBreathing.value != 'Yes') {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'pt_breathing_while'.tr,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.navy,
                                  ),
                                ),
                                RadioGroup<String>(
                                  groupValue: controller.breathingWhile.value,
                                  onChanged: (val) =>
                                      controller.breathingWhile.value =
                                          val ?? 'Walking',
                                  child: Row(
                                    children: [
                                      AppRadio<String>(value: 'Walking'),
                                      Text('pt_walking'.tr),
                                      const SizedBox(width: 16),
                                      AppRadio<String>(value: 'At Rest'),
                                      Text('pt_at_rest'.tr),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                    const Divider(height: 24),

                    // 4. Palpitations
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'pt_do_you_palpitations'.tr,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.navy,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Obx(
                          () => RadioGroup<String>(
                            groupValue: controller.palpitations.value,
                            onChanged: (val) =>
                                controller.palpitations.value = val ?? 'No',
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
                        ),
                      ],
                    ),
                    const Divider(height: 24),

                    // 5. Giddiness
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'pt_do_you_giddiness'.tr,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.navy,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Obx(
                          () => RadioGroup<String>(
                            groupValue: controller.giddiness.value,
                            onChanged: (val) =>
                                controller.giddiness.value = val ?? 'No',
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
                        ),
                      ],
                    ),
                    const Divider(height: 24),

                    // 6. Headache
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'pt_do_you_headache'.tr,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.navy,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Obx(
                          () => RadioGroup<String>(
                            groupValue: controller.headache.value,
                            onChanged: (val) =>
                                controller.headache.value = val ?? 'No',
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
                        ),
                      ],
                    ),
                    const Divider(height: 24),

                    // 7. Feel Dizziness
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'pt_do_you_feel_dizziness'.tr,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.navy,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Obx(
                          () => RadioGroup<String>(
                            groupValue: controller.feelDizziness.value,
                            onChanged: (val) =>
                                controller.feelDizziness.value = val ?? 'No',
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
                        ),
                        Obx(() {
                          if (controller.feelDizziness.value != 'Yes') {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller:
                                        controller.dizzinessSystolicController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: 'systolic_bp'.tr,
                                      border: const OutlineInputBorder(),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 8,
                                          ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    controller:
                                        controller.dizzinessDiastolicController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: 'diastolic_bp'.tr,
                                      border: const OutlineInputBorder(),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 8,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                    const Divider(height: 24),

                    // 8. Bleeding Episode
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'pt_do_you_bleeding_episode'.tr,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.navy,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Obx(
                          () => RadioGroup<String>(
                            groupValue: controller.bleedingEpisode.value,
                            onChanged: (val) =>
                                controller.bleedingEpisode.value = val ?? 'No',
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
                        ),
                      ],
                    ),
                    const Divider(height: 24),

                    // 9. Other Symptoms
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'pt_any_other_symptoms'.tr,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.navy,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: controller.otherSymptomsController,
                          decoration: InputDecoration(
                            labelText: 'pt_other_symptoms'.tr,
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // ==========================================
                    // VITALS AGAIN (2ND READING)
                    // ==========================================
                    AppFormSectionHeader(title: 'header_vitals_again_1'.tr),
                    const SizedBox(height: 16),

                    Text(
                      'second_bp_heading'.tr,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: controller.systolic2Controller,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'systolic_2'.tr,
                                  border: const OutlineInputBorder(),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 8,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: controller.diastolic2Controller,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'diastolic_2'.tr,
                                  border: const OutlineInputBorder(),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 8,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: controller.pulseRate2Controller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'pulse_rate_2'.tr,
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // ==========================================
                    // ABOUT HABITS
                    // ==========================================
                    AppFormSectionHeader(title: 'header_about_habits'.tr),
                    const SizedBox(height: 16),

                    // 1. Stop Smoking
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'pt_stop_smoking'.tr,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.navy,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Obx(
                          () => RadioGroup<String>(
                            groupValue: controller.stopSmoking.value,
                            onChanged: (val) =>
                                controller.stopSmoking.value = val ?? 'No',
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    AppRadio<String>(value: 'Yes'),
                                    Text('yes'.tr),
                                  ],
                                ),
                                Row(
                                  children: [
                                    AppRadio<String>(value: 'No'),
                                    Text('no'.tr),
                                  ],
                                ),
                                Row(
                                  children: [
                                    AppRadio<String>(value: 'Need Help'),
                                    Text('pt_need_help'.tr),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),

                    // 2. Stop Alcohol
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'pt_stop_alcohol'.tr,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.navy,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Obx(
                          () => RadioGroup<String>(
                            groupValue: controller.stopAlcohol.value,
                            onChanged: (val) =>
                                controller.stopAlcohol.value = val ?? 'No',
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    AppRadio<String>(value: 'Yes'),
                                    Text('yes'.tr),
                                  ],
                                ),
                                Row(
                                  children: [
                                    AppRadio<String>(value: 'No'),
                                    Text('no'.tr),
                                  ],
                                ),
                                Row(
                                  children: [
                                    AppRadio<String>(value: 'Need Help'),
                                    Text('pt_need_help'.tr),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),

                    // 3. Reduce Salt Intake
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'pt_reduce_salt_intake'.tr,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.navy,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Obx(
                          () => RadioGroup<String>(
                            groupValue: controller.reduceSaltIntake.value,
                            onChanged: (val) =>
                                controller.reduceSaltIntake.value = val ?? 'No',
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
                        ),
                      ],
                    ),
                    const Divider(height: 24),

                    // 4. Morning Walk
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'pt_morning_walk_sec4'.tr,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.navy,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Obx(
                          () => RadioGroup<String>(
                            groupValue: controller.morningWalk.value,
                            onChanged: (val) =>
                                controller.morningWalk.value = val ?? 'No',
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    AppRadio<String>(value: 'Yes'),
                                    Text('yes'.tr),
                                  ],
                                ),
                                Row(
                                  children: [
                                    AppRadio<String>(value: 'No'),
                                    Text('no'.tr),
                                  ],
                                ),
                                Row(
                                  children: [
                                    AppRadio<String>(
                                      value: 'Sometimes Missing',
                                    ),
                                    Text('pt_sometimes_missing'.tr),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),

                    // 5. Are you in stress
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'pt_are_you_in_stress'.tr,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.navy,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Obx(
                          () => RadioGroup<String>(
                            groupValue: controller.areYouInStress.value,
                            onChanged: (val) =>
                                controller.areYouInStress.value = val ?? 'No',
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
                        ),
                      ],
                    ),
                    const Divider(height: 24),

                    // 6. Miss medicine dose
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'pt_miss_medicine'.tr,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.navy,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Obx(
                          () => RadioGroup<String>(
                            groupValue: controller.missMedicine.value,
                            onChanged: (val) =>
                                controller.missMedicine.value = val ?? 'No',
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
                        ),
                      ],
                    ),
                    const Divider(height: 24),

                    // 7. Last Hospitalization
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'pt_last_hospitalization'.tr,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.navy,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Obx(
                          () => RadioGroup<String>(
                            groupValue: controller.lastHospitalization.value,
                            onChanged: (val) =>
                                controller.lastHospitalization.value =
                                    val ?? 'No',
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
                        ),
                        Obx(() {
                          if (controller.lastHospitalization.value != 'Yes') {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'pt_hospitalization_reason'.tr,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.navy,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColors.medicalGray,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: controller
                                          .hospitalizationReasonSelected
                                          .value,
                                      isExpanded: true,
                                      items: [
                                        DropdownMenuItem(
                                          value: 'Select',
                                          child: Text('select'.tr),
                                        ),
                                        DropdownMenuItem(
                                          value: 'Heart attack',
                                          child: Text('heart_attack'.tr),
                                        ),
                                        DropdownMenuItem(
                                          value: 'Heart failure',
                                          child: Text('heart_failure'.tr),
                                        ),
                                        DropdownMenuItem(
                                          value: 'High blood pressure',
                                          child: Text('high_blood_pressure'.tr),
                                        ),
                                        DropdownMenuItem(
                                          value: 'Stroke',
                                          child: Text('stroke'.tr),
                                        ),
                                        DropdownMenuItem(
                                          value: 'Diabetes complications',
                                          child: Text(
                                            'diabetes_complications'.tr,
                                          ),
                                        ),
                                        DropdownMenuItem(
                                          value: 'other',
                                          child: Text('other'.tr),
                                        ),
                                      ],
                                      onChanged: (val) =>
                                          controller
                                                  .hospitalizationReasonSelected
                                                  .value =
                                              val ?? 'Select',
                                    ),
                                  ),
                                ),
                                if (controller
                                        .hospitalizationReasonSelected
                                        .value ==
                                    'other') ...[
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller: controller
                                        .otherHospitalizationReasonController,
                                    decoration: InputDecoration(
                                      labelText:
                                          'enter_other_hospitalization_reason'
                                              .tr,
                                      border: const OutlineInputBorder(),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 8,
                                          ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // ==========================================
                    // VITALS AGAIN (3RD READING)
                    // ==========================================
                    AppFormSectionHeader(title: 'header_vitals_again_2'.tr),
                    const SizedBox(height: 16),

                    Text(
                      'third_bp_heading'.tr,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: controller.systolic3Controller,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'systolic_3'.tr,
                                  border: const OutlineInputBorder(),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 8,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: controller.diastolic3Controller,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'diastolic_3'.tr,
                                  border: const OutlineInputBorder(),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 8,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: controller.pulseRate3Controller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'pulse_rate_3'.tr,
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Submit / Update Button
                    AppPrimaryButton(
                      label: 'update'.tr,
                      onPressed: () => controller.submitForm(),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            AppLoadingOverlay(isLoading: controller.isLoading.value),
          ],
        );
      }),
    );
  }
}
