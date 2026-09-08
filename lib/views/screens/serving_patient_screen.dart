import 'package:digi_icu_flutter/controllers/serving_patient_controller.dart';
import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/views/screens/serving_patient_dashboard_view.dart';
import 'package:digi_icu_flutter/views/screens/serving_patient_di_view.dart';
import 'package:digi_icu_flutter/views/screens/serving_patient_graph_view.dart';
import 'package:digi_icu_flutter/views/screens/serving_patient_prescription_view.dart';
import 'package:digi_icu_flutter/views/widgets/app_dialog.dart';
import 'package:digi_icu_flutter/views/widgets/app_loading_overlay.dart';
import 'package:digi_icu_flutter/views/widgets/patient_rating_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';


class ServingPatientScreen extends GetView<ServingPatientController> {
  const ServingPatientScreen({super.key});

  void _showEnlargedQRCode(BuildContext context, String qrCodeUrl) {
    AppDialog.show(
      title: 'patient_qr_code'.tr,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.medicalGray),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: qrCodeUrl.startsWith('http')
                  ? Image.network(
                      qrCodeUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(child: Icon(Icons.qr_code, size: 100, color: AppColors.medicalGray)),
                    )
                  : const Center(child: Icon(Icons.qr_code, size: 100, color: AppColors.medicalGray)),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '${'mhc_id_label'.tr}${controller.mhcId}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.navy),
          ),
        ],
      ),
    );
  }

  Widget _buildTopActionButton({
    required String svgName,
    required VoidCallback onTap,
    Color bg = AppColors.teal,
    bool visible = true,
  }) {
    if (!visible) return const SizedBox.shrink();
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            height: 38,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              'assets/icons/svg/$svgName.svg',
              colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomTabItem({
    required String tabName,
    required String svgName,
    required String tooltip,
  }) {
    return Obx(() {
      final isSelected = controller.currentTab.value == tabName;
      final bg = isSelected ? AppColors.warning : AppColors.teal;
      return Expanded(
        child: Tooltip(
          message: tooltip,
          child: Material(
            color: bg,
            child: InkWell(
              onTap: () => controller.changeTab(tabName),
              child: Container(
                height: 52,
                padding: const EdgeInsets.all(12.0),
                child: SvgPicture.asset(
                  'assets/icons/svg/$svgName.svg',
                  colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: SafeArea(
        child: Obx(() {
          final isPatientView = controller.userType.value == 'Patient' || controller.fromPatient;
          final hideHoldAndFinish = controller.selectTab == 'Served' || controller.status == 'Served' || controller.isFrom == 'Direct Patient Call';

          return Stack(
            children: [
              Column(
                children: [
                  // Top Bar Layout
                  Container(
                    color: AppColors.white,
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        // Patient Info Row
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Get.dialog(
                                    PatientRatingDialog(
                                      initialRating: controller.patientRating.value,
                                      onSubmit: (ratingVal) => controller.addRating(ratingVal),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.medicalGray),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                                  child: Text(
                                    '${controller.fullName} / ${controller.age} / ${controller.gender} / ${controller.mhcId} / ★ ${controller.patientRating.value}'
                                        .toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.navy,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // QR Code Thumbnail
                            GestureDetector(
                              onTap: () => _showEnlargedQRCode(context, controller.qrCode),
                              child: Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.medicalGray),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: controller.qrCode.startsWith('http')
                                      ? Image.network(
                                          controller.qrCode,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) =>
                                              Icon(Icons.qr_code, size: 24, color: AppColors.navy),
                                        )
                                      : Icon(Icons.qr_code, size: 24, color: AppColors.navy),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (!isPatientView) ...[
                          const SizedBox(height: 8),
                          // Action Row 1: Refer, Leader Call, Call, Admit, Hold
                          Row(
                            children: [
                              _buildTopActionButton(
                                svgName: 'ic_refer',
                                onTap: () => Get.rawSnackbar(message: 'refer_clicked'.tr),
                              ),
                              _buildTopActionButton(
                                svgName: 'ic_leader_call',
                                onTap: () => Get.rawSnackbar(message: 'leader_call_clicked'.tr),
                                bg: AppColors.error,
                              ),
                              _buildTopActionButton(
                                svgName: 'ic_baseline_phone_24',
                                onTap: () => Get.rawSnackbar(message: 'call_clicked'.tr),
                              ),
                              _buildTopActionButton(
                                svgName: 'ic_baseline_admit_24',
                                onTap: () => Get.rawSnackbar(message: 'admit_clicked'.tr),
                                bg: controller.isAdmitted == '1' ? AppColors.error : AppColors.teal,
                              ),
                              _buildTopActionButton(
                                svgName: 'ic_hold',
                                onTap: () => Get.rawSnackbar(message: 'hold_clicked'.tr),
                                visible: !hideHoldAndFinish,
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 6),
                        // Action Row 2: Reload, Home, Start Video, Join Video, Finish
                        Row(
                          children: [
                            _buildTopActionButton(
                              svgName: 'ic_refresh',
                              onTap: () => controller.fetchPatientDetails(),
                              visible: !isPatientView,
                            ),
                            _buildTopActionButton(
                              svgName: 'ic_home',
                              onTap: () => Get.back(),
                              visible: !isPatientView && controller.status == 'Served',
                            ),
                            _buildTopActionButton(
                              svgName: 'ic_start_video_call',
                              onTap: () => Get.rawSnackbar(message: 'start_video_call_clicked'.tr),
                            ),
                            _buildTopActionButton(
                              svgName: 'ic_incoming_call',
                              onTap: () => Get.rawSnackbar(message: 'join_call_clicked'.tr),
                            ),
                            _buildTopActionButton(
                              svgName: 'ic_finish',
                              onTap: () => Get.rawSnackbar(message: 'finish_clicked'.tr),
                              visible: !isPatientView && !hideHoldAndFinish,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, thickness: 1),
                  // Center View area
                  Expanded(
                    child: Obx(() {
                      switch (controller.currentTab.value) {
                        case 'Dashboard':
                          return const ServingPatientDashboardView();
                        case 'Graph':
                          return const ServingPatientGraphView();
                        case 'Prescription':
                          return const ServingPatientPrescriptionView();
                        case 'Form':
                          return Center(child: Text('form_placeholder'.tr, style: TextStyle(fontSize: 16, color: AppColors.medicalGray)));
                        case 'DI':
                          return const ServingPatientDiView();
                        case 'Reports':
                          return Center(child: Text('reports_placeholder'.tr, style: TextStyle(fontSize: 16, color: AppColors.medicalGray)));
                        default:
                          return const ServingPatientDashboardView();
                      }
                    }),
                  ),
                  // Bottom Tabs layout (hidden if patient view)
                  if (!isPatientView)
                    Row(
                      children: [
                        _buildBottomTabItem(tabName: 'Dashboard', svgName: 'ic_dashboard', tooltip: 'Dashboard'),
                        _buildBottomTabItem(tabName: 'Graph', svgName: 'ic_graph', tooltip: 'Graph'),
                        _buildBottomTabItem(tabName: 'Prescription', svgName: 'ic_prescription', tooltip: 'Prescription'),
                        _buildBottomTabItem(tabName: 'Form', svgName: 'ic_my_forms', tooltip: 'Form'),
                        _buildBottomTabItem(tabName: 'DI', svgName: 'ic_doctor_interpretation', tooltip: 'DI'),
                        _buildBottomTabItem(tabName: 'Reports', svgName: 'ic_reports', tooltip: 'Reports'),
                      ],
                    ),
                ],
              ),
              AppLoadingOverlay(isLoading: controller.isLoadingDetails.value),
            ],
          );
        }),
      ),
    );
  }
}
