import 'package:uni_search/features/university_search/data/repository/university_search_repository.dart';
import 'package:uni_search/features/university_search/model/university.dart';

class GetUniversitiesUsecase {
  GetUniversitiesUsecase({
    required UniversitySearchRepository universitySearchRepository,
  }) : _universitySearchRepository = universitySearchRepository;

  final UniversitySearchRepository _universitySearchRepository;

  int _universitiesByCountryOffset = 0;
  final Set<University> _fetchedUniversitiesByName = {};

  Future<List<University>?> call({
    required String searchQuery,
    required int limit,
    required int offset,
  }) async {
    // Сначала ищем по имени. Если таких универов нет, то ищем по стране.
    // Если по имени пришло меньше, чем limit, то добиваем до лимита универами из поиска по стране.
    // И последующие запросы делаем по стране, исключая дубликаты.

    if (offset == 0) {
      // Начали поиск заново
      _universitiesByCountryOffset = 0;
      _fetchedUniversitiesByName.clear();
    }

    final List<University> result = [];

    if (_universitiesByCountryOffset == 0) {
      final universitiesByName = await _universitySearchRepository.getUniversitiesByName(
        name: searchQuery,
        limit: limit,
        offset: offset,
      );
      if (universitiesByName == null) {
        return null;
      }

      result.addAll(universitiesByName);
      _fetchedUniversitiesByName.addAll(universitiesByName);

      if (universitiesByName.length == limit) {
        return result;
      }
    }

    int neededUniversitiesCount = limit - result.length;
    assert(neededUniversitiesCount > 0);

    fetchLoop:
    while (true) {
      final universitiesByCountry = await _universitySearchRepository.getUniversitiesByCountry(
        country: searchQuery,
        limit: limit,
        offset: _universitiesByCountryOffset,
      );
      if (universitiesByCountry == null) {
        return null;
      }
      if (universitiesByCountry.isEmpty) {
        break fetchLoop;
      }

      duplicatesLoop:
      for (final university in universitiesByCountry) {
        _universitiesByCountryOffset++;

        if (_fetchedUniversitiesByName.contains(university)) {
          continue duplicatesLoop;
        }

        result.add(university);
        neededUniversitiesCount--;

        if (neededUniversitiesCount == 0) {
          break fetchLoop;
        }
      }
    }

    return result;
  }
}
