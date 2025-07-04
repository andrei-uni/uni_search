import 'package:uni_search/features/no_connection_scope/no_connection_exception.dart';
import 'package:uni_search/features/university_search/data/api_service/mappers/university_mapper.dart';
import 'package:uni_search/features/university_search/data/api_service/university_api_service.dart';
import 'package:uni_search/features/university_search/data/repository/university_search_repository.dart';
import 'package:uni_search/features/university_search/model/university.dart';

class UniversitySearchRepositoryImpl implements UniversitySearchRepository {
  UniversitySearchRepositoryImpl({
    required UniversityApiService universityApiService,
  }) : _universityApiService = universityApiService;

  final UniversityApiService _universityApiService;

  @override
  Future<List<University>?> getUniversitiesByName({
    required String name,
    required int limit,
    required int offset,
  }) async {
    try {
      final universities = await _universityApiService.getUniversities(
        name,
        null,
        limit,
        offset,
      );
      return universities.map((u) => u.toModel()).toList();
    } on NoConnectionDioException catch (e) {
      return null;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<University>?> getUniversitiesByCountry({
    required String country,
    required int limit,
    required int offset,
  }) async {
    try {
      final universities = await _universityApiService.getUniversities(
        null,
        country,
        limit,
        offset,
      );
      return universities.map((u) => u.toModel()).toList();
    } on NoConnectionDioException catch (e) {
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
