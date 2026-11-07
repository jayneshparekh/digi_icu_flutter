import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;

import '../../core/constants/app_constants.dart';
import '../storage_service.dart';

/// Shared HTTP client for API calls.
///
/// Authentication is added here so feature controllers do not need to repeat
/// token lookup and header construction for every request.
class ApiClient {
  late final Dio _dio;

  /// Maps transport failures to localization keys instead of exposing raw
  /// Dio messages, URLs, or server details to users.
  static String errorMessageKey(Object error) {
    if (error is! DioException) {
      return 'unexpected_error';
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return 'request_timeout';
      case DioExceptionType.connectionError:
        return 'connection_error';
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? 0;
        return statusCode >= 500 ? 'server_unavailable' : 'request_failed';
      case DioExceptionType.cancel:
        return 'request_cancelled';
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return 'unexpected_error';
    }
  }

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: AppConstants.connectTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (Get.isRegistered<StorageService>()) {
            final token = StorageService.to.token;
            if (token.isNotEmpty &&
                !options.headers.containsKey('Authorization')) {
              options.headers['Authorization'] = token;
            }
          }
          handler.next(options);
        },
      ),
    );
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.get(path, queryParameters: queryParameters, options: options);
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}
