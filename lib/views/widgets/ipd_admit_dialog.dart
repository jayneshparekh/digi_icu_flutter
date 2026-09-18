import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:digi_icu_flutter/core/theme/app_colors.dart';
import 'package:digi_icu_flutter/controllers/serving_patient_controller.dart';
import 'package:digi_icu_flutter/services/api/api_client.dart';
import 'package:digi_icu_flutter/core/constants/api_endpoints.dart';
import 'package:dio/dio.dart' as dio;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:digi_icu_flutter/core/constants/app_constants.dart';

class IpdAdmitDialog extends StatelessWidget {
  final List<dynamic> instituteAmenities;
  final List<dynamic> beds;
  final VoidCallback onSubmit;

  const IpdAdmitDialog({
    super.key,
    required this.instituteAmenities,
    required this.beds,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ServingPatientController>();
    final ApiClient apiClient = Get.find<ApiClient>();
    final RxString selectedPlace = ''.obs;
    final RxString selectedWard = ''.obs;
    final RxString selectedBed = ''.obs;
    final RxString approxCost = ''.obs;
    final RxString approxDays = ''.obs;
    final RxString admissionAmount = ''.obs;
    final RxString admissionDate = ''.obs;
    final RxString admissionTime = ''.obs;
    final RxString dischargeDate = ''.obs;
    final RxString dischargeTime = ''.obs;
    final RxString advanceAmount = ''.obs;
    final RxString admissionPaymentStatus = ''.obs;
    final RxString admissionPaymentMode = ''.obs;
    final RxString advancePaymentStatus = ''.obs;
    final RxString advancePaymentMode = ''.obs;
    final RxString admissionTransactionId = ''.obs;
    final RxString advanceTransactionId = ''.obs;
    final RxString admissionNotes = ''.obs;
    final RxBool hasReferralDoctor = false.obs;
    final RxString referralDoctor = ''.obs;
    final TextEditingController admissionNotesController =
        TextEditingController();

    // Get institute name from amenities
    final String instituteName = instituteAmenities.isNotEmpty
        ? instituteAmenities[0]['institute_name']?.toString() ?? ''
        : '';

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text('admit'.tr),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Institute (display only)
            Text(
              instituteName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.navy,
              ),
            ),
            const SizedBox(height: 16),
            // Consultant Doctor
            Obx(() => DropdownButtonFormField<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'doctor'.tr,
                    border: OutlineInputBorder(),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  initialValue: controller.selectedAdmitDoctorId.value.isNotEmpty
                      ? controller.selectedAdmitDoctor.value
                      : null,
                  hint: Text('please_select_doctor'.tr),
                  items: controller.admitDoctors.map((doc) {
                    return DropdownMenuItem<String>(
                      value: doc['doctor_id']?.toString(),
                      child: Text(doc['doctor_name']?.toString() ?? ''),
                    );
                  }).toList(),
                  onChanged: (value) {
                    final index = controller.admitDoctors
                        .indexWhere((d) => d['doctor_id']?.toString() == value);
                    if (index >= 0) {
                      controller.selectedAdmitDoctorId.value =
                          controller.admitDoctors[index]['doctor_id']
                              ?.toString() ?? '';
                      controller.selectedAdmitDoctor.value =
                          controller.admitDoctors[index]['doctor_name']
                              ?.toString() ?? '';
                    }
                  },
                )),
            const SizedBox(height: 12),
            // Referral Doctor (conditional)
            Obx(() => hasReferralDoctor.value
                ? Column(
                    children: [
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: 'referral_doctor'.tr,
                          border: OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                        initialValue: referralDoctor.value.isNotEmpty
                            ? referralDoctor.value
                            : null,
                        hint: Text('please_select_doctor'.tr),
                        items: controller.admitDoctors.map((doc) {
                          return DropdownMenuItem<String>(
                            value: doc['doctor_id']?.toString(),
                            child: Text(doc['doctor_name']?.toString() ?? ''),
                          );
                        }).toList(),
                        onChanged: (value) {
                          referralDoctor.value = value ?? '';
                        },
                      ),
                      const SizedBox(height: 8),
                    ],
                  )
                : const SizedBox.shrink()),
            const SizedBox(height: 12),
            // Approx Cost & Days
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'approx_cost'.tr,
                      border: OutlineInputBorder(),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => approxCost.value = value,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'approx_days'.tr,
                      border: OutlineInputBorder(),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => approxDays.value = value,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Admission Charges
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'admission_amount'.tr,
                      border: OutlineInputBorder(),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => admissionAmount.value = value,
                  ),
                ),
                const SizedBox(width: 12),
                // Payment Status
                Obx(() => DropdownButtonFormField<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: 'payment_status'.tr,
                        border: OutlineInputBorder(),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      initialValue: admissionPaymentStatus.value.isNotEmpty
                          ? admissionPaymentStatus.value
                          : null,
                      items: ['Paid', 'Pending', 'Partial']
                          .map((status) => DropdownMenuItem<String>(
                                value: status,
                                child: Text(status),
                              ))
                          .toList(),
                      onChanged: (value) =>
                          admissionPaymentStatus.value = value ?? '',
                    )),
                const SizedBox(width: 8),
                // Payment Mode
                Obx(() => DropdownButtonFormField<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: 'payment_mode'.tr,
                        border: OutlineInputBorder(),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      initialValue: admissionPaymentMode.value.isNotEmpty
                          ? admissionPaymentMode.value
                          : null,
                      items: ['Cash', 'Card', 'UPI', 'Bank Transfer']
                          .map((mode) => DropdownMenuItem<String>(
                                value: mode,
                                child: Text(mode),
                              ))
                          .toList(),
                      onChanged: (value) =>
                          admissionPaymentMode.value = value ?? '',
                    )),
              ],
            ),
            const SizedBox(height: 12),
            // Date & Time Pickers
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        admissionDate.value =
                            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                      }
                    },
                    child: IgnorePointer(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'admission_date'.tr,
                          border: OutlineInputBorder(),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        controller: TextEditingController(
                            text: admissionDate.value),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (picked != null) {
                        admissionTime.value =
                            '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                      }
                    },
                    child: IgnorePointer(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'admission_time'.tr,
                          border: OutlineInputBorder(),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        controller: TextEditingController(
                            text: admissionTime.value),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Discharge Date & Time (optional)
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        dischargeDate.value =
                            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                      }
                    },
                    child: IgnorePointer(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'discharge_date'.tr,
                          border: OutlineInputBorder(),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        controller: TextEditingController(
                            text: dischargeDate.value),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (picked != null) {
                        dischargeTime.value =
                            '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                      }
                    },
                    child: IgnorePointer(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'discharge_time'.tr,
                          border: OutlineInputBorder(),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        controller: TextEditingController(
                            text: dischargeTime.value),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Advance Payment
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'advance_amount'.tr,
                      border: OutlineInputBorder(),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => advanceAmount.value = value,
                  ),
                ),
                const SizedBox(width: 12),
                // Advance Payment Status
                Obx(() => DropdownButtonFormField<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: 'advance_payment_status'.tr,
                        border: OutlineInputBorder(),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      initialValue: advancePaymentStatus.value.isNotEmpty
                          ? advancePaymentStatus.value
                          : null,
                      items: ['Paid', 'Pending']
                          .map((status) => DropdownMenuItem<String>(
                                value: status,
                                child: Text(status),
                              ))
                          .toList(),
                      onChanged: (value) =>
                          advancePaymentStatus.value = value ?? '',
                    )),
                const SizedBox(width: 8),
                // Advance Payment Mode
                Obx(() => DropdownButtonFormField<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: 'advance_payment_mode'.tr,
                        border: OutlineInputBorder(),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      initialValue: advancePaymentMode.value.isNotEmpty
                          ? advancePaymentMode.value
                          : null,
                      items: ['Cash', 'Card', 'UPI', 'Bank Transfer']
                          .map((mode) => DropdownMenuItem<String>(
                                value: mode,
                                child: Text(mode),
                              ))
                          .toList(),
                      onChanged: (value) =>
                          advancePaymentMode.value = value ?? '',
                    )),
              ],
            ),
            const SizedBox(height: 12),
            // Transaction IDs
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'admission_transaction_id'.tr,
                      border: OutlineInputBorder(),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    onChanged: (value) =>
                        admissionTransactionId.value = value,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'advance_transaction_id'.tr,
                      border: OutlineInputBorder(),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    onChanged: (value) =>
                        advanceTransactionId.value = value,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Place / Ward / Bed Selection (dynamic based on institute amenities)
            Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Place Selection
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: 'place'.tr,
                        border: OutlineInputBorder(),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      initialValue: selectedPlace.value.isNotEmpty
                          ? selectedPlace.value
                          : null,
                      hint: Text('please_select'.tr),
                      items: (_getUniquePlaces(instituteAmenities))
                          .map((place) => DropdownMenuItem<String>(
                                value: place,
                                child: Text(place),
                              ))
                          .toList(),
                      onChanged: (value) {
                        selectedPlace.value = value ?? '';
                        selectedWard.value = '';
                        selectedBed.value = '';
                        // Fetch wards for this place
                        _fetchWardsForPlace(controller, apiClient, value ?? '');
                      },
                    ),
                    const SizedBox(height: 12),
                    // Ward Selection
                    Obx(() => DropdownButtonFormField<String>(
                          isExpanded: true,
                          decoration: InputDecoration(
                            labelText: 'ward'.tr,
                            border: OutlineInputBorder(),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          initialValue: selectedWard.value.isNotEmpty
                              ? selectedWard.value
                              : null,
                          hint: Text('please_select'.tr),
                          items: controller.admitWardOptions.map((ward) =>
                              DropdownMenuItem<String>(
                                value: ward,
                                child: Text(ward),
                              ))
                          .toList(),
                          onChanged: (value) {
                            selectedWard.value = value ?? '';
                            selectedBed.value = '';
                            // Fetch beds for this ward
                            _fetchBedsForWard(controller, apiClient,
                                selectedPlace.value, value ?? '');
                          },
                        )),
                    const SizedBox(height: 12),
                    // Bed Selection
                    Obx(() => DropdownButtonFormField<String>(
                          isExpanded: true,
                          decoration: InputDecoration(
                            labelText: 'bed'.tr,
                            border: OutlineInputBorder(),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          initialValue: selectedBed.value.isNotEmpty
                              ? selectedBed.value
                              : null,
                          hint: Text('please_select'.tr),
                          items: controller.admitBedOptions.map((bed) =>
                              DropdownMenuItem<String>(
                                value: bed,
                                child: Text(bed),
                              ))
                          .toList(),
                          onChanged: (value) => selectedBed.value = value ?? '',
                        )),
                  ],
                )),
            const SizedBox(height: 16),
            // Admission Notes
            TextFormField(
              controller: admissionNotesController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'admission_notes'.tr,
                border: OutlineInputBorder(),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              onChanged: (value) => admissionNotes.value = value,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('cancel'.tr),
        ),
        Obx(() => ElevatedButton(
              onPressed: selectedPlace.value.isNotEmpty &&
                      selectedWard.value.isNotEmpty &&
                      selectedBed.value.isNotEmpty
                  ? () {
                      // Update controller with selected values
                      controller.selectedAdmitPlace.value = selectedPlace.value;
                      controller.selectedAdmitWard.value = selectedWard.value;
                      controller.selectedAdmitBed.value = selectedBed.value;
                      controller.approxCost.value = approxCost.value;
                      controller.approxDays.value = approxDays.value;
                      controller.admissionAmount.value = admissionAmount.value;
                      controller.admissionDate.value = admissionDate.value;
                      controller.admissionTime.value = admissionTime.value;
                      controller.dischargeDate.value = dischargeDate.value;
                      controller.dischargeTime.value = dischargeTime.value;
                      controller.advanceAmount.value = advanceAmount.value;
                      controller.admissionPaymentStatus.value =
                          admissionPaymentStatus.value;
                      controller.admissionPaymentMode.value =
                          admissionPaymentMode.value;
                      controller.advancePaymentStatus.value =
                          advancePaymentStatus.value;
                      controller.advancePaymentMode.value = advancePaymentMode.value;
                      controller.admissionTransactionId.value =
                          admissionTransactionId.value;
                      controller.advanceTransactionId.value =
                          advanceTransactionId.value;
                      controller.admissionNotes.value = admissionNotes.value;
                      controller.referralDoctor.value = referralDoctor.value;
                      Get.back();
                      onSubmit();
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.teal,
              ),
              child: Text('submit'.tr),
            )),
      ],
    );
  }

  List<String> _getUniquePlaces(List<dynamic> amenities) {
    final Set<String> places = {};
    for (var amenity in amenities) {
      final place = amenity['place']?.toString();
      if (place != null && place.isNotEmpty) {
        places.add(place);
      }
    }
    return places.toList();
  }

  void _fetchWardsForPlace(
      ServingPatientController controller,
      ApiClient apiClient,
      String? place) async {
    if (place == null || place.isEmpty) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token =
          prefs.getString(AppConstants.prefAuthorizationToken) ?? '';
      final resp = await apiClient.post(
        ApiEndpoints.whereAdmit,
        data: {
          'institute_id': controller.selectedInstituteId.value,
          'place': place,
        },
        options: dio.Options(headers: {'Authorization': token}),
      );
      if (resp.statusCode == 200 && resp.data != null) {
        final wards = resp.data['data'] ?? [];
        controller.admitWardOptions.value =
            wards.map((w) => w['ward_name']?.toString() ?? '').toList();
      }
    } catch (e) {
      debugPrint('Error fetching wards: $e');
    }
  }

  void _fetchBedsForWard(
      ServingPatientController controller,
      ApiClient apiClient,
      String? place,
      String? ward) async {
    if (place == null || place.isEmpty || ward == null || ward.isEmpty) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token =
          prefs.getString(AppConstants.prefAuthorizationToken) ?? '';
      final resp = await apiClient.post(
        ApiEndpoints.getBeds,
        data: {
          'institute_id': controller.selectedInstituteId.value,
          'place': place,
          'ward': ward,
        },
        options: dio.Options(headers: {'Authorization': token}),
      );
      if (resp.statusCode == 200 && resp.data != null) {
        final beds = resp.data['data'] ?? [];
        controller.admitBedOptions.value =
            beds.map((b) => b['bed_no']?.toString() ?? '').toList();
      }
    } catch (e) {
      debugPrint('Error fetching beds: $e');
    }
  }
}