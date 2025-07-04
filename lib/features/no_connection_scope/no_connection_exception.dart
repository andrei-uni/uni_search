import 'package:dio/dio.dart';

class NoConnectionDioException extends DioException {
  NoConnectionDioException({
    RequestOptions? requestOptions,
    super.error,
    super.message,
    super.response,
    super.stackTrace,
  }) : super(
          requestOptions: requestOptions ?? RequestOptions(),
        );
}
