import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

abstract final class BlocTransformers {
  static EventTransformer<T> restartable<T>() {
    return (events, mapper) => events.switchMap(mapper);
  }

  static EventTransformer<T> debounceRestartable<T>(Duration debounceDuration) {
    return (events, mapper) => events.debounceTime(debounceDuration).switchMap(mapper);
  }
}
