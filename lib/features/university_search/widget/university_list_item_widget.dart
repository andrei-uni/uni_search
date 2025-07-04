import 'package:flutter/material.dart';
import 'package:uni_search/app/theme/university_list_item_theme.dart';
import 'package:url_launcher/url_launcher_string.dart' as url_launcher;

class UniversityListItemWidget extends StatelessWidget {
  const UniversityListItemWidget({
    required this.universityName,
    required this.universityCountry,
    required this.universityUrl,
    super.key,
  });

  final String universityName;
  final String universityCountry;
  final String? universityUrl;

  static const BorderRadius _borderRadius = BorderRadius.all(Radius.circular(15));

  void _onTap() {
    if (universityUrl case String url) {
      url_launcher.launchUrlString(url).ignore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final universityListItemTheme = theme.universityListItemTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: universityListItemTheme.backgroundColor,
        borderRadius: _borderRadius,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _onTap,
          borderRadius: _borderRadius,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  universityName,
                  style: textTheme.titleMedium,
                ),
                Text(
                  universityCountry,
                  style: textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
