import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:uni_search/app/theme/toast_theme.dart';

class ToastScope extends StatefulWidget {
  const ToastScope({
    required this.child,
    super.key,
  });

  final Widget child;

  static ToastScopeState of(BuildContext context) {
    final ToastScopeState? state = context.findAncestorStateOfType<ToastScopeState>();
    assert(state != null, 'No $ToastScopeState in context');
    return state!;
  }

  @override
  State<ToastScope> createState() => ToastScopeState();
}

class ToastScopeState extends State<ToastScope> {
  static const IconData _defaultErrorIcon = Icons.error_outline_rounded;

  void showErrorToast({
    required String error,
    Duration? autoCloseDuration,
    IconData? icon,
  }) {
    toastification.showCustom(
      context: context,
      autoCloseDuration: autoCloseDuration,
      builder: (context, holder) {
        final theme = Theme.of(context);
        final toastTheme = theme.toastTheme;

        return Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.paddingOf(context).top + 10,
            left: 10,
            right: 10,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 65,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: toastTheme.backgroundColor,
                border: Border.fromBorderSide(
                  BorderSide(
                    color: toastTheme.borderColor,
                    width: 1.5,
                  ),
                ),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 22, right: 10, top: 20, bottom: 20),
                child: Row(
                  children: [
                    Icon(
                      icon ?? _defaultErrorIcon,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        error,
                        style: theme.textTheme.titleSmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
