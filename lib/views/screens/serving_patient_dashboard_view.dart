import 'package:digi_icu_flutter/controllers/serving_patient_controller.dart';
import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/views/widgets/serving_patient_dashboard_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServingPatientDashboardView extends GetView<ServingPatientController> {
  const ServingPatientDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Visit No & Admission History Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    'Visit No: ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Text(
                    '1 ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    '(${controller.selectTab.isNotEmpty ? controller.selectTab[0].toUpperCase() : "P"})',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  Get.rawSnackbar(message: 'Admission History clicked');
                },
                child: const Text(
                  'Admission History',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Last Visit Info
          Row(
            children: [
              const Text(
                'Last Visit: NA',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () {
                  Get.rawSnackbar(message: 'Last Visit Info');
                },
                child: const Icon(
                  Icons.info,
                  size: 18,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // WHO-ISH Risk Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF8BC34A), // Greenish color from the image
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Column(
              children: [
                Text(
                  'WHO-ISH Cardiovascular (Heart attack/Stroke) Risk -',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '<10%',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Parameter Grid/Cards
          // 1. Diagnosis
          ServingPatientDashboardCard(
            title: 'Diagnosis',
            value: 'NA',
            trailing: GestureDetector(
              onTap: () {
                Get.rawSnackbar(message: 'Add Diagnosis clicked');
              },
              child: const Icon(
                Icons.add_circle,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // 2. Symptoms & Significant History
          Row(
            children: [
              Expanded(
                child: ServingPatientDashboardCard(
                  title: 'Symptoms',
                  value: controller.note.isNotEmpty ? controller.note : 'Dyspnea,',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: const ServingPatientDashboardCard(
                  title: 'Significant History',
                  value: 'NA',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // 3. Risk Factor, End Organ, Event & Compliance
          Row(
            children: [
              Expanded(
                child: const ServingPatientDashboardCard(
                  title: 'Risk Factor',
                  value: 'NA',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: const ServingPatientDashboardCard(
                  title: 'End Organ',
                  value: 'NA',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: const ServingPatientDashboardCard(
                  title: 'Event & Compliance',
                  value: 'NA',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // 4. Today's BP, Target BP, Baseline BP
          Row(
            children: [
              Expanded(
                child: const ServingPatientDashboardCard(
                  title: "Today's BP",
                  value: '130/80(80)',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: const ServingPatientDashboardCard(
                  title: 'Target BP',
                  value: '130/80',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: const ServingPatientDashboardCard(
                  title: 'Baseline BP',
                  value: '130/80(80)',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // 5. Sugar, HBA1C, Weight & BMI
          Row(
            children: [
              Expanded(
                child: const ServingPatientDashboardCard(
                  title: 'Sugar',
                  value: 'NA',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: const ServingPatientDashboardCard(
                  title: 'HBA1C',
                  value: 'NA',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: const ServingPatientDashboardCard(
                  title: 'Weight & BMI',
                  value: 'NA',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // 6. Creatinine, Cholesterol, Protein Urine
          Row(
            children: [
              Expanded(
                child: const ServingPatientDashboardCard(
                  title: 'Creatinine',
                  value: 'NA',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: const ServingPatientDashboardCard(
                  title: 'Cholesterol',
                  value: 'NA',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: const ServingPatientDashboardCard(
                  title: 'Protein Urine',
                  value: 'NA',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // 7. Cautions
          const ServingPatientDashboardCard(
            title: 'Cautions',
            value: 'NA',
          ),
          const SizedBox(height: 16),
          // Footer Text
          const Center(
            child: Text(
              'Click on the button to check history or previous values',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
