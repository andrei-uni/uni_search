import 'package:json_annotation/json_annotation.dart';

part 'university_dto.g.dart';

@JsonSerializable(
  createFactory: true,
)
class UniversityDto {
  UniversityDto({
    required this.name,
    required this.country,
    required this.webPages,
  });

  final String name;
  final String country;
  final List<String> webPages;

  factory UniversityDto.fromJson(Map<String, dynamic> json) => _$UniversityDtoFromJson(json);
}
