import 'dart:io';
import 'package:digi_icu_flutter/controllers/serving_patient_controller.dart';
import 'package:digi_icu_flutter/core/constants/api_endpoints.dart';
import 'package:digi_icu_flutter/core/constants/app_constants.dart';
import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/models/request/user/admit_place_request_model.dart';
import 'package:digi_icu_flutter/models/request/user/get_beds_request_model.dart';
import 'package:digi_icu_flutter/services/api/api_client.dart';
import 'package:digi_icu_flutter/views/widgets/app_drawing_canvas.dart';
import 'package:digi_icu_flutter/views/widgets/app_primary_button.dart';
import 'package:digi_icu_flutter/views/widgets/app_radio.dart';
import 'package:digi_icu_flutter/views/widgets/app_snackbars.dart';
import 'package:digi_icu_flutter/views/widgets/app_speech_input_widget.dart';
import 'package:digi_icu_flutter/views/widgets/ipd_admit_flow_delegate.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IpdAdmitDialog extends StatelessWidget {
  final List<dynamic> instituteAmenities;
  final List<dynamic> beds;
  final VoidCallback? onSubmit;
  final IPDAdmitFlowDelegate? delegate;

  final GlobalKey<AppDrawingCanvasState> canvasKey =
      GlobalKey<AppDrawingCanvasState>();

  IpdAdmitDialog({
    super.key,
    required this.instituteAmenities,
    this.beds = const [],
    this.onSubmit,
    this.delegate,
  });

  @override
  Widget build(BuildContext context) {
    final IPDAdmitFlowDelegate flowDelegate =
        delegate ?? Get.find<ServingPatientController>();
    final ApiClient apiClient = Get.find<ApiClient>();

    final TextEditingController admissionNotesEditingController =
        TextEditingController(text: flowDelegate.admissionNotes.value);

    // Auto-fill doctor info for Doctor role
    if (flowDelegate.userType.value == 'Doctor' &&
        flowDelegate.selectedConsultantDoctorId.value.isEmpty) {
      flowDelegate.selectedConsultantDoctorId.value = flowDelegate.doctorId;
      flowDelegate.selectedConsultantDoctorName.value =
          flowDelegate.loggedInDoctorName.value;
    }

    // Default admit date and time initialization to current date and time
    if (flowDelegate.admissionDate.value.isEmpty) {
      final now = DateTime.now();
      flowDelegate.admissionDate.value =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    }
    if (flowDelegate.admissionTime.value.isEmpty) {
      final now = TimeOfDay.now();
      flowDelegate.admissionTime.value =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    }

    final facilities = _getDynamicFacilities(instituteAmenities);

    // Default place initialization
    if (flowDelegate.selectedAdmitPlace.value.isEmpty && facilities.isNotEmpty) {
      if (flowDelegate.isDayCare.value) {
        final dayCare = facilities.firstWhere(
          (f) => f['key'] == 'Day Care',
          orElse: () => facilities.first,
        );
        flowDelegate.selectedAdmitPlace.value = dayCare['key']!;
        _fetchWardsForPlace(flowDelegate, apiClient, dayCare['key']!);
      } else {
        final nonDayCare = facilities.firstWhere(
          (f) => f['key'] != 'Day Care',
          orElse: () => facilities.first,
        );
        flowDelegate.selectedAdmitPlace.value = nonDayCare['key']!;
        _fetchWardsForPlace(flowDelegate, apiClient, nonDayCare['key']!);
      }
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 600,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Dialog Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'admit'.tr,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${flowDelegate.fullName}/${flowDelegate.gender.isNotEmpty ? flowDelegate.gender[0].toUpperCase() : ''}/${flowDelegate.age}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.coolGray,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.error),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const Divider(),

            // Scrollable Dialog Body
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Care Info Header Banner
                    Obx(() {
                      final docPart =
                          flowDelegate
                              .selectedConsultantDoctorName
                              .value
                              .isNotEmpty
                          ? 'Dr. ${flowDelegate.selectedConsultantDoctorName.value}'
                          : (flowDelegate.loggedInDoctorName.value.isNotEmpty
                                ? 'Dr. ${flowDelegate.loggedInDoctorName.value}'
                                : 'the institute');
                      final instPart =
                          flowDelegate.selectedInstituteName.value.isNotEmpty
                          ? ' in ${flowDelegate.selectedInstituteName.value}'
                          : '';
                      final careText =
                          'The patient will be admitted under the care of $docPart$instPart';

                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.lightGray,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: AppColors.medicalGray,
                            width: 0.5,
                          ),
                        ),
                        child: Text(
                          careText,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.navy,
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 16),

                    // Consultant Doctor (Role Leader vs Doctor)
                    Obx(() {
                      final role = flowDelegate.userType.value;
                      if (role == 'Leader' || role == 'leader') {
                        final currentSelectedId =
                            flowDelegate.selectedConsultantDoctorId.value;

                        final Map<String, String> docMap = {
                          '': 'please_select_doctor'.tr,
                        };
                        for (final doc in flowDelegate.admitDoctors) {
                          final docId =
                              (doc['id'] ?? doc['doctor_id'])?.toString() ?? '';
                          if (docId.isNotEmpty) {
                            final name =
                                doc['doctor_name']?.toString() ??
                                'Dr. ${doc['first_name'] ?? ''} ${doc['last_name'] ?? ''}';
                            docMap[docId] = name;
                          }
                        }

                        final validValue = docMap.containsKey(currentSelectedId)
                            ? currentSelectedId
                            : '';

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DropdownButtonFormField<String>(
                              isExpanded: true,
                              decoration: InputDecoration(
                                labelText: 'consultant_doctor'.tr,
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              initialValue: validValue,
                              hint: Text('please_select_doctor'.tr),
                              items: docMap.entries.map((entry) {
                                return DropdownMenuItem<String>(
                                  value: entry.key,
                                  child: Text(entry.value),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  flowDelegate.selectedConsultantDoctorId.value =
                                      value;
                                  if (value.isNotEmpty) {
                                    final match = flowDelegate.admitDoctors
                                        .firstWhere(
                                          (d) =>
                                              (d['id'] ?? d['doctor_id'])
                                                  ?.toString() ==
                                              value,
                                          orElse: () => null,
                                        );
                                    if (match != null) {
                                      flowDelegate
                                              .selectedConsultantDoctorName
                                              .value =
                                          match['doctor_name']?.toString() ??
                                          '${match['first_name'] ?? ''} ${match['last_name'] ?? ''}';
                                    }
                                  } else {
                                    flowDelegate
                                            .selectedConsultantDoctorName
                                            .value =
                                        '';
                                  }
                                }
                              },
                            ),
                            const SizedBox(height: 12),
                          ],
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),

                    // Referral Doctor Dropdown
                    Obx(() {
                      if (flowDelegate.userType.value == 'Leader' ||
                          flowDelegate.userType.value == 'leader') {
                        return const SizedBox.shrink();
                      }

                      final currentSelectedId =
                          flowDelegate.selectedReferralDoctorId.value;

                      final List<DropdownMenuItem<String>> dropdownItems = [
                        DropdownMenuItem<String>(
                          value: '',
                          child: Text('select_doctor'.tr),
                        ),
                      ];

                      String validValue = '';

                      for (
                        int i = 0;
                        i < flowDelegate.referralDoctors.length;
                        i++
                      ) {
                        final doc = flowDelegate.referralDoctors[i];
                        final docId = doc['id']?.toString() ?? '';
                        final docName =
                            doc['doctor_name']?.toString() ??
                            '${doc['first_name'] ?? ''} ${doc['last_name'] ?? ''}';

                        final itemValue = '$i:$docId';
                        dropdownItems.add(
                          DropdownMenuItem<String>(
                            value: itemValue,
                            child: Text(docName),
                          ),
                        );

                        if (docId == currentSelectedId && validValue.isEmpty) {
                          validValue = itemValue;
                        }
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButtonFormField<String>(
                            isExpanded: true,
                            decoration: InputDecoration(
                              labelText: 'referral_doctor'.tr,
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            initialValue: validValue,
                            hint: Text('select_doctor'.tr),
                            items: dropdownItems,
                            onChanged: (value) {
                              if (value != null) {
                                if (value.contains(':')) {
                                  final parts = value.split(':');
                                  final index = int.tryParse(parts[0]) ?? -1;
                                  final realId = parts.sublist(1).join(':');

                                  flowDelegate.selectedReferralDoctorId.value =
                                      realId;
                                  if (index >= 0 &&
                                      index <
                                          flowDelegate.referralDoctors.length) {
                                    final match =
                                        flowDelegate.referralDoctors[index];
                                    flowDelegate.referralDoctor.value =
                                        match['doctor_name']?.toString() ??
                                        '${match['first_name'] ?? ''} ${match['last_name'] ?? ''}';
                                  }
                                } else {
                                  flowDelegate.selectedReferralDoctorId.value =
                                      '';
                                  flowDelegate.referralDoctor.value = '';
                                }
                              }
                            },
                          ),
                          const SizedBox(height: 12),
                        ],
                      );
                    }),

                    // Approx Cost & Approx Days (Stacked Vertically)
                    TextFormField(
                      initialValue: flowDelegate.approxCost.value,
                      decoration: InputDecoration(
                        labelText: 'approx_cost'.tr,
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => flowDelegate.approxCost.value = value,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      initialValue: flowDelegate.approxDays.value,
                      decoration: InputDecoration(
                        labelText: 'approx_days'.tr,
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => flowDelegate.approxDays.value = value,
                    ),
                    const SizedBox(height: 16),

                    // ==========================================
                    // Admission Charges Section (Stacked Vertically)
                    // ==========================================
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.medicalGray,
                          width: 0.8,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'admission_charges'.tr,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.navy,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            initialValue: flowDelegate.admissionAmount.value,
                            decoration: InputDecoration(
                              labelText: 'amount'.tr,
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) =>
                                flowDelegate.admissionAmount.value = value,
                          ),
                          const SizedBox(height: 8),
                          Obx(
                            () => RadioGroup<String>(
                              groupValue:
                                  flowDelegate.admissionPaymentStatus.value,
                              onChanged: (value) {
                                if (value != null) {
                                  flowDelegate.admissionPaymentStatus.value =
                                      value;
                                }
                              },
                              child: Row(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      AppRadio<String>(value: 'Paid'),
                                      const SizedBox(width: 4),
                                      const Text('Paid'),
                                    ],
                                  ),
                                  const SizedBox(width: 24),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      AppRadio<String>(value: 'Due'),
                                      const SizedBox(width: 4),
                                      const Text('Due'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Obx(() {
                            if (flowDelegate.admissionPaymentStatus.value ==
                                'Paid') {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8),
                                  RadioGroup<String>(
                                    groupValue:
                                        flowDelegate.admissionPaymentMode.value,
                                    onChanged: (value) {
                                      if (value != null) {
                                        flowDelegate.admissionPaymentMode.value =
                                            value;
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            AppRadio<String>(value: 'Cash'),
                                            const SizedBox(width: 4),
                                            const Text('Cash'),
                                          ],
                                        ),
                                        const SizedBox(width: 24),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            AppRadio<String>(value: 'Online'),
                                            const SizedBox(width: 4),
                                            const Text('Online'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (flowDelegate.admissionPaymentMode.value ==
                                      'Online') ...[
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      initialValue: flowDelegate
                                          .admissionTransactionId
                                          .value,
                                      decoration: InputDecoration(
                                        labelText: 'transaction_id'.tr,
                                        border: const OutlineInputBorder(),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 8,
                                            ),
                                      ),
                                      onChanged: (value) =>
                                          flowDelegate
                                                  .admissionTransactionId
                                                  .value =
                                              value,
                                    ),
                                  ],
                                ],
                              );
                            }
                            return const SizedBox.shrink();
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ==========================================
                    // Advance Amount Section (Stacked Vertically)
                    // ==========================================
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.medicalGray,
                          width: 0.8,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'advance_amount'.tr,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.navy,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            initialValue: flowDelegate.advanceAmount.value,
                            decoration: InputDecoration(
                              labelText: 'amount'.tr,
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) =>
                                flowDelegate.advanceAmount.value = value,
                          ),
                          const SizedBox(height: 8),
                          Obx(
                            () => RadioGroup<String>(
                              groupValue: flowDelegate.advancePaymentStatus.value,
                              onChanged: (value) {
                                if (value != null) {
                                  flowDelegate.advancePaymentStatus.value = value;
                                }
                              },
                              child: Row(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      AppRadio<String>(value: 'Paid'),
                                      const SizedBox(width: 4),
                                      const Text('Paid'),
                                    ],
                                  ),
                                  const SizedBox(width: 24),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      AppRadio<String>(value: 'Due'),
                                      const SizedBox(width: 4),
                                      const Text('Due'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Obx(() {
                            if (flowDelegate.advancePaymentStatus.value ==
                                'Paid') {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8),
                                  RadioGroup<String>(
                                    groupValue:
                                        flowDelegate.advancePaymentMode.value,
                                    onChanged: (value) {
                                      if (value != null) {
                                        flowDelegate.advancePaymentMode.value =
                                            value;
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            AppRadio<String>(value: 'Cash'),
                                            const SizedBox(width: 4),
                                            const Text('Cash'),
                                          ],
                                        ),
                                        const SizedBox(width: 24),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            AppRadio<String>(value: 'Online'),
                                            const SizedBox(width: 4),
                                            const Text('Online'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (flowDelegate.advancePaymentMode.value ==
                                      'Online') ...[
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      initialValue:
                                          flowDelegate.advanceTransactionId.value,
                                      decoration: InputDecoration(
                                        labelText: 'transaction_id'.tr,
                                        border: const OutlineInputBorder(),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 8,
                                            ),
                                      ),
                                      onChanged: (value) =>
                                          flowDelegate
                                                  .advanceTransactionId
                                                  .value =
                                              value,
                                    ),
                                  ],
                                ],
                              );
                            }
                            return const SizedBox.shrink();
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Admission Date & Time (Stacked Vertically)
                    InkWell(
                      onTap: () async {
                        DateTime initialDate = DateTime.now();
                        if (flowDelegate.admissionDate.value.isNotEmpty) {
                          final parsed = DateTime.tryParse(
                            flowDelegate.admissionDate.value,
                          );
                          if (parsed != null) {
                            initialDate = parsed;
                          }
                        }
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: initialDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          flowDelegate.admissionDate.value =
                              '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                        }
                      },
                      child: Obx(
                        () => IgnorePointer(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'admission_date'.tr,
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            controller: TextEditingController(
                              text: flowDelegate.admissionDate.value,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () async {
                        TimeOfDay initialTime = TimeOfDay.now();
                        if (flowDelegate.admissionTime.value.isNotEmpty) {
                          final parts =
                              flowDelegate.admissionTime.value.split(':');
                          if (parts.length == 2) {
                            final h = int.tryParse(parts[0]);
                            final m = int.tryParse(parts[1]);
                            if (h != null && m != null) {
                              initialTime = TimeOfDay(hour: h, minute: m);
                            }
                          }
                        }
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: initialTime,
                        );
                        if (picked != null) {
                          flowDelegate.admissionTime.value =
                              '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                        }
                      },
                      child: Obx(
                        () => IgnorePointer(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'admission_time'.tr,
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            controller: TextEditingController(
                              text: flowDelegate.admissionTime.value,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Place Selection
                    Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'place'.tr,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.navy,
                            ),
                          ),
                          const SizedBox(height: 8),
                          RadioGroup<String>(
                            groupValue:
                                flowDelegate.selectedAdmitPlace.value.isNotEmpty
                                ? flowDelegate.selectedAdmitPlace.value
                                : null,
                            onChanged: (value) {
                              if (value != null) {
                                flowDelegate.selectedAdmitPlace.value = value;
                                flowDelegate.selectedAdmitWard.value = '';
                                flowDelegate.selectedAdmitBed.value = '';
                                _fetchWardsForPlace(
                                  flowDelegate,
                                  apiClient,
                                  value,
                                );
                              }
                            },
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: facilities.map<Widget>((f) {
                                  final isDayCare = (f['key'] == 'Day Care');
                                  final isPrevDayCare =
                                      flowDelegate.isDayCare.value;
                                  final enabled = isPrevDayCare
                                      ? isDayCare
                                      : !isDayCare;

                                  return Padding(
                                    padding: const EdgeInsets.only(right: 12.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        AppRadio<String>(
                                          value: f['key']!,
                                          enabled: enabled,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${f['label']} (${f['count']})',
                                          style: TextStyle(
                                            color: enabled
                                                ? AppColors.pureBlack
                                                : AppColors.medicalGray,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Ward Selection (Horizontal RadioGroup)
                          Obx(() {
                            if (flowDelegate.admitWardOptions.isEmpty) {
                              return const SizedBox.shrink();
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ward'.tr,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.navy,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                RadioGroup<String>(
                                  groupValue:
                                      flowDelegate
                                              .selectedAdmitWard
                                              .value
                                              .isNotEmpty &&
                                          flowDelegate.admitWardOptions.contains(
                                            flowDelegate.selectedAdmitWard.value,
                                          )
                                      ? flowDelegate.selectedAdmitWard.value
                                      : null,
                                  onChanged: (value) {
                                    if (value != null) {
                                      flowDelegate.selectedAdmitWard.value =
                                          value;
                                      flowDelegate.selectedAdmitBed.value = '';
                                      _fetchBedsForWard(
                                        flowDelegate,
                                        apiClient,
                                        flowDelegate.selectedAdmitPlace.value,
                                        value,
                                      );
                                    }
                                  },
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: flowDelegate.admitWardOptions
                                          .map<Widget>((ward) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                right: 12.0,
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  AppRadio<String>(value: ward),
                                                  const SizedBox(width: 4),
                                                  Text(ward),
                                                ],
                                              ),
                                            );
                                          })
                                          .toList(),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                            );
                          }),

                          // Beds Selection (Responsive Grid / Wrap of Radio Buttons)
                          Obx(() {
                            if (flowDelegate.admitBedOptions.isEmpty) {
                              return const SizedBox.shrink();
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'beds'.tr,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.navy,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                RadioGroup<String>(
                                  groupValue:
                                      flowDelegate
                                              .selectedAdmitBed
                                              .value
                                              .isNotEmpty &&
                                          flowDelegate.admitBedOptions.contains(
                                            flowDelegate.selectedAdmitBed.value,
                                          )
                                      ? flowDelegate.selectedAdmitBed.value
                                      : null,
                                  onChanged: (value) {
                                    if (value != null) {
                                      flowDelegate.selectedAdmitBed.value = value;
                                    }
                                  },
                                  child: Wrap(
                                    spacing: 12,
                                    runSpacing: 8,
                                    children: flowDelegate.admitBedOptions
                                        .map<Widget>((bed) {
                                          return Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              AppRadio<String>(value: bed),
                                              const SizedBox(width: 4),
                                              Text(bed),
                                            ],
                                          );
                                        })
                                        .toList(),
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),

                    // Admission Notes with Speech Input
                    AppSpeechInputWidget(
                      controller: admissionNotesEditingController,
                      label: 'admission_notes'.tr,
                      hintText: 'enter_admission_notes'.tr,
                      maxLines: 4,
                      onChanged: (value) =>
                          flowDelegate.admissionNotes.value = value,
                    ),
                    const SizedBox(height: 16),

                    // Drawing Canvas (Doctor Role)
                    Obx(() {
                      if (flowDelegate.userType.value == 'Doctor') {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'admit_notes_drawing_canvas'.tr,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.navy,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 380,
                              child: AppDrawingCanvas(
                                key: canvasKey,
                                showToolbar: true,
                                initialPenColor: AppColors.pureBlack,
                                backgroundColor: AppColors.white,
                                canvasDecoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.medicalGray,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                onSave: (bytes) {
                                  flowDelegate.canvasDrawingBytes.value = bytes;
                                  AppSnackbars.showSuccess(
                                    'success'.tr,
                                    'drawing_canvas_saved'.tr,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),

                    // Photo Note Attachment (Nurse / Leader / Duty Doctor Roles)
                    Obx(() {
                      final role = flowDelegate.userType.value;
                      final isNurseOrLeader =
                          role == 'Nurse' ||
                          role == 'Digi Icu Nurse' ||
                          role == 'Duty Doctor' ||
                          role == 'Leader' ||
                          role == 'leader';
                      if (isNurseOrLeader) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'admit_notes_image'.tr,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.navy,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (flowDelegate.noteImagePath.value.isNotEmpty) ...[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(flowDelegate.noteImagePath.value),
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton.icon(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: AppColors.error,
                                  ),
                                  label: Text(
                                    'remove'.tr,
                                    style: const TextStyle(
                                      color: AppColors.error,
                                    ),
                                  ),
                                  onPressed: () =>
                                      flowDelegate.noteImagePath.value = '',
                                ),
                              ),
                            ],
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.teal,
                                side: const BorderSide(color: AppColors.teal),
                              ),
                              icon: const Icon(
                                Icons.camera_alt,
                                color: AppColors.teal,
                              ),
                              label: Text('upload_notes_image'.tr),
                              onPressed: () =>
                                  flowDelegate.showImagePickerForNotes(),
                            ),
                            const SizedBox(height: 12),
                          ],
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),
                    const SizedBox(height: 12),

                    // Admit Prescription Action Button
                    Obx(
                      () => Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.teal,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          icon: Stack(
                            children: [
                              const Icon(
                                Icons.description,
                                color: AppColors.white,
                                size: 18,
                              ),
                              if (!flowDelegate.isAdmitPrescription.value)
                                const Positioned(
                                  right: 0,
                                  top: 0,
                                  child: CircleAvatar(
                                    radius: 4,
                                    backgroundColor: AppColors.warning,
                                  ),
                                ),
                            ],
                          ),
                          label: Text(
                            'admit_prescription'.tr,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            Get.toNamed(
                              '/add-prescription',
                              arguments: {
                                'patient_id': flowDelegate.patientId,
                                'bookingId': flowDelegate.bookingId,
                                'admitId': '0',
                                'isFromAdmit': true,
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            const Divider(),

            // Footer Section: Cancel & Submit Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    'cancel'.tr,
                    style: const TextStyle(
                      color: AppColors.error,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 120,
                  child: AppPrimaryButton(
                    label: 'submit'.tr,
                    height: 40,
                    onPressed: () async {
                      if (flowDelegate.userType.value == 'Doctor' &&
                          flowDelegate.canvasDrawingBytes.value == null) {
                        final bytes = await canvasKey.currentState
                            ?.exportToPngImage();
                        if (bytes != null) {
                          flowDelegate.canvasDrawingBytes.value = bytes;
                        }
                      }
                      if (onSubmit != null) {
                        Get.back();
                        onSubmit!();
                      } else {
                        flowDelegate.validateAndConfirmAdmit();
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, String>> _getDynamicFacilities(dynamic amenityData) {
    Map<String, dynamic> amenityMap = {};
    if (amenityData is List &&
        amenityData.isNotEmpty &&
        amenityData[0] is Map<String, dynamic>) {
      amenityMap = amenityData[0];
    } else if (amenityData is Map<String, dynamic>) {
      amenityMap = amenityData;
    }

    final facilities = [
      {
        'label': 'ICU',
        'key': 'ICU',
        'count': amenityMap['icu']?.toString() ?? '0',
      },
      {
        'label': 'CCU',
        'key': 'CCU',
        'count': amenityMap['ccu']?.toString() ?? '0',
      },
      {
        'label': 'Ward / Room',
        'key': 'Ward / Room',
        'count': amenityMap['wards']?.toString() ?? '0',
      },
      {
        'label': 'Casualty',
        'key': 'Casualty',
        'count': amenityMap['casuality']?.toString() ?? '0',
      },
      {
        'label': 'Step down',
        'key': 'Step down',
        'count': amenityMap['step_down']?.toString() ?? '0',
      },
      {
        'label': 'Day Care',
        'key': 'Day Care',
        'count': amenityMap['day_care']?.toString() ?? '0',
      },
      {
        'label': 'Extra',
        'key': 'Extra',
        'count': amenityMap['extra']?.toString() ?? '0',
      },
    ];

    return facilities
        .where((f) => f['count'] != '0' && f['count'] != null)
        .toList();
  }

  void _fetchWardsForPlace(
    IPDAdmitFlowDelegate flowDelegate,
    ApiClient apiClient,
    String? placeKey,
  ) async {
    if (placeKey == null || placeKey.isEmpty) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';
      final targetInstituteId = flowDelegate.selectedInstituteId.value.isNotEmpty
          ? flowDelegate.selectedInstituteId.value
          : flowDelegate.instituteId;

      final req = AdmitPlaceRequestModel(
        admitIn: placeKey,
        instituteId: targetInstituteId,
      );

      final resp = await apiClient.post(
        ApiEndpoints.whereAdmit,
        data: req.toJson(),
        options: dio.Options(headers: {'Authorization': token}),
      );
      if (resp.statusCode == 200 && resp.data != null) {
        final wards = resp.data['data'] ?? [];
        if (wards is List) {
          final wardsList = wards
              .map((w) => w['name']?.toString() ?? '')
              .where((w) => w.isNotEmpty)
              .toList();
          flowDelegate.admitWardOptions.value = wardsList;
          if (wardsList.isNotEmpty) {
            final firstWard = wardsList.first;
            flowDelegate.selectedAdmitWard.value = firstWard;
            _fetchBedsForWard(flowDelegate, apiClient, placeKey, firstWard);
          } else {
            flowDelegate.selectedAdmitWard.value = '';
            _fetchBedsForWard(flowDelegate, apiClient, placeKey, '');
          }
        } else {
          flowDelegate.admitWardOptions.clear();
          flowDelegate.selectedAdmitWard.value = '';
          _fetchBedsForWard(flowDelegate, apiClient, placeKey, '');
        }
      } else {
        flowDelegate.admitWardOptions.clear();
        flowDelegate.selectedAdmitWard.value = '';
        _fetchBedsForWard(flowDelegate, apiClient, placeKey, '');
      }
    } catch (e) {
      debugPrint('Error fetching wards: $e');
      flowDelegate.admitWardOptions.clear();
      flowDelegate.selectedAdmitWard.value = '';
      flowDelegate.admitBedOptions.clear();
    }
  }

  void _fetchBedsForWard(
    IPDAdmitFlowDelegate flowDelegate,
    ApiClient apiClient,
    String? placeKey,
    String? wardName,
  ) async {
    if (placeKey == null || placeKey.isEmpty) {
      flowDelegate.admitBedOptions.clear();
      return;
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.prefAuthorizationToken) ?? '';
      final targetInstituteId = flowDelegate.selectedInstituteId.value.isNotEmpty
          ? flowDelegate.selectedInstituteId.value
          : flowDelegate.instituteId;

      final req = GetBedsRequestModel(
        admitIn: placeKey,
        instituteId: targetInstituteId,
        name: wardName ?? '',
      );

      final resp = await apiClient.post(
        ApiEndpoints.getBeds,
        data: req.toJson(),
        options: dio.Options(headers: {'Authorization': token}),
      );
      if (resp.statusCode == 200 && resp.data != null) {
        final beds = resp.data['data'] ?? [];
        if (beds is List) {
          flowDelegate.admitBedOptions.value = beds
              .map((b) => b['bed_no']?.toString() ?? '')
              .toList();
        } else {
          flowDelegate.admitBedOptions.clear();
        }
      } else {
        flowDelegate.admitBedOptions.clear();
      }
    } catch (e) {
      debugPrint('Error fetching beds: $e');
      flowDelegate.admitBedOptions.clear();
    }
  }
}
