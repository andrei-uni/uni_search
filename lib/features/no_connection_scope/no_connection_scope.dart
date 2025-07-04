import 'package:flutter/material.dart';
import 'package:uni_search/features/app_dependencies_scope/widget/app_dependencies_scope.dart';
import 'package:uni_search/features/toast_scope/toast_scope.dart';

class NoConnectionScope extends StatefulWidget {
  const NoConnectionScope({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  State<NoConnectionScope> createState() => _NoConnectionScopeState();
}

class _NoConnectionScopeState extends State<NoConnectionScope> {
  @override
  void initState() {
    super.initState();
    AppDependenciesScope.of(context).noConnectionListenable.addListener(showNoConnectionMessage);
  }

  void showNoConnectionMessage() {
    ToastScope.of(context).showErrorToast(
      autoCloseDuration: const Duration(milliseconds: 2000),
      icon: Icons.signal_wifi_connected_no_internet_4_rounded,
      error: 'No connection',
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
