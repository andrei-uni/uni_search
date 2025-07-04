import 'package:uni_search/features/university_search/data/api_service/dtos/university_dto.dart';
import 'package:uni_search/features/university_search/model/university.dart';

extension UniversityMapper on UniversityDto {
  University toModel() {
    return University(
      name: name,
      country: country,
      url: webPages.firstOrNull,
    );
  }
}
