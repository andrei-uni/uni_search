import 'package:flutter/material.dart';
import 'package:uni_search/features/app_dependencies_scope/model/app_dependencies_container.dart';

class AppDependenciesScope extends InheritedWidget {
  const AppDependenciesScope({
    required this.appDependencies,
    required super.child,
    super.key,
  });

  final AppDependenciesContainer appDependencies;

  static AppDependenciesContainer of(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<AppDependenciesScope>();
    assert(scope != null, 'No $AppDependenciesScope in context');
    return scope!.appDependencies;
  }

  @override
  bool updateShouldNotify(covariant AppDependenciesScope oldWidget) {
    return false;
  }
}
