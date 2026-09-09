import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import 'full_screen_image_viewer.dart';

/// Reusable report card item widget for rendering individual uploaded reports.
class AppReportTile extends StatelessWidget {
  final String reportName;
  final String reportImgUrl;
  final String uploadedOn;
  final bool isSeen;
  final String paymentStatus;
  final String reportFrom;
  final VoidCallback onDelete;
  final VoidCallback? onConsultCardiologist;

  const AppReportTile({
    super.key,
    required this.reportName,
    required this.reportImgUrl,
    required this.uploadedOn,
    this.isSeen = true,
    this.paymentStatus = '1',
    this.reportFrom = '',
    required this.onDelete,
    this.onConsultCardiologist,
  });

  @override
  Widget build(BuildContext context) {
    // Show 'Report from Cardiologist' button if ECG and payment pending/ecg franchise
    final showConsultCardiologist = (reportName.toUpperCase().contains('ECG') && (paymentStatus == '2' || paymentStatus == '0')) || (reportFrom == 'ecg_franchise');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          if (reportImgUrl.isNotEmpty) {
            FullScreenImageViewer.show(context, reportImgUrl, title: reportName);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (reportImgUrl.isNotEmpty)
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        reportImgUrl,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 140,
                          color: AppColors.lightGray,
                          child: const Center(
                            child: Icon(Icons.insert_drive_file, size: 48, color: AppColors.medicalGray),
                          ),
                        ),
                      ),
                    ),
                    if (!isSeen)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'N',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.white),
                          ),
                        ),
                      ),
                  ],
                ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reportName,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.navy),
                        ),
                        if (uploadedOn.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 13, color: AppColors.coolGray),
                              const SizedBox(width: 4),
                              Text(
                                uploadedOn,
                                style: const TextStyle(fontSize: 12, color: AppColors.coolGray),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: AppColors.error),
                    onPressed: onDelete,
                  ),
                ],
              ),
              if (showConsultCardiologist && onConsultCardiologist != null) ...[
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.medical_services_outlined, size: 16, color: AppColors.white),
                    label: Text(
                      'consult_cardiologist'.tr,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.teal,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    onPressed: onConsultCardiologist,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
