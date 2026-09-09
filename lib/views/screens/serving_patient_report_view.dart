import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/serving_patient_controller.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/app_dialog.dart';
import '../widgets/app_folder_card.dart';
import '../widgets/app_primary_button.dart';
import '../widgets/app_report_tile.dart';
import '../widgets/get_reporting_dialog.dart';

class ServingPatientReportView extends GetView<ServingPatientController> {
  const ServingPatientReportView({super.key});

  static const List<Map<String, String>> allFolders = [
    {
      'title': 'Kidney function test',
      'countKey': 'kidneyCount',
      'checkKey': 'check_kidney',
    },
    {
      'title': 'ECG',
      'countKey': 'ecgCount',
      'checkKey': 'check_ecg',
    },
    {
      'title': 'Liver function test',
      'countKey': 'liverCount',
      'checkKey': 'check_liver',
    },
    {
      'title': 'Lipid profile',
      'countKey': 'lipidProfileCount',
      'checkKey': 'check_lipidProfile',
    },
    {
      'title': 'Old Medicines',
      'countKey': 'oldMedCount',
      'checkKey': 'check_oldMed',
    },
    {
      'title': 'Echo',
      'countKey': 'echoCount',
      'checkKey': 'check_echo',
    },
    {
      'title': 'Sonography',
      'countKey': 'sonographyCount',
      'checkKey': 'check_sonography',
    },
    {
      'title': 'Hemoglobin',
      'countKey': 'hemoglobinCount',
      'checkKey': 'check_hemoglobin',
    },
    {
      'title': 'CT Scan/ MRI',
      'countKey': 'ctScanCount',
      'checkKey': 'check_ctScan',
    },
    {
      'title': 'HBA1C',
      'countKey': 'hba1cCount',
      'checkKey': 'check_hba1c',
    },
    {
      'title': 'Blood sugar',
      'countKey': 'sugarCount',
      'checkKey': 'check_sugar',
    },
    {
      'title': 'Retina Left',
      'countKey': 'retinaLeftCount',
      'checkKey': 'check_retinaLeft',
    },
    {
      'title': 'Retina Right',
      'countKey': 'retinaRightCount',
      'checkKey': 'check_retinaRight',
    },
    {
      'title': 'Uric acid and Vit D',
      'countKey': 'uricAcidCount',
      'checkKey': 'check_uricAcid',
    },
    {
      'title': 'Diabetic foot wound',
      'countKey': 'diabeticCount',
      'checkKey': 'check_diabetic',
    },
    {
      'title': 'Thyroid',
      'countKey': 'thyroidCount',
      'checkKey': 'check_thyroid',
    },
    {
      'title': 'PT INR',
      'countKey': 'ptInrCount',
      'checkKey': 'check_pt_inr',
    },
    {
      'title': 'Full Body Check',
      'countKey': 'fullBodyCheckCount',
      'checkKey': 'check_full_body',
    },
    {
      'title': 'Hemoglobin CBC',
      'countKey': 'hemoglobinCbcCount',
      'checkKey': 'check_hemoglobin_cbc',
    },
    {
      'title': 'Angiography',
      'countKey': 'angiographyCount',
      'checkKey': 'check_angiography',
    },
    {
      'title': 'Other',
      'countKey': 'otherCount',
      'checkKey': 'check_other',
    },
  ];

  static const List<String> allReportCategories = [
    'Kidney function test',
    'ECG',
    'Liver function test',
    'Lipid profile',
    'Old Medicines',
    'Echo',
    'Sonography',
    'Hemoglobin',
    'CT Scan/ MRI',
    'HBA1C',
    'Blood sugar',
    'Retina Left',
    'Retina Right',
    'Uric acid and Vit D',
    'Diabetic foot wound',
    'Thyroid',
    'PT INR',
    'Full Body Check',
    'Hemoglobin CBC',
    'Angiography',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedFolder = controller.selectedFolderReportName.value;
      if (selectedFolder.isNotEmpty) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            controller.selectedFolderReportName.value = '';
            controller.fetchReportCounts();
          },
          child: _buildFolderDetailScreen(context, selectedFolder),
        );
      }
      return _buildFoldersGridScreen(context);
    });
  }

  // ==========================================
  // Screen 1: Folders Grid View
  // ==========================================
  Widget _buildFoldersGridScreen(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row (Upload Button aligned to right)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppPrimaryButton(
                label: 'upload_report'.tr,
                width: 140,
                height: 38,
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
                onPressed: () => _openUploadReportFormDialog(context),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // All Report Folders Grid using AppFolderCard widget
          Obx(() {
            if (controller.isLoadingReports.value) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final countsMap = controller.reportCountsData;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 4,
                mainAxisSpacing: 0,
                childAspectRatio: 0.82,
              ),
              itemCount: allFolders.length,
              itemBuilder: (context, index) {
                final folder = allFolders[index];
                final title = folder['title'] ?? '';
                final countKey = folder['countKey'] ?? '';
                final checkKey = folder['checkKey'] ?? '';

                final countVal = countsMap[countKey]?.toString() ?? '0';
                final checkVal = (countsMap[checkKey] is int)
                    ? countsMap[checkKey] as int
                    : (int.tryParse(countsMap[checkKey]?.toString() ?? '0') ?? 0);
                final hasNew = checkVal > 0;

                return AppFolderCard(
                  title: title,
                  count: countVal,
                  hasNew: hasNew,
                  onTap: () {
                    controller.fetchFolderReports(title);
                  },
                );
              },
            );
          }),
        ],
      ),
    );
  }

  // ==========================================
  // Screen 2: Folder Report List Screen with FAB
  // ==========================================
  Widget _buildFolderDetailScreen(BuildContext context, String folderTitle) {
    return Stack(
      children: [
        Column(
          children: [
            // Top Bar with Back Button & Folder Title
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              color: AppColors.lightGray,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppColors.navy),
                    onPressed: () {
                      controller.selectedFolderReportName.value = '';
                      controller.fetchReportCounts();
                    },
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      folderTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Reports List Area using AppReportTile widget
            Expanded(
              child: Obx(() {
                if (controller.isLoadingFolderReports.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final reports = controller.folderReportsList;
                if (reports.isEmpty) {
                  return Center(
                    child: Text(
                      'no_data_found'.tr,
                      style: const TextStyle(fontSize: 14, color: AppColors.coolGray),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: reports.length,
                  itemBuilder: (context, index) {
                    final item = reports[index];
                    final reportId = item['id']?.toString() ?? '';
                    final reportImg = item['report_img']?.toString() ?? '';
                    final reportName = item['report_name']?.toString() ?? folderTitle;
                    final uploadedOn = item['uploaded_on']?.toString() ?? '';
                    final isSeen = item['report_seen']?.toString() == '1';
                    final paymentStatus = item['payment_status']?.toString() ?? '1';
                    final reportFrom = item['report_from']?.toString() ?? '';

                    return AppReportTile(
                      reportName: reportName,
                      reportImgUrl: reportImg,
                      uploadedOn: uploadedOn,
                      isSeen: isSeen,
                      paymentStatus: paymentStatus,
                      reportFrom: reportFrom,
                      onConsultCardiologist: () {
                        GetReportingDialog.show(
                          context,
                          onSubmit: ({
                            required String hypertension,
                            required String diabetics,
                            required String heartAttack,
                            required String stroke,
                            required String thyroid,
                            required String systolicBp,
                            required String diastolicBp,
                            required String symptoms,
                          }) {
                            controller.submitCardiologistReport(
                              hypertension: hypertension,
                              diabetics: diabetics,
                              heartAttack: heartAttack,
                              stroke: stroke,
                              thyroid: thyroid,
                              systolicBp: systolicBp,
                              diastolicBp: diastolicBp,
                              symptoms: symptoms,
                              reportId: reportId,
                              reportImgName: reportImg,
                            );
                          },
                        );
                      },
                      onDelete: () {
                        AppDialog.show(
                          title: 'Delete Report',
                          body: const Text('Are you sure you want to delete this report?'),
                          confirmLabel: 'Yes',
                          cancelLabel: 'No',
                          onConfirm: () {
                            controller.deleteFolderReport(reportId);
                          },
                        );
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),

        // FAB Action to Upload Report directly in Folder Screen
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton(
            backgroundColor: AppColors.error,
            onPressed: () => _openUploadReportFormDialog(context, initialCategory: folderTitle),
            child: const Icon(Icons.add, color: AppColors.white, size: 28),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // Upload Report Dialog Form (Category + Image Capture/Picker & Live Preview)
  // ==========================================
  void _openUploadReportFormDialog(BuildContext context, {String? initialCategory}) {
    final RxString selectedCategory = (initialCategory ?? allReportCategories.first).obs;
    final RxString otherRemarks = ''.obs;
    final RxString selectedFilePath = ''.obs;
    final picker = ImagePicker();

    AppDialog.show(
      title: 'upload_report'.tr,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (initialCategory != null) ...[
              const Text(
                'Report Category:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.navy),
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.lightGray,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.medicalGray),
                ),
                child: Text(
                  initialCategory,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.navy),
                ),
              ),
            ] else ...[
              const Text(
                'Select Report Category:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.navy),
              ),
              const SizedBox(height: 6),
              Obx(() {
                return DropdownButtonFormField<String>(
                  isExpanded: true,
                  initialValue: allReportCategories.contains(selectedCategory.value)
                      ? selectedCategory.value
                      : allReportCategories.first,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  items: allReportCategories
                      .map((cat) => DropdownMenuItem(
                            value: cat,
                            child: Text(cat, overflow: TextOverflow.ellipsis),
                          ))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) selectedCategory.value = val;
                  },
                );
              }),
            ],
            const SizedBox(height: 12),

            Obx(() {
              if (selectedCategory.value != 'Other') {
                return const SizedBox.shrink();
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Other Remarks:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.navy),
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    onChanged: (val) => otherRemarks.value = val,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter report details...',
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              );
            }),

            const Text(
              'Attach Document / Photo:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.navy),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.camera_alt, color: AppColors.teal),
                    label: const Text('Camera'),
                    onPressed: () async {
                      final img = await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
                      if (img != null) selectedFilePath.value = img.path;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.photo_library, color: AppColors.blue),
                    label: const Text('Gallery'),
                    onPressed: () async {
                      final img = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
                      if (img != null) selectedFilePath.value = img.path;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Live Image / File Preview Box
            Obx(() {
              if (selectedFilePath.value.isEmpty) {
                return const Text(
                  'No file attached yet',
                  style: TextStyle(fontSize: 12, color: AppColors.error),
                );
              }

              final path = selectedFilePath.value;
              final fileName = path.split('/').last;
              final isImage = path.toLowerCase().endsWith('.jpg') ||
                  path.toLowerCase().endsWith('.jpeg') ||
                  path.toLowerCase().endsWith('.png');

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isImage)
                    Container(
                      height: 120,
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.medicalGray),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.file(
                          File(path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  Row(
                    children: [
                      const Icon(Icons.check_circle, color: AppColors.teal, size: 16),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          fileName,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.navy),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 18, color: AppColors.error),
                        onPressed: () => selectedFilePath.value = '',
                      ),
                    ],
                  ),
                ],
              );
            }),
            const SizedBox(height: 16),

            Obx(() {
              return SizedBox(
                width: double.infinity,
                child: AppPrimaryButton(
                  label: 'submit'.tr,
                  isLoading: controller.isLoadingReports.value,
                  onPressed: () {
                    if (selectedFilePath.value.isEmpty) {
                      Get.snackbar('Error', 'Please attach a report photo or document');
                      return;
                    }
                    Get.back();
                    controller.uploadReportFile(
                      reportName: selectedCategory.value,
                      filePath: selectedFilePath.value,
                      remarks: otherRemarks.value,
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
