import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../controllers/doctor_dashboard_controller.dart';
import '../widgets/app_drawing_canvas.dart';
import '../widgets/app_speech_input_widget.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/doctor_side_menu.dart';

class DoctorDashboardScreen extends GetView<DoctorDashboardController> {
  const DoctorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure overlays are active and styled when build is called
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );

    // Check and trigger orientation layout dialog after the screen is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (controller.isDialogShown.value) return;

      final shortestSide = MediaQuery.of(context).size.shortestSide;
      final isConfigured = await controller.checkAndApplyOrientation(
        shortestSide,
      );
      if (!context.mounted) return;
      if (!isConfigured && !controller.isDialogShown.value) {
        controller.isDialogShown.value = true;
        _showLayoutDialog(context);
      }
    });

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      drawer: const DoctorSideMenu(),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        // Teal background matching design
        elevation: 0,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Dr. ${controller.doctorName.value}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                controller.userType.value,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          );
        }),
        actions: [
          // QR Code Icon
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SvgPicture.asset(
                'assets/icons/svg/qr_code_scan.svg',
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
                width: 24,
                height: 24,
              ),
            ),
          ),
          // Circular Logo Image
          Center(
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/digi_icu_logo.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // 3-dot Popup Menu
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == 'logout') {
                controller.logout();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'wallet',
                  child: Text('my_wallet'.tr),
                ),
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Text('logout'.tr),
                ),
              ];
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final isLandscape =
                    MediaQuery.of(context).orientation == Orientation.landscape;
                final crossAxisCount = isLandscape ? 5 : 3;
                final childAspectRatio = isLandscape ? 1.3 : 0.85;

                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: childAspectRatio,
                  children: [
                    // Patient List Card
                    DashboardCard(
                      title: 'patient_list'.tr,
                      iconPath: 'assets/icons/svg/ic_patient_list.svg',
                      onTap: () {
                        if (controller.accountStatus.value == '2') {
                          _showPendingRegistrationDialog(context);
                        } else {
                          Get.toNamed('/patient-list');
                        }
                      },
                    ),
                    // Manage Patients Card
                    DashboardCard(
                      title: 'manage_patients'.tr,
                      iconPath: 'assets/icons/svg/ic_person_add.svg',
                      onTap: () {
                        if (controller.accountStatus.value == '2') {
                          _showPendingRegistrationDialog(context);
                        } else {
                          Get.toNamed('/manage-patients');
                        }
                      },
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            AppDrawingCanvas(
              height: 450,
              onSave: (bytes) {
                Get.snackbar(
                  'drawing_saved'.tr,
                  'canvas_image_generated'.trParams({'bytes': bytes.length.toString()}),
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColors.primary,
                  colorText: Colors.white,
                );
              },
            ),
            const SizedBox(height: 16),
            AppSpeechInputWidget(
              controller: controller.noteTextController,
              label: 'voice_input'.tr,
              hintText: 'type_or_speak_notes'.tr,
              height: 120,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showLayoutDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24),
        actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        title: Text(
          'select_layout'.tr,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'recommended_layout_desc'.tr,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Obx(() {
              return Column(
                children: [
                  RadioGroup<String>(
                    groupValue: controller.selectedOrientation.value,
                    onChanged: (val) {
                      if (val != null) {
                        controller.selectedOrientation.value = val;
                      }
                    },
                    child: Column(
                      children: [
                        RadioListTile<String>(
                          value: 'portrait',
                          title: Text(
                            'portrait_vertical'.tr,
                            style: const TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                          activeColor: AppColors.info,
                          contentPadding: EdgeInsets.zero,
                        ),
                        RadioListTile<String>(
                          value: 'landscape',
                          title: Text(
                            'landscape_horizontal'.tr,
                            style: const TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                          activeColor: AppColors.info,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  CheckboxListTile(
                    value: controller.setAsDefault.value,
                    onChanged: (val) {
                      if (val != null) controller.setAsDefault.value = val;
                    },
                    title: Text(
                      'set_orientation_default'.tr,
                      style: const TextStyle(fontSize: 15, color: Colors.black87),
                    ),
                    activeColor: AppColors.info,
                    checkColor: Colors.white,
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              );
            }),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.saveAndApplySelectedOrientation();
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: Text(
              'apply'.tr,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _showPendingRegistrationDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Text(
            'warning'.tr,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          content: Text(
            'registration_pending_msg'.tr,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'okay'.tr,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'cancel'.tr,
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}


