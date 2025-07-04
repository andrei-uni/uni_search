import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uni_search/features/university_search/data/get_universities_usecase.dart';
import 'package:uni_search/features/university_search/model/university.dart';
import 'package:uni_search/utils/bloc_transformers.dart';
import 'package:uni_search/utils/custom_paging_state.dart';

part 'university_search_event.dart';
part 'university_search_state.dart';
part 'university_search_bloc.freezed.dart';

class UniversitySearchBloc extends Bloc<UniversitySearchEvent, UniversitySearchState> {
  UniversitySearchBloc({
    required GetUniversitiesUsecase getUniversitiesUsecase,
  }) : _getUniversitiesUsecase = getUniversitiesUsecase,
       super(
         UniversitySearchState(
           pagingState: CustomPagingState(),
           searchQuery: '',
         ),
       ) {
    on<UniversitySearchEvent_LoadNext>(
      _onLoadNext,
      transformer: BlocTransformers.restartable(),
    );
    on<UniversitySearchEvent_QueryChanged>(
      _onQueryChanged,
      transformer: BlocTransformers.debounceRestartable(const Duration(milliseconds: 500)),
    );
  }

  final GetUniversitiesUsecase _getUniversitiesUsecase;

  static const int _universitiesLimit = 20;

  Future<void> _onLoadNext(UniversitySearchEvent_LoadNext event, Emitter<UniversitySearchState> emit) async {
    final pagingState = state.pagingState;

    emit(
      state.copyWith(
        pagingState: pagingState.copyWith(
          isLoading: true,
          error: null,
        ),
      ),
    );

    final offset = pagingState.length;

    final newUniversities = await _getUniversitiesUsecase.call(
      limit: _universitiesLimit,
      offset: offset,
      searchQuery: state.searchQuery,
    );

    if (newUniversities == null) {
      emit(
        state.copyWith(
          pagingState: pagingState.copyWith(
            error: Object(),
          ),
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        pagingState: pagingState.copyWith(
          pages: [...?pagingState.pages, newUniversities],
          keys: [...?pagingState.keys, offset],
          hasNextPage: newUniversities.length >= _universitiesLimit,
          isLoading: false,
          error: null,
        ),
      ),
    );
  }

  void _onQueryChanged(UniversitySearchEvent_QueryChanged event, Emitter<UniversitySearchState> emit) {
    emit(
      UniversitySearchState(
        pagingState: state.pagingState.reset(),
        searchQuery: event.query,
      ),
    );
  }
}
