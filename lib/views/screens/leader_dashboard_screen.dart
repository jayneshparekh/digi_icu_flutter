import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controllers/leader_dashboard_controller.dart';
import '../../core/theme/app_colors.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/leader_side_menu.dart';

class LeaderDashboardScreen extends GetView<LeaderDashboardController> {
  const LeaderDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );

    return Scaffold(
      backgroundColor: AppColors.lightGray,
      drawer: const LeaderSideMenu(),
      appBar: AppBar(
        backgroundColor: AppColors.teal,
        elevation: 0,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: AppColors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: Obx(() {
          final displayName = controller.instituteShortName.value.isNotEmpty
              ? controller.instituteShortName.value
              : (controller.leaderName.value.isNotEmpty
                  ? controller.leaderName.value
                  : 'leader_dashboard'.tr);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                displayName,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'reception'.tr,
                style: TextStyle(
                  color: AppColors.white.withValues(alpha: 0.85),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          );
        }),
        actions: [
          // Circular Logo Image
          Center(
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white,
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
            icon: const Icon(Icons.more_vert, color: AppColors.white),
            onSelected: (value) {
              if (value == 'logout') {
                _showLogoutConfirmDialog(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
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
                    // Manage Patients Card (ID 0)
                    DashboardCard(
                      title: 'manage_patients'.tr,
                      iconPath: 'assets/icons/svg/ic_person_add.svg',
                      onTap: controller.openManagePatients,
                    ),
                    // IPD Patient List Card (ID 16)
                    DashboardCard(
                      title: 'ipd_patients'.tr,
                      iconPath: 'assets/icons/svg/ic_ipd_patient.svg',
                      onTap: controller.openIpdPatients,
                    ),
                    // Admit Request Card (ID 22)
                    Obx(() {
                      return DashboardCard(
                        title: 'admit_request'.tr,
                        iconPath: 'assets/icons/svg/ic_ipd_patient.svg',
                        badgeText: controller.hasNewAdmitRequests.value
                            ? 'new_badge'.tr
                            : null,
                        onTap: controller.openAdmitRequest,
                      );
                    }),
                    // Discharge Request Card (ID 20)
                    Obx(() {
                      return DashboardCard(
                        title: 'discharge_request'.tr,
                        iconPath: 'assets/icons/svg/ic_ipd_patient.svg',
                        badgeText: controller.hasNewDischargeRequests.value
                            ? 'new_badge'.tr
                            : null,
                        onTap: controller.openDischargeRequest,
                      );
                    }),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('logout'.tr),
        content: Text('are_you_sure_logout'.tr),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('cancel'.tr),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.teal,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              controller.logout();
            },
            child: Text(
              'logout'.tr,
              style: const TextStyle(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }
}
