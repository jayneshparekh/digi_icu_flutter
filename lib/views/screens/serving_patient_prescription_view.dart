import 'package:digi_icu_flutter/controllers/serving_patient_controller.dart';
import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/views/widgets/app_dialog.dart';
import 'package:digi_icu_flutter/views/widgets/app_radio.dart';
import 'package:digi_icu_flutter/views/widgets/app_snackbars.dart';
import 'package:digi_icu_flutter/views/widgets/full_screen_image_viewer.dart';
import 'package:digi_icu_flutter/views/widgets/prescription_row_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServingPatientPrescriptionView extends GetView<ServingPatientController> {
  const ServingPatientPrescriptionView({super.key});

  void _showMedicineDetailsDialog(BuildContext context, Map<String, dynamic> data, String createdDate) {
    final List<dynamic> medicinesData = data['data'] as List<dynamic>? ?? [];
    final Map<String, dynamic>? adviceData = data['advice'] as Map<String, dynamic>?;
    final List<dynamic> investigationsData = data['investigations'] as List<dynamic>? ?? [];
    final Map<String, dynamic>? prescribedImages = data['prescribed_images'] as Map<String, dynamic>?;

    final List<String> imageUrls = [];
    if (prescribedImages != null) {
      if (prescribedImages['pres_image_1'] != null && prescribedImages['pres_image_1'].toString().isNotEmpty) {
        imageUrls.add(prescribedImages['pres_image_1'].toString());
      }
      if (prescribedImages['pres_image_2'] != null && prescribedImages['pres_image_2'].toString().isNotEmpty) {
        imageUrls.add(prescribedImages['pres_image_2'].toString());
      }
      if (prescribedImages['pres_image_3'] != null && prescribedImages['pres_image_3'].toString().isNotEmpty) {
        imageUrls.add(prescribedImages['pres_image_3'].toString());
      }
    }

    AppDialog.show(
      title: 'Prescription Details',
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header Info
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.lightGray,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Date: $createdDate',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy, fontSize: 13),
                    ),
                  ),
                  Text(
                    controller.fullName,
                    style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.blue, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Prescribed Images Section (if present)
            if (imageUrls.isNotEmpty) ...[
              const Text(
                'Prescribed Images',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy),
              ),
              const SizedBox(height: 6),
              SizedBox(
                height: 110,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: imageUrls.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final url = imageUrls[index];
                    return GestureDetector(
                      onTap: () => FullScreenImageViewer.show(context, url),
                      child: Container(
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.medicalGray),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            url,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Center(child: Icon(Icons.broken_image, color: AppColors.coolGray)),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Medicines List Section
            const Text(
              'Medicines',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy),
            ),
            const SizedBox(height: 6),
            if (medicinesData.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text('No medicines specified.', style: TextStyle(color: AppColors.coolGray, fontSize: 13)),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: medicinesData.length,
                separatorBuilder: (context, index) => const Divider(height: 12, color: AppColors.lightGray),
                itemBuilder: (context, index) {
                  final med = medicinesData[index] as Map<String, dynamic>;
                  final subMeds = med['medicines'] as List<dynamic>? ?? [];
                  final medNames = subMeds.map((m) => m['medicine_name']?.toString() ?? '').where((n) => n.isNotEmpty).join(', ');
                  final category = med['category_name']?.toString() ?? '';
                  final frequency = med['frequency']?.toString() ?? '';
                  final days = med['days']?.toString() ?? '';

                  return Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.medicalGray.withValues(alpha: 0.5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          medNames.isNotEmpty ? medNames : (category.isNotEmpty ? category : 'Medicine ${index + 1}'),
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy, fontSize: 13),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            if (frequency.isNotEmpty)
                              Expanded(
                                child: Text('Freq: $frequency', style: const TextStyle(fontSize: 12, color: AppColors.coolGray)),
                              ),
                            if (days.isNotEmpty)
                              Text('Duration: $days Days', style: const TextStyle(fontSize: 12, color: AppColors.coolGray)),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),

            const SizedBox(height: 12),

            // Advice Section (if available)
            if (adviceData != null && (adviceData['for_patient'] != null || adviceData['follow_date'] != null)) ...[
              const Text(
                'Advice & Follow-up',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy),
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.lightGray,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (adviceData['follow_date'] != null && adviceData['follow_date'].toString().isNotEmpty) ...[
                      Text(
                        'Follow-up Date: ${adviceData['follow_date']}',
                        style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.teal, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                    ],
                    if (adviceData['for_patient'] != null && adviceData['for_patient'].toString().isNotEmpty) ...[
                      Text(
                        'Patient Advice: ${adviceData['for_patient']}',
                        style: const TextStyle(color: AppColors.navy, fontSize: 12),
                      ),
                    ],
                    if (adviceData['for_leader'] != null && adviceData['for_leader'].toString().isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Leader Advice: ${adviceData['for_leader']}',
                        style: const TextStyle(color: AppColors.coolGray, fontSize: 12),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Investigations Section (if available)
            if (investigationsData.isNotEmpty) ...[
              const Text(
                'Investigations Requested',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy),
              ),
              const SizedBox(height: 4),
              Text(
                investigationsData.map((inv) => inv['investigations']?.toString() ?? '').where((s) => s.isNotEmpty).join(', '),
                style: const TextStyle(fontSize: 12, color: AppColors.coolGray),
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
      confirmLabel: 'Share',
      cancelLabel: 'Close',
      onConfirm: () {
        controller.sharePrescriptionPdf(createdDate, data);
      },
    );
  }

  Widget _buildActionButton({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 6.0),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          minimumSize: const Size(0, 36),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          elevation: 0,
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.lightGray,
      child: Column(
        children: [
          // Top Buttons Horizontal Scroll Bar
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              children: [
                _buildActionButton(
                  label: 'Prescription',
                  color: const Color(0xFFFF5722),
                  onTap: () => AppSnackbars.showInfo('Prescription', 'Feature coming soon.'),
                ),
                _buildActionButton(
                  label: 'Investigations',
                  color: AppColors.teal,
                  onTap: () => AppSnackbars.showInfo('Investigations', 'Feature coming soon.'),
                ),
                _buildActionButton(
                  label: 'Drug History',
                  color: AppColors.teal,
                  onTap: () => AppSnackbars.showInfo('Drug History', 'Feature coming soon.'),
                ),
                _buildActionButton(
                  label: 'Old Medicines',
                  color: AppColors.teal,
                  onTap: () => AppSnackbars.showInfo('Old Medicines', 'Feature coming soon.'),
                ),
              ],
            ),
          ),

          // Radio Selector Bar: IPD vs OPD
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            child: Obx(() {
              return RadioGroup<String>(
                groupValue: controller.prescriptionType.value,
                onChanged: (val) {
                  if (val != null) {
                    controller.fetchDoctorPrescription(val);
                  }
                },
                child: Row(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const AppRadio<String>(value: 'IPD'),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () => controller.fetchDoctorPrescription('IPD'),
                          child: Text(
                            'IPD',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: controller.prescriptionType.value == 'IPD' ? FontWeight.bold : FontWeight.normal,
                              color: AppColors.navy,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const AppRadio<String>(value: 'OPD'),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () => controller.fetchDoctorPrescription('OPD'),
                          child: Text(
                            'OPD',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: controller.prescriptionType.value == 'OPD' ? FontWeight.bold : FontWeight.normal,
                              color: AppColors.navy,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ),

          const Divider(height: 1, color: AppColors.medicalGray),

          // Prescription List Body
          Expanded(
            child: Obx(() {
              if (controller.isLoadingPrescriptions.value) {
                return const Center(child: CircularProgressIndicator(color: AppColors.teal));
              }

              if (controller.prescriptionList.isEmpty) {
                return const Center(
                  child: Text(
                    'No Data Available',
                    style: TextStyle(fontSize: 14, color: AppColors.coolGray, fontWeight: FontWeight.w500),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                itemCount: controller.prescriptionList.length,
                itemBuilder: (context, index) {
                  final item = controller.prescriptionList[index] as Map<String, dynamic>;
                  final visitNo = item['visit_no']?.toString() ?? item['visitNo']?.toString() ?? item['appointment_id']?.toString() ?? '';
                  final createdDate = item['created_date']?.toString() ?? item['date']?.toString() ?? item['created']?.toString() ?? 'N/A';
                  final presId = item['id']?.toString() ?? item['appointment_id']?.toString() ?? '';

                  return PrescriptionRowTile(
                    index: index + 1,
                    visitNo: visitNo,
                    date: createdDate,
                    onTap: () async {
                      if (presId.isNotEmpty) {
                        final details = await controller.fetchMedicineDetails(presId);
                        if (details != null && context.mounted) {
                          _showMedicineDetailsDialog(context, details, createdDate);
                        } else {
                          AppSnackbars.showError('Error', 'Failed to load medicine details.');
                        }
                      }
                    },
                  );
                },
              );
            }),

          ),
        ],
      ),
    );
  }
}
