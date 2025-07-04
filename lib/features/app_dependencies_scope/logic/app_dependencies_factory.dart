import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:logger/logger.dart';
import 'package:uni_search/features/app_dependencies_scope/model/app_dependencies_container.dart';
import 'package:uni_search/features/no_connection_scope/no_connection_dio_interceptor.dart';
import 'package:uni_search/features/university_search/data/api_service/university_api_service.dart';
import 'package:uni_search/features/university_search/data/repository/university_search_repository.dart';
import 'package:uni_search/features/university_search/data/repository/university_search_repository_impl.dart';

class AppDependenciesFactory {
  AppDependenciesFactory({
    required this.logger,
  });

  final Logger logger;

  Future<AppDependenciesContainer> create() async {
    logger.i('Initializing dependencies');

    final noConnectionChangeNotifier = _NoConnectionChangeNotifier();
    final noConnectionDioInterceptor = NoConnectionDioInterceptor(
      onNoConnectionError: () => noConnectionChangeNotifier.notify(),
    );
    logger.i('Initialized $NoConnectionDioInterceptor');

    final universitySearchRepository = _createUniversitySearchRepository(noConnectionDioInterceptor);
    logger.i('Initialized $UniversitySearchRepository');

    return AppDependenciesContainer(
      universitySearchRepository: universitySearchRepository,
      noConnectionListenable: noConnectionChangeNotifier,
    );
  }

  UniversitySearchRepository _createUniversitySearchRepository(
    NoConnectionDioInterceptor noConnectionDioInterceptor,
  ) {
    final dio =
        Dio(
            BaseOptions(
              baseUrl: 'http://universities.hipolabs.com/',
            ),
          )
          ..interceptors.addAll([
            noConnectionDioInterceptor,
          ]);

    final apiService = UniversityApiService(dio);
    return UniversitySearchRepositoryImpl(universityApiService: apiService);
  }
}

class _NoConnectionChangeNotifier with ChangeNotifier {
  void notify() => notifyListeners();
}
