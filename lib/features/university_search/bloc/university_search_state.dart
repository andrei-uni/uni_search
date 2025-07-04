part of 'university_search_bloc.dart';

@freezed
abstract class UniversitySearchState with _$UniversitySearchState {
  const factory UniversitySearchState({
    required CustomPagingState<int, University> pagingState,
    required String searchQuery,
  }) = _UniversitySearchState;
}
