import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

base class CustomPagingState<PageKeyType, ItemType> extends PagingStateBase<PageKeyType, ItemType> {
  CustomPagingState({
    super.pages,
    super.keys,
    super.error,
    super.hasNextPage = true,
    super.isLoading = false,
  });

  int get length {
    if (pages == null) {
      return 0;
    }
    return pages!.fold(0, (prev, page) => prev + page.length);
  }

  @override
  bool operator ==(Object other) => identical(this, other);

  @override
  int get hashCode => identityHashCode(this);

  @override
  String toString() {
    return 'CustomPagingState(pages: ${pages?.length}, '
        'length: $length, error: $error, hasNextPage: $hasNextPage, isLoading: $isLoading)';
  }

  @override
  CustomPagingState<PageKeyType, ItemType> reset() {
    return CustomPagingState(
      pages: null,
      keys: null,
      error: null,
      hasNextPage: true,
      isLoading: false,
    );
  }

  @override
  CustomPagingState<PageKeyType, ItemType> copyWith({
    Defaulted<List<List<ItemType>>?>? pages = const Omit(),
    Defaulted<List<PageKeyType>?>? keys = const Omit(),
    Defaulted<Object?>? error = const Omit(),
    Defaulted<bool>? hasNextPage = const Omit(),
    Defaulted<bool>? isLoading = const Omit(),
  }) {
    return CustomPagingState(
      pages: pages is Omit ? this.pages : pages as List<List<ItemType>>?,
      keys: keys is Omit ? this.keys : keys as List<PageKeyType>?,
      error: error is Omit ? this.error : error as Object?,
      hasNextPage: hasNextPage is Omit ? this.hasNextPage : hasNextPage as bool,
      isLoading: isLoading is Omit ? this.isLoading : isLoading as bool,
    );
  }
}
