import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:uni_search/features/app_dependencies_scope/widget/app_dependencies_scope.dart';
import 'package:uni_search/features/university_search/bloc/university_search_bloc.dart';
import 'package:uni_search/features/university_search/data/get_universities_usecase.dart';
import 'package:uni_search/features/university_search/model/university.dart';
import 'package:uni_search/features/university_search/widget/app_bar_with_search_widget.dart';
import 'package:uni_search/features/university_search/widget/university_list_item_widget.dart';

class UniversitySearchScreen extends StatefulWidget {
  const UniversitySearchScreen({
    super.key,
  });

  @override
  State<UniversitySearchScreen> createState() => _UniversitySearchScreenState();
}

class _UniversitySearchScreenState extends State<UniversitySearchScreen> {
  late final UniversitySearchBloc universitySearchBloc;

  @override
  void initState() {
    super.initState();
    universitySearchBloc = UniversitySearchBloc(
      getUniversitiesUsecase: GetUniversitiesUsecase(
        universitySearchRepository: AppDependenciesScope.of(context).universitySearchRepository,
      ),
    );
  }

  @override
  void dispose() {
    universitySearchBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: universitySearchBloc,
      child: Scaffold(
        appBar: AppBarWithSearchWidget(
          onQueryChanged: (query) {
            universitySearchBloc.add(UniversitySearchEvent.queryChanged(query: query.trim()));
          },
        ),
        body: BlocBuilder<UniversitySearchBloc, UniversitySearchState>(
          builder: (context, state) {
            return PagedListView<int, University>.separated(
              state: state.pagingState,
              shrinkWrap: true,
              padding: EdgeInsets.only(
                left: 15,
                right: 15,
                top: 15,
                bottom: MediaQuery.paddingOf(context).bottom + 15,
              ),
              fetchNextPage: () {
                if (!state.pagingState.isLoading) {
                  universitySearchBloc.add(const UniversitySearchEvent.loadNext());
                }
              },
              separatorBuilder: (context, index) {
                return const SizedBox(height: 12);
              },
              builderDelegate: PagedChildBuilderDelegate(
                invisibleItemsThreshold: 2,
                itemBuilder: (context, university, index) {
                  return UniversityListItemWidget(
                    universityName: university.name,
                    universityCountry: university.country,
                    universityUrl: university.url,
                  );
                },
                noItemsFoundIndicatorBuilder: (context) {
                  return Center(
                    child: Text(
                      'No universities found',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  );
                },
                firstPageErrorIndicatorBuilder: (context) {
                  return _UniversitiesListErrorWidget(
                    onRetry: () {
                      universitySearchBloc.add(const UniversitySearchEvent.loadNext());
                    },
                  );
                },
                newPageErrorIndicatorBuilder: (context) {
                  return _UniversitiesListErrorWidget(
                    onRetry: () {
                      universitySearchBloc.add(const UniversitySearchEvent.loadNext());
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _UniversitiesListErrorWidget extends StatelessWidget {
  const _UniversitiesListErrorWidget({
    required this.onRetry,
  });

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Failed to fetch universities'),
          IconButton(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}
