import 'package:uni_search/features/university_search/model/university.dart';

abstract interface class UniversitySearchRepository {
  Future<List<University>?> getUniversitiesByName({
    required String name,
    required int limit,
    required int offset,
  });

  Future<List<University>?> getUniversitiesByCountry({
    required String country,
    required int limit,
    required int offset,
  });
}
