import 'package:digi_icu_flutter/models/response/users/login_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses a login response and nested patient data', () {
    final response = LoginResponse.fromJson({
      'status': 'success',
      'auth_token': 'token-123',
      'data': {
        'id': 42,
        'user_type': 'Doctor',
        'first_name': 'Asha',
        'surname': 'Shah',
        'mhc_id': 'MHC-42',
        'gender': 'Female',
        'age': 35,
        'mobile_no': 9876543210,
        'mhc_email': 'asha@example.com',
        'screening_id': 7,
        'section_2': null,
        'section_3': null,
      },
      'patient_list': [],
    });

    expect(response.status, 'success');
    expect(response.authToken, 'token-123');
    expect(response.data?.id, '42');
    expect(response.data?.firstName, 'Asha');
    expect(response.data?.age, '35');
    expect(response.data?.section2, isEmpty);
  });

  test('uses safe defaults for missing login fields', () {
    final response = LoginResponse.fromJson(const {});

    expect(response.status, isEmpty);
    expect(response.authToken, isEmpty);
    expect(response.data, isNull);
    expect(response.patientList, isEmpty);
  });
}
