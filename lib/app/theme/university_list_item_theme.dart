import 'package:flutter/material.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'university_list_item_theme.tailor.dart';

@TailorMixin()
class UniversityListItemTheme extends ThemeExtension<UniversityListItemTheme>
    with _$UniversityListItemThemeTailorMixin {
  const UniversityListItemTheme({
    required this.backgroundColor,
  });

  @override
  final Color backgroundColor;
}
