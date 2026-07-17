import 'package:digi_icu_flutter/controllers/serving_patient_controller.dart';
import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/views/screens/serving_patient_dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServingPatientScreen extends GetView<ServingPatientController> {
  const ServingPatientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          controller.fullName.isNotEmpty ? controller.fullName : 'Serving Patient',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30.0),
          child: Padding(
            padding: const EdgeInsets.only(left: 72.0, bottom: 8.0),
            child: Row(
              children: [
                Text(
                  'Age: ${controller.age}  |  Gender: ${controller.gender}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: const ServingPatientDashboardView(),
    );
  }
}
