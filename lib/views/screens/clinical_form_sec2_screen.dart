import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'dart:io';
import 'package:digi_icu_flutter/views/widgets/app_form_section_header.dart';
import 'package:digi_icu_flutter/views/widgets/app_loading_overlay.dart';
import 'package:digi_icu_flutter/views/widgets/app_teal_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../controllers/clinical_form_controller.dart';

class ClinicalFormSec2Screen extends GetView<ClinicalFormController> {
  const ClinicalFormSec2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Get.snackbar(
            'Action Required',
            "You cannot go back from this form.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
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
                            : 'Patient Name',
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              if (controller.doctorName.isNotEmpty)
                Text(
                  controller.doctorName,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ),
        body: Obx(() {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppFormSectionHeader(
                      subtitle: 'Clinical Form Section 2',
                      title: 'Investigations',
                    ),
                    const SizedBox(height: 24),

                    // Title Header with blue icon
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/m_glucometer.png', width: 65, height: 65),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Text(
                            'Do you have blood investigations to upload?',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32),

                    // --- BLOOD SUGAR LEVEL ---
                    Row(
                      children: [
                        Checkbox(
                          value: controller.checkSugarVal.value,
                          onChanged: (val) => controller.checkSugarVal.value = val ?? false,
                          activeColor: AppColors.primary,
                        ),
                        const Text(
                          'Blood Sugar Level :',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
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
                                decoration: const InputDecoration(
                                  labelText: 'Fasting',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: TextField(
                                controller: controller.afterFoodController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'After Food',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: TextField(
                                controller: controller.randomController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Random',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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

                    // --- CREATININE ---
                    Row(
                      children: [
                        Checkbox(
                          value: controller.cbCreatinine.value,
                          onChanged: (val) => controller.cbCreatinine.value = val ?? false,
                          activeColor: AppColors.primary,
                        ),
                        const Text(
                          'Creatinine',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
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
                            labelText: 'Creatinine (Kidney function test)',
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.info, color: Colors.grey),
                              onPressed: () => _showInfoDialog('Creatinine', 'Creatinine is a chemical waste product that\'s created by your muscle metabolism and to a smaller extent by eating meat. Healthy kidneys filter creatinine and other waste products from your blood.'),
                            ),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),

                    // --- HBA1C ---
                    Row(
                      children: [
                        Checkbox(
                          value: controller.cbHba1c.value,
                          onChanged: (val) => controller.cbHba1c.value = val ?? false,
                          activeColor: AppColors.primary,
                        ),
                        const Text(
                          'HbA1c',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
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
                                labelText: 'HbA1c',
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.info, color: Colors.grey),
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
                                          Radio<String>(
                                            value: 'Today',
                                            activeColor: AppColors.primary,
                                          ),
                                          const Text('Today'),
                                        ],
                                      ),
                                      const SizedBox(width: 8),
                                      Row(
                                        children: [
                                          Radio<String>(
                                            value: 'Yesterday',
                                            activeColor: AppColors.primary,
                                          ),
                                          const Text('Yesterday'),
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
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            controller.hba1cDateChoice.value,
                                            style: const TextStyle(fontSize: 13, color: Colors.black87),
                                          ),
                                          const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
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

                    // --- TOTAL CHOLESTEROL ---
                    Row(
                      children: [
                        Checkbox(
                          value: controller.cbCholesterol.value,
                          onChanged: (val) => controller.cbCholesterol.value = val ?? false,
                          activeColor: AppColors.primary,
                        ),
                        const Text(
                          'Total Cholesterol',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
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
                                labelText: 'Total Cholesterol (lipid profile)',
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.info, color: Colors.grey),
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
                                    decoration: const InputDecoration(
                                      labelText: 'HDL',
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: TextField(
                                    controller: controller.ldlController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: 'LDL',
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: TextField(
                                    controller: controller.vldlController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      labelText: 'VLDL',
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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

                    // --- URINE ALBUMIN ---
                    Row(
                      children: [
                        Checkbox(
                          value: controller.cbUrineAlbumin.value,
                          onChanged: (val) => controller.cbUrineAlbumin.value = val ?? false,
                          activeColor: AppColors.primary,
                        ),
                        const Text(
                          'Urine Albumin',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
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
                            const Text('Urine Albumin', style: TextStyle(fontSize: 13, color: Colors.black54)),
                            RadioGroup<String>(
                              groupValue: controller.urineAlbuminType.value,
                              onChanged: (val) => controller.urineAlbuminType.value = val ?? '',
                              child: Row(
                                children: [
                                  Row(
                                    children: [
                                      Radio<String>(
                                        value: 'Numeric',
                                        activeColor: AppColors.primary,
                                      ),
                                      const Text('Numeric'),
                                    ],
                                  ),
                                  const SizedBox(width: 16),
                                  Row(
                                    children: [
                                      Radio<String>(
                                        value: 'Value',
                                        activeColor: AppColors.primary,
                                      ),
                                      const Text('Value'),
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
                                  labelText: 'Enter Numeric',
                                  border: const OutlineInputBorder(),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.info, color: Colors.grey),
                                    onPressed: () => _showInfoDialog('Urine Albumin', 'Urine albumin is a test to detect small amounts of a blood protein (albumin) in your urine. An albumin test helps identify kidney disease.'),
                                  ),
                                ),
                              ),
                            ] else ...[
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: controller.urineAlbuminValueSelected.value,
                                    isExpanded: true,
                                    items: ['Select', 'Negative', 'Trace', 'Positive']
                                        .map((v) => DropdownMenuItem(value: v, child: Text(v)))
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
                          activeColor: AppColors.primary,
                        ),
                        const Text(
                          'ECG :',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        IconButton(
                          icon: const Icon(Icons.info, color: Colors.grey, size: 20),
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
                            const Text('Upload Image', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => controller.pickEcgImage(ImageSource.gallery),
                                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                                    icon: const Icon(Icons.photo_library),
                                    label: const Text('Gallery'),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => controller.pickEcgImage(ImageSource.camera),
                                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                                    icon: const Icon(Icons.camera_alt),
                                    label: const Text('Camera'),
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
                                              color: Colors.black54,
                                              child: const Icon(Icons.close, color: Colors.white, size: 16),
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
                            const Text('Record ECG', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                                    child: const Text('Short ECG (Health Monitor)', style: TextStyle(fontSize: 11)),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                                    child: const Text('Record 12 Lead ECG', style: TextStyle(fontSize: 11)),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Mock ECG Grid Wave
                            Container(
                              height: 120,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                color: Colors.grey.shade50,
                              ),
                              child: GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 20,
                                ),
                                itemCount: 100,
                                itemBuilder: (context, index) => Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(color: Colors.grey.shade200),
                                      right: BorderSide(color: Colors.grey.shade200),
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

                    // --- THYROID ---
                    Row(
                      children: [
                        Checkbox(
                          value: controller.cbThyroid.value,
                          onChanged: (val) => controller.cbThyroid.value = val ?? false,
                          activeColor: AppColors.primary,
                        ),
                        const Text(
                          'Thyroid',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
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
                                decoration: const InputDecoration(
                                  labelText: 'T3',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: TextField(
                                controller: controller.t4Controller,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'T4',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: TextField(
                                controller: controller.tshController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'TSH',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),

                    // --- URIC ACID ---
                    Row(
                      children: [
                        Checkbox(
                          value: controller.cbUricAcid.value,
                          onChanged: (val) => controller.cbUricAcid.value = val ?? false,
                          activeColor: AppColors.primary,
                        ),
                        const Text(
                          'Uric Acid',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
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
                            labelText: 'Uric Acid',
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.info, color: Colors.grey),
                              onPressed: () => _showInfoDialog('Uric Acid', 'Uric acid is a waste product found in blood. It\'s created when the body breaks down chemicals called purines. Most uric acid dissolves in blood, passes through the kidneys and leaves the body in urine.'),
                            ),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),

                    // --- OTHER INVESTIGATIONS ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Other Investigations?',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        RadioGroup<String>(
                          groupValue: controller.otherInvestigationsChoice.value,
                          onChanged: (val) => controller.otherInvestigationsChoice.value = val ?? 'No',
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  Radio<String>(
                                    value: 'Yes',
                                    activeColor: AppColors.primary,
                                  ),
                                  const Text('Yes'),
                                ],
                              ),
                              const SizedBox(width: 8),
                              Row(
                                children: [
                                  Radio<String>(
                                    value: 'No',
                                    activeColor: AppColors.primary,
                                  ),
                                  const Text('No'),
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
                        decoration: const InputDecoration(
                          labelText: 'Enter details of other investigations',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => controller.pickOtherImage(ImageSource.gallery),
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                              icon: const Icon(Icons.photo_library),
                              label: const Text('Gallery'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => controller.pickOtherImage(ImageSource.camera),
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                              icon: const Icon(Icons.camera_alt),
                              label: const Text('Camera'),
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
                                        color: Colors.black54,
                                        child: const Icon(Icons.close, color: Colors.white, size: 16),
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
                    const SizedBox(height: 40),

                    // Next Button
                    SizedBox(
                      width: 150,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () => controller.submitSec2(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success, // Green Next button
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          'Next',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
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



  void _showInfoDialog(String title, String content) {
    Get.dialog(
      AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final formatted = DateFormat('dd/MM/yyyy').format(picked);
      controller.hba1cDateChoice.value = formatted;
    }
  }
}


