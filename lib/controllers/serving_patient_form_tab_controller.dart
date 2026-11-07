import 'package:get/get.dart';

import '../core/constants/api_endpoints.dart';
import '../models/request/doctor/quick_form_list_req.dart';
import '../models/response/doctor/form_list_response.dart';
import '../services/api/api_client.dart';

/// Loads form records displayed in the serving-patient form tab.
class ServingPatientFormTabController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<List<FormListData>> fetchForms({
    required String tab,
    required String patientId,
  }) async {
    final endpoint = switch (tab) {
      'Quick' => ApiEndpoints.quickFormsList,
      'Medical' => ApiEndpoints.medicalFormsList,
      'Clinical' => ApiEndpoints.clinicalFormsList,
      _ => null,
    };

    if (endpoint == null) {
      return const [];
    }

    final response = await _apiClient.post(
      endpoint,
      data: QuickFormListReq(patientId: patientId).toJson(),
    );

    if (response.statusCode != 200 || response.data is! Map) {
      return const [];
    }

    final formResponse = FormListResponse.fromJson(
      Map<String, dynamic>.from(response.data as Map),
    );

    if (formResponse.status != 'success') {
      return const [];
    }

    final forms = formResponse.data.toList();
    if (tab == 'Clinical' || tab == 'Medical') {
      forms.sort(
        (a, b) => (int.tryParse(b.id.toString()) ?? 0).compareTo(
          int.tryParse(a.id.toString()) ?? 0,
        ),
      );
    }
    return forms;
  }
}
