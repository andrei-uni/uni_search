part of 'university_search_bloc.dart';

@freezed
sealed class UniversitySearchEvent with _$UniversitySearchEvent {
  const factory UniversitySearchEvent.loadNext() = UniversitySearchEvent_LoadNext;

  const factory UniversitySearchEvent.queryChanged({
    required String query,
  }) = UniversitySearchEvent_QueryChanged;
}
