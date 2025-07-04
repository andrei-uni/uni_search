import 'package:flutter/material.dart';
import 'package:uni_search/app/theme/app_theme.dart';
import 'package:uni_search/features/no_connection_scope/no_connection_scope.dart';
import 'package:uni_search/features/toast_scope/toast_scope.dart';
import 'package:uni_search/features/university_search/widget/university_search_screen.dart';

class MainApp extends StatelessWidget {
  const MainApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const UniversitySearchScreen(),
      builder: (context, child) {
        return ToastScope(
          child: NoConnectionScope(
            child: child!,
          ),
        );
      },
    );
  }
}
