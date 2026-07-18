import 'package:digi_icu_flutter/controllers/serving_patient_controller.dart';
import 'package:digi_icu_flutter/controllers/serving_patient_dashboard_controller.dart';
import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/models/response/doctors/dashboard_details_response.dart';
import 'package:digi_icu_flutter/views/widgets/serving_patient_dashboard_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ServingPatientDashboardView extends StatelessWidget {
  const ServingPatientDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final parentController = Get.find<ServingPatientController>();
    final controller = Get.put(ServingPatientDashboardController());

    return Obx(() {
      if (controller.isLoading.value && controller.dashboardData.value == null) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: CircularProgressIndicator(),
          ),
        );
      }

      if (controller.errorMessage.isNotEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  controller.errorMessage.value,
                  style: const TextStyle(color: Colors.red, fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => controller.fetchDashboardDetails(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      }

      final data = controller.dashboardData.value;
      if (data == null) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('No dashboard data found.'),
          ),
        );
      }

      // 1. Parse Appointment By
      final appointmentBy = data.appointmentBy == 'self' ? 'P' : 'L';

      // 2. Parse Today's BP Background Color
      Color? todayBpColor;
      if (data.todayBp.isNotEmpty) {
        final parts = data.todayBp.split('/');
        if (parts.isNotEmpty) {
          final systolic = int.tryParse(parts[0].trim());
          if (systolic != null && systolic > 140) {
            todayBpColor = Colors.red;
          }
        }
      }

      // 3. Parse Creatinine Background Color and Text
      Color? creatinineColor;
      String creatinineText = 'NA';
      if (data.creatinine.isNotEmpty) {
        if (data.creatinine.length > 1) {
          creatinineText = '${data.creatinine[0].value}(${data.creatinine[1].value})';
          final finalCreatinine = double.tryParse(data.creatinine[1].value);
          if (finalCreatinine != null && finalCreatinine > 1.2) {
            creatinineColor = Colors.red;
          }
        } else {
          creatinineText = data.creatinine[0].value;
          final finalCreatinine = double.tryParse(creatinineText);
          if (finalCreatinine != null && finalCreatinine > 1.2) {
            creatinineColor = Colors.red;
          }
        }
      }

      // 4. Parse HbA1c Background Color and Text
      Color? hba1cColor;
      String hba1cText = 'NA';
      if (data.hba1c.isNotEmpty) {
        final rawValue = data.hba1c[0].value.trim();
        if (rawValue.isNotEmpty) {
          final finalHba1c = double.tryParse(rawValue) ?? 0.0;
          final relativeText = _getHba1cRelativeText(data.hba1c[0].created);
          hba1cText = relativeText.isNotEmpty ? '$rawValue ($relativeText)' : rawValue;
          if (finalHba1c > 6.7) {
            hba1cColor = Colors.red;
          }
        }
      }

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
                    Text(
                      '${data.visitNo} ',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '($appointmentBy)',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () => _showAdmissionHistoryDialog(context, data.admissionHistory),
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
                Text(
                  'Last Visit: ${data.lastVisit.isNotEmpty ? data.lastVisit : "NA"}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 6),
                if (data.firstVisit.isNotEmpty)
                  Tooltip(
                    message: 'First Visit: ${data.firstVisit}',
                    triggerMode: TooltipTriggerMode.tap,
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    textStyle: const TextStyle(color: Colors.white, fontSize: 13),
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
            if (data.whoIshRisk.isNotEmpty)
              Column(
                children: List.generate(data.whoIshRisk.length, (index) {
                  final risk = data.whoIshRisk[index];
                  if (risk.isEmpty) return const SizedBox.shrink();

                  final message = data.whoMsg.length > index ? data.whoMsg[index] : risk;
                  final bannerColor = _getWhoRiskColor(risk);
                  final textColor = risk == '>40%' ? Colors.white : Colors.black87;

                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 4),
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: bannerColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      message,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }),
              ),
            const SizedBox(height: 4),

            // 1. Diagnosis
             ServingPatientDashboardCard(
              title: 'Diagnosis',
              value: data.diagnosis.isNotEmpty ? data.diagnosis : 'NA',
              onTap: () {
                if (parentController.userType.value == 'Doctor') {
                  Get.toNamed(
                    '/diagnosis',
                    arguments: {
                      'patient_id': controller.patientId,
                      'appointment_id': parentController.bookingId,
                    },
                  )?.then((_) {
                    controller.fetchDashboardDetails();
                  });
                }
              },
              trailing: parentController.userType.value == 'Doctor'
                  ? GestureDetector(
                      onTap: () {
                        Get.toNamed(
                          '/diagnosis',
                          arguments: {
                            'patient_id': controller.patientId,
                            'appointment_id': parentController.bookingId,
                          },
                        )?.then((_) {
                          controller.fetchDashboardDetails();
                        });
                      },
                      child: const Icon(
                        Icons.add_circle,
                        color: Colors.white,
                        size: 24,
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 4),

            // 2. Symptoms & Significant History
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ServingPatientDashboardCard(
                      title: 'Symptoms',
                      value: data.symptoms.isNotEmpty ? data.symptoms[0].value : 'NA',
                      onTap: () => _showHistoryDialog(context, data.symptoms, 'Symptoms'),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: ServingPatientDashboardCard(
                      title: 'Significant History',
                      value: data.significantHistory.isNotEmpty ? data.significantHistory : 'NA',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
 
            // 3. Risk Factor, End Organ, Event & Compliance
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ServingPatientDashboardCard(
                      title: 'Risk Factor',
                      value: data.riskFactors.isNotEmpty ? data.riskFactors : 'NA',
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: ServingPatientDashboardCard(
                      title: 'End Organ',
                      value: data.endOrgan.isNotEmpty ? data.endOrgan : 'NA',
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: ServingPatientDashboardCard(
                      title: 'Event & Compliance',
                      value: data.events.isNotEmpty ? data.events.split('|')[0] : 'NA',
                      onTap: () {
                        if (data.events.isNotEmpty) {
                          final eventParts = data.events.split('|');
                          final dateStr = eventParts.length > 1 ? eventParts[1] : '';
                          _showHistoryDialog(
                            context,
                            [DashboardData(value: eventParts[0], created: dateStr)],
                            'Event & Compliance',
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),

            // 4. Today's BP, Target BP, Baseline BP
            Row(
              children: [
                Expanded(
                  child: ServingPatientDashboardCard(
                    title: "Today's BP",
                    value: data.todayBp.isNotEmpty ? data.todayBp : 'NA',
                    backgroundColor: todayBpColor,
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: ServingPatientDashboardCard(
                    title: 'Target BP',
                    value: data.targetBp.isNotEmpty ? data.targetBp : 'NA',
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: ServingPatientDashboardCard(
                    title: 'Baseline BP',
                    value: data.baselineBp.isNotEmpty ? data.baselineBp : 'NA',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // 5. Sugar, HBA1C, Weight & BMI
            Row(
              children: [
                Expanded(
                  child: ServingPatientDashboardCard(
                    title: 'Sugar',
                    value: data.sugar.isNotEmpty ? data.sugar[0].value : 'NA',
                    onTap: () => _showHistoryDialog(context, data.sugar, 'Sugar'),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: ServingPatientDashboardCard(
                    title: 'HBA1C',
                    value: hba1cText,
                    backgroundColor: hba1cColor,
                    onTap: () => _showHistoryDialog(context, data.hba1c, 'HBA1C', isHba1c: true, controller: controller),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: ServingPatientDashboardCard(
                    title: 'Weight & BMI',
                    value: data.weight.isNotEmpty ? data.weight[0].value : 'NA',
                    onTap: () => _showHistoryDialog(context, data.weight, 'Height, Weight & BMI', height: data.height),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // 6. Creatinine, Cholesterol, Protein Urine
            Row(
              children: [
                Expanded(
                  child: ServingPatientDashboardCard(
                    title: 'Creatinine',
                    value: creatinineText,
                    backgroundColor: creatinineColor,
                    onTap: () => _showHistoryDialog(context, data.creatinine, 'Creatinine'),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: ServingPatientDashboardCard(
                    title: 'Cholesterol',
                    value: data.cholesterol.isNotEmpty ? data.cholesterol[0].value : 'NA',
                    onTap: () => _showHistoryDialog(context, data.cholesterol, 'Cholesterol'),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: ServingPatientDashboardCard(
                    title: 'Protein Urine',
                    value: data.urineAlbumin.isNotEmpty ? data.urineAlbumin[0].value : 'NA',
                    onTap: () => _showHistoryDialog(context, data.urineAlbumin, 'Protein Urine'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // 7. Cautions
            ServingPatientDashboardCard(
              title: 'Cautions',
              value: data.causions.isNotEmpty ? data.causions : 'NA',
            ),
            const SizedBox(height: 8),

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
    });
  }

  // Helper relative time calculations
  static String _getHba1cRelativeText(String created) {
    if (created.isEmpty) return '';
    try {
      DateTime? createdDate;
      if (created.length == 10) {
        createdDate = DateTime.tryParse(created);
      } else {
        createdDate = DateTime.tryParse(created.replaceAll(' ', 'T'));
      }
      if (createdDate == null) return '';
      final now = DateTime.now();
      final difference = now.difference(createdDate);
      final diffDays = difference.inDays;
      if (diffDays < 0) return '';
      if (diffDays < 30) {
        return diffDays == 1 ? '1 day ago' : '$diffDays days ago';
      } else if (diffDays < 365) {
        final diffMonths = diffDays ~/ 30;
        return diffMonths == 1 ? '1 month ago' : '$diffMonths months ago';
      } else {
        final diffYears = diffDays ~/ 365;
        return diffYears == 1 ? '1 year ago' : '$diffYears years ago';
      }
    } catch (_) {
      return '';
    }
  }

  // WHO Risk color mapper
  static Color _getWhoRiskColor(String risk) {
    switch (risk) {
      case '<10%':
        return const Color(0xFF8BC34A);
      case '10-20%':
        return const Color(0xFFFFEB3B);
      case '20-30%':
        return const Color(0xFFFF9800);
      case '30-40%':
        return const Color(0xFFFF5722);
      case '>40%':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFF8BC34A);
    }
  }

  // Admission History Custom Table Dialog
  void _showAdmissionHistoryDialog(BuildContext context, List<AdmissionHistoryItem> list) {
    Get.dialog(
      AlertDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        title: const Text(
          'Admission History',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: list.isEmpty
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: Text(
                    "This patient doesn't have an admission history.",
                    textAlign: TextAlign.center,
                  ),
                )
              : SingleChildScrollView(
                  child: Table(
                    border: TableBorder.all(color: Colors.grey.shade300),
                    columnWidths: const {
                      0: FlexColumnWidth(1.4),
                      1: FlexColumnWidth(2.5),
                      2: FlexColumnWidth(3.1),
                    },
                    children: [
                      // Header Row
                      const TableRow(
                        decoration: BoxDecoration(color: AppColors.primary),
                        children: [
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'ID',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Doctor',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Date',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Data Rows
                      ...list.map((item) {
                        final isAdmitted = item.status.toLowerCase() == 'admitted';
                        final rowBgColor = isAdmitted ? Colors.green.withValues(alpha: 0.2) : Colors.transparent;

                        return TableRow(
                          decoration: BoxDecoration(color: rowBgColor),
                          children: [
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  item.appointmentId,
                                  style: const TextStyle(fontSize: 13),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  item.doctorName,
                                  style: const TextStyle(fontSize: 13),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  isAdmitted
                                      ? 'A: ${item.admitDate}'
                                      : 'A: ${item.admitDate}\nD: ${item.dischargeDate}',
                                  style: const TextStyle(fontSize: 12),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Metric Historic List Dialog (with Hba1c entry feature)
  void _showHistoryDialog(
    BuildContext context,
    List<DashboardData> list,
    String text, {
    String height = '',
    bool isHba1c = false,
    ServingPatientDashboardController? controller,
  }) {
    final showListContainer = true.obs;
    final hba1cValueController = TextEditingController();
    final hba1cDateController = TextEditingController();
    String apiFormattedDate = '';

    Get.dialog(
      Obx(() {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 14),
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (text == 'Height, Weight & BMI' && height.isNotEmpty) ...[
                  Text(
                    'Height: $height cm',
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.blue),
                  ),
                  const SizedBox(height: 8),
                ],
                if (showListContainer.value) ...[
                  Flexible(
                    child: list.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text('No history found.'),
                          )
                        : ListView.separated(
                            shrinkWrap: true,
                            itemCount: list.length,
                            separatorBuilder: (context, index) => const Divider(),
                            itemBuilder: (context, index) {
                              final item = list[index];
                              String datePart = '';
                              if (item.created.isNotEmpty) {
                                final parsed = DateTime.tryParse(item.created);
                                if (parsed != null) {
                                  datePart = ' (${DateFormat('dd-MM-yyyy hh:mm a').format(parsed)})';
                                } else {
                                  datePart = ' (${item.created})';
                                }
                              }
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: Text(
                                  '${item.value}$datePart',
                                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                                ),
                              );
                            },
                          ),
                  ),
                ] else ...[
                  // HbA1c input form
                  const Text('Enter HbA1c Value:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: hba1cValueController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      hintText: 'e.g. 6.5',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('Select Date:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: hba1cDateController,
                    readOnly: true,
                    onTap: () async {
                      final selected = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (selected != null) {
                        hba1cDateController.text = DateFormat('dd/MM/yyyy').format(selected);
                        apiFormattedDate = DateFormat('yyyy-MM-dd').format(selected);
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: 'dd/MM/yyyy',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today, size: 18),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        final val = hba1cValueController.text.trim();
                        if (val.isEmpty || apiFormattedDate.isEmpty) {
                          Get.rawSnackbar(
                            message: 'Please fill in both HbA1c value and date.',
                            backgroundColor: Colors.red,
                          );
                          return;
                        }
                        if (controller != null) {
                          final success = await controller.addQuickForm(val, apiFormattedDate);
                          if (success) {
                            Get.back();
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                      child: const Text('Submit', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: isHba1c && showListContainer.value
              ? [
                  FloatingActionButton.small(
                    onPressed: () => showListContainer.value = false,
                    backgroundColor: AppColors.primary,
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ]
              : null,
        );
      }),
    );
  }
}
