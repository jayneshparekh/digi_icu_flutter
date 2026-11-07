import 'package:dio/dio.dart';
import 'package:digi_icu_flutter/services/api/api_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps timeout failures to a retryable user message', () {
    final error = DioException(
      requestOptions: RequestOptions(path: '/signin'),
      type: DioExceptionType.connectionTimeout,
    );

    expect(ApiClient.errorMessageKey(error), 'request_timeout');
  });

  test('maps connection failures without exposing transport details', () {
    final error = DioException(
      requestOptions: RequestOptions(path: '/signin'),
      type: DioExceptionType.connectionError,
    );

    expect(ApiClient.errorMessageKey(error), 'connection_error');
  });

  test('distinguishes server failures from client responses', () {
    final serverError = DioException(
      requestOptions: RequestOptions(path: '/signin'),
      type: DioExceptionType.badResponse,
      response: Response<dynamic>(
        requestOptions: RequestOptions(path: '/signin'),
        statusCode: 503,
      ),
    );
    final clientError = DioException(
      requestOptions: RequestOptions(path: '/signin'),
      type: DioExceptionType.badResponse,
      response: Response<dynamic>(
        requestOptions: RequestOptions(path: '/signin'),
        statusCode: 401,
      ),
    );

    expect(ApiClient.errorMessageKey(serverError), 'server_unavailable');
    expect(ApiClient.errorMessageKey(clientError), 'request_failed');
  });
}
