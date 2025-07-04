import 'package:flutter_test/flutter_test.dart';
import 'package:uni_search/features/university_search/data/get_universities_usecase.dart';
import 'package:uni_search/features/university_search/data/repository/university_search_repository.dart';
import 'package:uni_search/features/university_search/model/university.dart';

class TestUniversitySearchRepository implements UniversitySearchRepository {
  TestUniversitySearchRepository({
    required this.nameResults,
    required this.countryResults,
  });

  final List<University>? nameResults;
  final List<University>? countryResults;

  @override
  Future<List<University>?> getUniversitiesByName({
    required String name,
    required int limit,
    required int offset,
  }) async {
    if (nameResults == null) {
      return null;
    }
    return nameResults!.skip(offset).take(limit).toList();
  }

  @override
  Future<List<University>?> getUniversitiesByCountry({
    required String country,
    required int limit,
    required int offset,
  }) async {
    if (countryResults == null) {
      return null;
    }
    return countryResults!.skip(offset).take(limit).toList();
  }
}

class MultiPageRepo implements UniversitySearchRepository {
  MultiPageRepo({
    required this.nameResults,
    required this.countryPages,
  });

  final List<University>? nameResults;
  final List<List<University>?> countryPages;

  int _page = 0;

  @override
  Future<List<University>?> getUniversitiesByName({
    required String name,
    required int limit,
    required int offset,
  }) async {
    return nameResults;
  }

  @override
  Future<List<University>?> getUniversitiesByCountry({
    required String country,
    required int limit,
    required int offset,
  }) async {
    if (_page >= countryPages.length) {
      return [];
    }
    final res = countryPages[_page];
    _page++;
    return res;
  }
}

void main() {
  group('GetUniversitiesUsecase', () {
    const query = 'Test';
    const uA = University(name: 'A', country: 'Test', url: null);
    const uB = University(name: 'B', country: 'Test', url: null);
    const uC = University(name: 'C', country: 'Test', url: null);
    const uD = University(name: 'D', country: 'Test', url: null);

    test('возвращает только результаты по имени, если их ровно limit', () async {
      final repository = TestUniversitySearchRepository(
        nameResults: [uA, uB, uC],
        countryResults: [uD],
      );
      final usecase = GetUniversitiesUsecase(universitySearchRepository: repository);

      final result = await usecase.call(searchQuery: query, limit: 2, offset: 0);
      expect(result, [uA, uB]);
    });

    test('учитывает offset при поиске по имени', () async {
      final repository = TestUniversitySearchRepository(
        nameResults: [uA, uB, uC],
        countryResults: [uD],
      );
      final usecase = GetUniversitiesUsecase(universitySearchRepository: repository);

      final result = await usecase.call(searchQuery: query, limit: 2, offset: 1);
      expect(result, [uB, uC]);
    });

    test('дополняет результат до limit из страны, если nameResults меньше limit', () async {
      final repository = TestUniversitySearchRepository(
        nameResults: [uA],
        countryResults: [uB, uC, uD],
      );
      final usecase = GetUniversitiesUsecase(universitySearchRepository: repository);

      final result = await usecase.call(searchQuery: query, limit: 3, offset: 0);
      expect(result, [uA, uB, uC]);
    });

    test('возвращает пустой список, если нет ни по имени, ни по стране', () async {
      final repository = TestUniversitySearchRepository(
        nameResults: [],
        countryResults: [],
      );
      final usecase = GetUniversitiesUsecase(universitySearchRepository: repository);

      final result = await usecase.call(searchQuery: query, limit: 5, offset: 0);
      expect(result, isEmpty);
    });

    test('возвращает элементы из разных страниц страны без дубликатов', () async {
      final repo = MultiPageRepo(
        nameResults: [uA],
        countryPages: [
          [uB],
          [uC],
        ],
      );
      final usecase = GetUniversitiesUsecase(universitySearchRepository: repo);

      final result = await usecase.call(searchQuery: query, limit: 3, offset: 0);
      expect(result, [uA, uB, uC]);
    });

    test('возвращает элементы из разных страниц страны без дубликатов 2', () async {
      final repo = MultiPageRepo(
        nameResults: [uA, uB],
        countryPages: [
          [uB],
          [uA],
          [uC],
        ],
      );
      final usecase = GetUniversitiesUsecase(universitySearchRepository: repo);

      final result = await usecase.call(searchQuery: query, limit: 3, offset: 0);
      expect(result, [uA, uB, uC]);
    });

    test('возвращает null при ошибке на первом шаге name fetch', () async {
      final repository = TestUniversitySearchRepository(
        nameResults: null,
        countryResults: [uA],
      );
      final usecase = GetUniversitiesUsecase(universitySearchRepository: repository);
      final result = await usecase.call(searchQuery: query, limit: 1, offset: 0);
      expect(result, isNull);
    });

    test('возвращает null при ошибке fetch country на второй странице', () async {
      final repo = MultiPageRepo(
        nameResults: [uA],
        countryPages: [
          [uB],
          null,
        ],
      );
      final usecase = GetUniversitiesUsecase(universitySearchRepository: repo);
      final result = await usecase.call(searchQuery: query, limit: 3, offset: 0);
      expect(result, isNull);
    });
  });
}
