import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/patient_dashboard_controller.dart';
import '../widgets/app_status_badge.dart';
import '../widgets/marquee_text.dart';
import '../widgets/patient_dashboard_widgets.dart';
import '../widgets/dashboard_card.dart';

class PatientDashboardScreen extends GetView<PatientDashboardController> {
  const PatientDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBg,
      appBar: AppBar(
        backgroundColor: AppColors.primary, // Teal background matching toolbar
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        toolbarHeight: 64,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              // Back Button
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: SvgPicture.asset(
                  'assets/icons/svg/ic_back.svg',
                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  width: 26,
                  height: 26,
                ),
                onPressed: () => Get.back(),
              ),
              const SizedBox(width: 8),
              // Patient Name & Doctor Details Header
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      controller.userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Obx(() {
                      return Text(
                        'Dr. ${controller.doctorName.value}',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          // Circular Logo Image on the Right
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/digi_icu_logo.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.local_hospital, color: AppColors.primary);
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Divider Line
          Container(
            height: 1,
            color: Colors.grey.shade200,
          ),
          // Top Layout Section (llTop)
          Container(
            color: AppColors.secondary, // medium teal matching mockup
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  final formattedDate = controller.getFormattedFollowDate();
                  if (formattedDate.isEmpty) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Text(
                      '${'next_follow_up_date'.tr} $formattedDate',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  );
                }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'recommended'.tr,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Row(
                      children: [
                        _buildBadgeButton('about_app'.tr, AppColors.primary),
                        const SizedBox(width: 8),
                        _buildBadgeButton('share_app'.tr, AppColors.primary),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Recommended horizontal grid items
                Obx(() {
                  final currentUserType = controller.type;
                  final isAdmitted = controller.rxIsAdmitted.value;
                  final showDigiIcu = (currentUserType == "Doctor" || currentUserType == "Nurse" || currentUserType == "Digi Icu Nurse" || currentUserType == "Leader") && isAdmitted == "1";

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: PatientDashboardCircleBtn(
                          iconPath: 'assets/icons/svg/ic_doctor_appointment.svg',
                          label: 'doctor_appointment'.tr,
                          onTap: () => controller.handleDoctorAppointmentTap(),
                        ),
                      ),
                      Expanded(
                        child: PatientDashboardCircleBtn(
                          iconPath: 'assets/icons/svg/ic_prescription.svg',
                          label: 'prescription'.tr,
                          onTap: () {},
                        ),
                      ),
                      Expanded(
                        child: PatientDashboardCircleBtn(
                          iconPath: 'assets/icons/svg/ic_chest_pain_help.svg',
                          iconColor: Colors.red,
                          label: 'chest_pain_help'.tr,
                          onTap: () {},
                        ),
                      ),
                      if (showDigiIcu)
                        Expanded(
                          child: PatientDashboardCircleBtn(
                            iconPath: 'assets/images/digi_icu.png',
                            label: 'digi_icu'.tr,
                            onTap: () {},
                          ),
                        ),
                    ],
                  );
                }),
              ],
            ),
          ),
          // Scrollable content area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Emergency Services Section
                  Text(
                    'emergency_services'.tr,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: PatientDashboardCard(
                          iconPath: 'assets/icons/svg/ic_emergency_call.svg',
                          iconColor: Colors.red,
                          label: 'emergency_doctor'.tr,
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: PatientDashboardCard(
                          iconPath: 'assets/icons/svg/ic_ambulance.svg',
                          iconColor: Colors.red,
                          label: 'call_ambulance'.tr,
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Other Services Section
                  Text(
                    'other_services'.tr,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: PatientDashboardCard(
                          iconPath: 'assets/icons/svg/ic_specialist.svg',
                          label: 'consult_specialist'.tr,
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: BreathingColorWrapper(
                          baseColor: Colors.red,
                          builder: (context, animatedColor) {
                            return PatientDashboardCard(
                              iconPath: 'assets/icons/svg/ic_ecg.svg',
                              iconColor: animatedColor,
                              textColor: animatedColor,
                              label: 'ecg_at_home'.tr,
                              onTap: () {},
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Scrolling text marquee message
                  Obx(() {
                    if (controller.marqueeText.value.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      alignment: Alignment.center,
                      child: MarqueeText(text: controller.marqueeText.value),
                    );
                  }),
                  const SizedBox(height: 8),

                  // Home Image Slider loaded from API
                  Obx(() {
                    if (controller.homeSliders.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return PatientDashboardSlider(items: controller.homeSliders);
                  }),
                  const SizedBox(height: 16),

                  // Choose Package Section
                  Text(
                    'choose_package'.tr,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: PatientDashboardVerticalCard(
                          iconPath: 'assets/icons/svg/ic_specialist.svg', // Fallback icon for NRI package
                          label: 'nri_package'.tr,
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: PatientDashboardVerticalCard(
                          iconPath: 'assets/icons/svg/ic_doctor_appointment.svg', // Fallback for Mom Dad package
                          label: 'mom_dad_package'.tr,
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: PatientDashboardVerticalCard(
                          iconPath: 'assets/icons/svg/ic_prescription.svg', // Fallback for All Package
                          label: 'all_package'.tr,
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Upload Report Section
                  Text(
                    'upload_report'.tr,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PatientDashboardCircleBtn(
                        iconPath: 'assets/icons/svg/ic_ecg.svg',
                        label: 'ecg_report'.tr,
                        onTap: () {},
                      ),
                      PatientDashboardCircleBtn(
                        iconPath: 'assets/icons/svg/ic_specialist.svg',
                        label: 'sugar_report'.tr,
                        onTap: () {},
                      ),
                      PatientDashboardCircleBtn(
                        iconPath: 'assets/icons/svg/ic_prescription.svg',
                        label: 'old_medicines'.tr,
                        onTap: () {},
                      ),
                      PatientDashboardCircleBtn(
                        iconPath: 'assets/icons/svg/ic_patient_list.svg',
                        label: 'other_report'.tr,
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Categories Section
                  Text(
                    'categories'.tr,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Obx(() {
                    final list = <Map<String, String>>[
                      {'title': 'my_dashboard'.tr, 'icon': 'assets/icons/svg/ic_dashboard.svg'},
                      {'title': 'online_pharmacy'.tr, 'icon': 'assets/icons/svg/ic_online_pharmacy.svg'},
                      {'title': 'quick_form'.tr, 'icon': 'assets/icons/svg/ic_quick.svg'},
                      {'title': 'my_graphs'.tr, 'icon': 'assets/icons/svg/ic_graphs.svg'},
                      {'title': 'info_education'.tr, 'icon': 'assets/icons/svg/ic_info_education.svg'},
                      {'title': 'my_forms'.tr, 'icon': 'assets/icons/svg/ic_my_forms.svg'},
                      {'title': 'orders_status'.tr, 'icon': 'assets/icons/svg/ic_delivery.svg'},
                      {'title': 'collaborated_hospitals'.tr, 'icon': 'assets/icons/svg/ic_hospital_building.svg'},
                      {'title': 'screening'.tr, 'icon': 'assets/icons/svg/ic_screening.svg'},
                      {'title': 'health_monitor'.tr, 'icon': 'assets/icons/svg/ic_health_monitor.svg'},
                      {'title': 'stethoscope_device'.tr, 'icon': 'assets/icons/svg/ic_health_monitor.svg'},
                      {'title': 'family_member'.tr, 'icon': 'assets/icons/svg/ic_patient_list.svg'},
                    ];

                    if ((controller.type == "Doctor" || controller.type == "Leader" || controller.type == "Nurse") && controller.rxIsAdmitted.value == "0") {
                      list.add({'title': 'ipd_admit'.tr, 'icon': 'assets/icons/svg/ic_hospital_bed.svg'});
                    }

                    list.add({'title': 'my_admit_details'.tr, 'icon': 'assets/icons/svg/ic_hospital_bed.svg'});

                    if (controller.type != "Patient") {
                      list.add({'title': 'patient_location'.tr, 'icon': 'assets/icons/svg/location.svg'});
                    } else {
                      list.add({'title': 'update_my_location'.tr, 'icon': 'assets/icons/svg/location.svg'});
                    }

                    list.add({'title': 'echo_cardiography_report'.tr, 'icon': 'assets/icons/svg/echocardiography.svg'});
                    list.add({'title': 'home_services'.tr, 'icon': 'assets/icons/svg/ic_orders_status.svg'});

                    if (controller.rxCovidIconShow.value == "1") {
                      list.add({'title': 'covid_care_at_home'.tr, 'icon': 'assets/images/covid_logo.png'});
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.9,
                      ),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final item = list[index];
                        return DashboardCard(
                          title: item['title']!,
                          iconPath: item['icon']!,
                          onTap: () {},
                        );
                      },
                    );
                  }),
                  const SizedBox(height: 16),

                  // Awareness Slider
                  Obx(() {
                    if (controller.awarenessSliders.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        PatientDashboardSlider(items: controller.awarenessSliders),
                        const SizedBox(height: 16),
                      ],
                    );
                  }),

                  // For details contact number segment
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'for_details_call'.tr,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () async {
                            final uri = Uri.parse('tel:7507571987');
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri);
                            }
                          },
                          child: const Text(
                            '7507571987',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildBadgeButton(String text, Color color) {
    return AppStatusBadge(label: text, color: color);
  }
}