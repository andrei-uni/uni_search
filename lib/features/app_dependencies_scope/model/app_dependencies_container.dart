import 'package:flutter/foundation.dart' show Listenable;
import 'package:uni_search/features/university_search/data/repository/university_search_repository.dart';

class AppDependenciesContainer {
  AppDependenciesContainer({
    required this.universitySearchRepository,
    required this.noConnectionListenable,
  });

  final UniversitySearchRepository universitySearchRepository;
  final Listenable noConnectionListenable;
}
