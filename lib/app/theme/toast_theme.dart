import 'package:flutter/material.dart';
import 'package:theme_tailor_annotation/theme_tailor_annotation.dart';

part 'toast_theme.tailor.dart';

@TailorMixin()
class ToastTheme extends ThemeExtension<ToastTheme> with _$ToastThemeTailorMixin {
  const ToastTheme({
    required this.backgroundColor,
    required this.borderColor,
  });

  @override
  final Color backgroundColor;
  @override
  final Color borderColor;
}
