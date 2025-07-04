import 'package:flutter/material.dart';
import 'package:uni_search/app/theme/search_field_theme.dart';
import 'package:uni_search/app/theme/toast_theme.dart';
import 'package:uni_search/app/theme/university_list_item_theme.dart';

abstract final class AppTheme {
  static ThemeData get light {
    return _baseTheme(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color.fromARGB(255, 68, 134, 255),
        brightness: Brightness.light,
      ),
      toastTheme: const ToastTheme(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        borderColor: Color.fromARGB(255, 235, 235, 235),
      ),

      universityListItemTheme: const UniversityListItemTheme(
        backgroundColor: Color.fromARGB(255, 235, 238, 252),
      ),
      searchFieldTheme: const SearchFieldTheme(
        backgroundColor: Color.fromARGB(255, 207, 220, 243),
      ),
    );
  }

  static ThemeData get dark {
    return _baseTheme(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color.fromARGB(255, 22, 57, 122),
        brightness: Brightness.dark,
      ),
      toastTheme: const ToastTheme(
        backgroundColor: Color.fromARGB(255, 37, 37, 37),
        borderColor: Color.fromARGB(255, 49, 49, 49),
      ),
      universityListItemTheme: const UniversityListItemTheme(
        backgroundColor: Color.fromARGB(255, 29, 40, 51),
      ),
      searchFieldTheme: const SearchFieldTheme(
        backgroundColor: Color.fromARGB(255, 20, 37, 68),
      ),
    );
  }

  static ThemeData _baseTheme({
    required ColorScheme colorScheme,
    required ToastTheme toastTheme,
    required UniversityListItemTheme universityListItemTheme,
    required SearchFieldTheme searchFieldTheme,
  }) {
    return ThemeData(
      colorScheme: colorScheme,
      appBarTheme: const AppBarTheme(
        surfaceTintColor: Colors.transparent,
      ),
      extensions: [
        toastTheme,
        universityListItemTheme,
        searchFieldTheme,
      ],
    );
  }
}
