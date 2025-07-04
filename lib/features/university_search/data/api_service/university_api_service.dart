import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:uni_search/features/university_search/data/api_service/dtos/university_dto.dart';

part 'university_api_service.g.dart';

@RestApi()
abstract class UniversityApiService {
  factory UniversityApiService(Dio dio, {String? baseUrl}) = _UniversityApiService;

  @GET('/search')
  Future<List<UniversityDto>> getUniversities(
    @Query('name') String? name,
    @Query('country') String? country,
    @Query('limit') int limit,
    @Query('offset') int offset,
  );
}
