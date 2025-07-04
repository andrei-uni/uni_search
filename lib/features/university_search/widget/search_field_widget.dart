import 'package:flutter/material.dart';
import 'package:uni_search/app/theme/search_field_theme.dart';

class SearchFieldWidget extends StatefulWidget {
  const SearchFieldWidget({
    required this.focusNode,
    required this.onQueryChanged,
    required this.onClose,
    super.key,
  });

  final FocusNode focusNode;
  final ValueChanged<String> onQueryChanged;
  final VoidCallback onClose;

  @override
  State<SearchFieldWidget> createState() => _SearchFieldWidgetState();
}

class _SearchFieldWidgetState extends State<SearchFieldWidget> {
  late final TextEditingController controller;

  String previousValue = '';

  @override
  void initState() {
    super.initState();
    controller = TextEditingController()..addListener(searchChanged);
  }

  @override
  void dispose() {
    controller
      ..removeListener(searchChanged)
      ..dispose();
    super.dispose();
  }

  void searchChanged() {
    final currentValue = controller.text;
    if (currentValue == previousValue) {
      return;
    }
    previousValue = currentValue;
    widget.onQueryChanged(currentValue);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final searchFieldTheme = theme.searchFieldTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: searchFieldTheme.backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(25)),
      ),
      child: TextField(
        controller: controller,
        focusNode: widget.focusNode,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Search',
          isCollapsed: true,
          contentPadding: const EdgeInsetsDirectional.only(start: 20),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: widget.onClose,
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.close),
              ),
              const SizedBox(width: 5),
            ],
          ),
        ),
      ),
    );
  }
}
