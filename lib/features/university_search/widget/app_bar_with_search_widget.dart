import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni_search/features/university_search/widget/search_field_widget.dart';

class AppBarWithSearchWidget extends StatefulWidget implements PreferredSizeWidget {
  const AppBarWithSearchWidget({
    required this.onQueryChanged,
    super.key,
  });

  final ValueChanged<String> onQueryChanged;

  @override
  Size get preferredSize => const Size(double.infinity, kToolbarHeight);

  @override
  State<AppBarWithSearchWidget> createState() => _AppBarWithSearchWidgetState();
}

class _AppBarWithSearchWidgetState extends State<AppBarWithSearchWidget> with SingleTickerProviderStateMixin {
  late final AnimationController searchAnimationController;
  late final Animation<double> searchScaleAnimation;

  final searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    searchAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    searchScaleAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: searchAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    searchAnimationController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  void onQueryChanged(String query) {
    widget.onQueryChanged(query);
  }

  void openSearch() {
    searchAnimationController.forward();
    searchFocusNode.requestFocus();
  }

  void closeSearch() {
    searchAnimationController.reverse();
    searchFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): closeSearch,
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AppBar(
            title: const Text('University Search'),
            actions: [
              IconButton(
                onPressed: openSearch,
                icon: const Icon(Icons.search),
              ),
            ],
          ),
          Align(
            alignment: const AlignmentDirectional(1.0, 0.8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ValueListenableBuilder<double>(
                valueListenable: searchScaleAnimation,
                builder: (context, scale, child) {
                  final scaleY = switch (scale) {
                    > 0.6 => clampDouble(scale * 1.05, 0.0, 1.0),
                    _ => scale,
                  };
                  return Transform.scale(
                    scaleX: scale,
                    scaleY: scaleY,
                    alignment: const FractionalOffset(1.0, 0.5),
                    child: child,
                  );
                },
                child: SearchFieldWidget(
                  focusNode: searchFocusNode,
                  onQueryChanged: onQueryChanged,
                  onClose: closeSearch,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
