import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ToastWrapper extends StatelessWidget {
  const ToastWrapper({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      config: const ToastificationConfig(
        alignment: Alignment.topCenter,
        animationDuration: Duration(milliseconds: 500),
        maxTitleLines: 10,
        maxToastLimit: 2,
      ),
      child: child,
    );
  }
}
