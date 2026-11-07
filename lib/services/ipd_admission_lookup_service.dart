import 'package:get/get.dart';

import '../core/constants/api_endpoints.dart';
import '../models/request/user/admit_place_request_model.dart';
import '../models/request/user/get_beds_request_model.dart';
import 'api/api_client.dart';

/// Retrieves the available IPD places, wards, and beds for an institute.
class IpdAdmissionLookupService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<List<String>> fetchWards({
    required String place,
    required String instituteId,
  }) async {
    if (place.isEmpty || instituteId.isEmpty) {
      return const [];
    }

    final response = await _apiClient.post(
      ApiEndpoints.whereAdmit,
      data: AdmitPlaceRequestModel(
        admitIn: place,
        instituteId: instituteId,
      ).toJson(),
    );

    if (response.statusCode != 200 || response.data is! Map) {
      return const [];
    }

    final data = (response.data as Map)['data'];
    if (data is! List) {
      return const [];
    }

    return data
        .whereType<Map>()
        .map((ward) => ward['name']?.toString() ?? '')
        .where((name) => name.isNotEmpty)
        .toList();
  }

  Future<List<String>> fetchBeds({
    required String place,
    required String ward,
    required String instituteId,
  }) async {
    if (place.isEmpty || instituteId.isEmpty) {
      return const [];
    }

    final response = await _apiClient.post(
      ApiEndpoints.getBeds,
      data: GetBedsRequestModel(
        admitIn: place,
        instituteId: instituteId,
        name: ward,
      ).toJson(),
    );

    if (response.statusCode != 200 || response.data is! Map) {
      return const [];
    }

    final data = (response.data as Map)['data'];
    if (data is! List) {
      return const [];
    }

    return data
        .whereType<Map>()
        .map((bed) => bed['bed_no']?.toString() ?? '')
        .where((bedNo) => bedNo.isNotEmpty)
        .toList();
  }
}
