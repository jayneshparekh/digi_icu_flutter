import 'package:digi_icu_flutter/controllers/serving_patient_controller.dart';
import 'package:digi_icu_flutter/core/constants/api_endpoints.dart';
import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/models/request/doctor/quick_form_list_req.dart';
import 'package:digi_icu_flutter/models/response/doctor/form_list_response.dart';
import 'package:digi_icu_flutter/services/api/api_client.dart';
import 'package:digi_icu_flutter/views/screens/serving_patient_quick_form_view.dart';
import 'package:digi_icu_flutter/views/widgets/app_loading_overlay.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;

import 'package:digi_icu_flutter/views/screens/serving_patient_medical_form_view.dart';
import 'package:digi_icu_flutter/views/screens/serving_patient_clinical_form_screen.dart';
import 'package:digi_icu_flutter/views/widgets/prescription_row_tile.dart';
import 'package:digi_icu_flutter/views/widgets/app_snackbars.dart';

class ServingPatientFormTabView extends StatefulWidget {
  const ServingPatientFormTabView({super.key});

  @override
  State<ServingPatientFormTabView> createState() => _ServingPatientFormTabViewState();
}

class _ServingPatientFormTabViewState extends State<ServingPatientFormTabView> {
  final ApiClient _apiClient = ApiClient();
  String selectedHeaderTab = 'Clinical';
  bool isLoading = false;
  List<Map<String, dynamic>> formList = [];

  @override
  void initState() {
    super.initState();
    fetchClinicalFormList();
  }

  String _getPatientId() {
    String patientId = '';
    if (Get.isRegistered<ServingPatientController>()) {
      patientId = Get.find<ServingPatientController>().patientId;
    }
    if (patientId.isEmpty && Get.arguments is Map) {
      patientId = (Get.arguments as Map)['patientId']?.toString() ?? '';
    }
    return patientId;
  }

  Future<void> fetchQuickFormList() async {
    setState(() {
      isLoading = true;
    });
    try {
      final patientId = _getPatientId();
      final Response response = await _apiClient.post(
        ApiEndpoints.quickFormsList,
        data: QuickFormListReq(patientId: patientId).toJson(),
      );
      if (response.statusCode == 200 && response.data != null) {
        final formResponse = FormListResponse.fromJson(
          Map<String, dynamic>.from(response.data as Map),
        );
        if (formResponse.status == 'success') {
          setState(() {
            formList = formResponse.data.map((item) => {
              'id': item.id,
              'patient_note': item.patientNote,
              'created': item.created,
              'appointment_id': item.appointmentId,
              'first_name': item.firstName,
              'last_name': item.lastName,
            }).toList();
          });
        } else {
          setState(() {
            formList = [];
          });
        }
      } else {
        setState(() {
          formList = [];
        });
      }
    } catch (_) {
      setState(() {
        formList = [];
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchMedicalFormList() async {
    setState(() {
      isLoading = true;
    });
    try {
      final patientId = _getPatientId();
      final Response response = await _apiClient.post(
        ApiEndpoints.medicalFormsList,
        data: QuickFormListReq(patientId: patientId).toJson(),
      );
      if (response.statusCode == 200 && response.data != null) {
        final formResponse = FormListResponse.fromJson(
          Map<String, dynamic>.from(response.data as Map),
        );
        if (formResponse.status == 'success') {
          setState(() {
            formList = formResponse.data.reversed.map((item) => {
              'id': item.id,
              'patient_note': item.patientNote,
              'created': item.created,
              'appointment_id': item.appointmentId,
              'first_name': item.firstName,
              'last_name': item.lastName,
            }).toList();
          });
        } else {
          setState(() {
            formList = [];
          });
        }
      } else {
        setState(() {
          formList = [];
        });
      }
    } catch (_) {
      setState(() {
        formList = [];
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchClinicalFormList() async {
    setState(() {
      isLoading = true;
    });
    try {
      final patientId = _getPatientId();
      final Response response = await _apiClient.post(
        ApiEndpoints.clinicalFormsList,
        data: QuickFormListReq(patientId: patientId).toJson(),
      );
      if (response.statusCode == 200 && response.data != null) {
        final formResponse = FormListResponse.fromJson(
          Map<String, dynamic>.from(response.data as Map),
        );
        if (formResponse.status == 'success') {
          setState(() {
            final sorted = formResponse.data.reversed.toList()..sort((a,b) => (int.tryParse(b.id.toString()) ?? 0).compareTo(int.tryParse(a.id.toString()) ?? 0));
            formList = sorted.map((item) => {
              'id': item.id,
              'patient_note': item.patientNote,
              'created': item.created,
              'appointment_id': item.appointmentId,
              'first_name': item.firstName,
              'last_name': item.lastName,
            }).toList();
          });
        } else {
          setState(() {
            formList = [];
          });
        }
      } else {
        setState(() {
          formList = [];
        });
      }
    } catch (_) {
      setState(() {
        formList = [];
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildHeaderButton(String label, String tabKey, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: InkWell(
        onTap: () {
          setState(() {
            selectedHeaderTab = tabKey;
          });
          if (tabKey == 'Quick') {
            fetchQuickFormList();
          } else if (tabKey == 'Medical') {
            fetchMedicalFormList();
          } else if (tabKey == 'Clinical') {
            fetchClinicalFormList();
          } else {
            setState(() {
              formList = [];
            });
          }
        },
        child: Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.warning : AppColors.teal,
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            // Top Horizontal Header Tabs
            Container(
              color: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildHeaderButton('clinical_tab'.tr, 'Clinical', selectedHeaderTab == 'Clinical'),
                    _buildHeaderButton('medical_tab'.tr, 'Medical', selectedHeaderTab == 'Medical'),
                    _buildHeaderButton('quick_tab'.tr, 'Quick', selectedHeaderTab == 'Quick'),
                    _buildHeaderButton('phe_tab'.tr, 'PHE', selectedHeaderTab == 'PHE'),
                    _buildHeaderButton('doctor_note_tab'.tr, 'Doctor Note', selectedHeaderTab == 'Doctor Note'),
                  ],
                ),
              ),
            ),
            const Divider(height: 1, thickness: 1),

            // Action Row
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'form_records_label'.trParams({'type': selectedHeaderTab}),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy,
                    ),
                  ),
                  if (selectedHeaderTab != 'Medical' && selectedHeaderTab != 'Clinical')
                    ElevatedButton.icon(
                      onPressed: () {
                        if (selectedHeaderTab == 'Quick') {
                          Get.to(() => const ServingPatientQuickFormView(), arguments: {'formId': null});
                        } else if (selectedHeaderTab == 'Medical') {
                          Get.to(() => const ServingPatientMedicalFormView(), arguments: {'formId': null})?.then((res) {
                            if (res != null) {
                              fetchMedicalFormList();
                            }
                          });
                        } else if (selectedHeaderTab == 'Clinical') {
                          Get.to(() => const ServingPatientClinicalFormScreen(), arguments: {
                            'patientId': _getPatientId(),
                            'patientName': Get.isRegistered<ServingPatientController>() ? Get.find<ServingPatientController>().fullName : '',
                            'doctorId': Get.isRegistered<ServingPatientController>() ? Get.find<ServingPatientController>().doctorId : '',
                            'doctorName': '',
                            'formType': 'Clinical Form',
                          })?.then((res) {
                            if (res != null) {
                              AppSnackbars.showSuccess('success'.tr, 'form_submitted'.tr);
                              fetchClinicalFormList();
                            }
                          });
                        } else {
                          AppSnackbars.showInfo('info'.tr, 'Opening $selectedHeaderTab Form');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.teal,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                      icon: const Icon(Icons.add, size: 18, color: AppColors.white),
                      label: Text(
                        'add_form_btn'.trParams({'type': selectedHeaderTab}),
                        style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.medicalGray),

            // Form List View spanning full width
            Expanded(
              child: formList.isEmpty
                  ? Center(
                      child: Text(
                        'no_form_records_found'.tr,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.coolGray,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      itemCount: formList.length,
                      itemBuilder: (context, index) {
                        final item = formList[index];
                        final recordDate = item['created'] ?? 'N/A';
                        final visitIdStr = item['id']?.toString() ?? '';
                        return PrescriptionRowTile(
                          index: index + 1,
                          visitNo: visitIdStr,
                          labelPrefix: 'Form ID: ',
                          date: recordDate,
                          onTap: () {
                            if (selectedHeaderTab == 'Quick') {
                              Get.to(() => const ServingPatientQuickFormView(), arguments: {'formId': item['id']});
                            } else if (selectedHeaderTab == 'Medical') {
                              Get.to(() => const ServingPatientMedicalFormView(), arguments: {'formId': item['id']})?.then((res) {
                                if (res != null) {
                                  fetchMedicalFormList();
                                }
                              });
                            } else if (selectedHeaderTab == 'Clinical') {
                              Get.to(() => const ServingPatientClinicalFormScreen(), arguments: {
                                'patientId': _getPatientId(),
                                'formId': item['id'],
                                'patientName': Get.isRegistered<ServingPatientController>() ? Get.find<ServingPatientController>().fullName : '',
                                'doctorId': Get.isRegistered<ServingPatientController>() ? Get.find<ServingPatientController>().doctorId : '',
                              })?.then((res) {
                                if (res != null) {
                                  AppSnackbars.showSuccess('success'.tr, 'form_submitted'.tr);
                                  fetchClinicalFormList();
                                }
                              });
                            } else {
                              AppSnackbars.showInfo('info'.tr, 'Viewing Record');
                            }
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
        AppLoadingOverlay(isLoading: isLoading),
      ],
    );
  }
}
