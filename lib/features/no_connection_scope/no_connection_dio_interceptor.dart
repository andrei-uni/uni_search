import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show VoidCallback;
import 'package:uni_search/features/no_connection_scope/no_connection_exception.dart';

class NoConnectionDioInterceptor extends Interceptor {
  NoConnectionDioInterceptor({
    required this.onNoConnectionError,
  });

  final VoidCallback onNoConnectionError;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        onNoConnectionError();
        err = NoConnectionDioException(
          requestOptions: err.requestOptions,
          error: err.error,
          message: err.message,
          response: err.response,
          stackTrace: err.stackTrace,
        );

      default:
        break;
    }

    handler.next(err);
  }
}
