import 'package:digi_icu_flutter/core/constants/app_constants.dart';
import 'package:digi_icu_flutter/services/storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late StorageService storage;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    storage = await StorageService().init();
  });

  test('stores and reads session values through the storage service', () async {
    await storage.setString(AppConstants.prefAuthorizationToken, 'token-123');
    await storage.setString(AppConstants.prefUserId, 'user-42');
    await storage.setBool(AppConstants.prefIsLogin, true);

    expect(storage.token, 'token-123');
    expect(storage.userId, 'user-42');
    expect(storage.getBool(AppConstants.prefIsLogin), isTrue);
  });

  test('returns configured defaults for missing values', () {
    expect(storage.getString('missing'), isEmpty);
    expect(storage.getInt('missing'), 0);
    expect(storage.getBool('missing'), isFalse);
    expect(storage.containsKey('missing'), isFalse);
  });
}
