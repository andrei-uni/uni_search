import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:uni_search/app/initialization/main_app.dart';
import 'package:uni_search/features/app_dependencies_scope/logic/app_dependencies_factory.dart';
import 'package:uni_search/features/app_dependencies_scope/widget/app_dependencies_scope.dart';
import 'package:uni_search/features/toast_scope/toast_wrapper.dart';

class AppRunner {
  void run() {
    final logger = Logger(
      printer: _SimpleLogPrinter(),
      output: ConsoleOutput(),
    );
    logger.i('Starting app');

    runZonedGuarded(
      () async {
        final appDependencies = await AppDependenciesFactory(logger: logger).create();

        Bloc.observer = _SimpleBlocObserver(logger: logger);

        logger.i('Running app');
        runApp(
          AppDependenciesScope(
            appDependencies: appDependencies,
            child: const ToastWrapper(
              child: MainApp(),
            ),
          ),
        );
      },
      (error, stackTrace) {
        logger.f('Top level exception', error: error, stackTrace: stackTrace);
      },
    );
  }
}

class _SimpleBlocObserver extends BlocObserver {
  _SimpleBlocObserver({
    required this.logger,
  });

  final Logger logger;

  void log(String message) {
    logger.i('BlocObserver: $message');
  }

  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    log('${bloc.runtimeType}: onCreate');
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);
    log('${bloc.runtimeType}: onClose');
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    log('${bloc.runtimeType}: onEvent: $event');
  }

  @override
  void onTransition(Bloc<dynamic, dynamic> bloc, Transition<dynamic, dynamic> transition) {
    super.onTransition(bloc, transition);
    log(
      '${bloc.runtimeType}: onTransition: '
      'Event: ${transition.event}; '
      'Next: ${transition.nextState}',
    );
  }
}

class _SimpleLogPrinter extends LogPrinter {
  @override
  List<String> log(LogEvent event) {
    final level = event.level.toString().split('.').last.toUpperCase();
    final timestamp = DateTime.now().toIso8601String();

    return [
      '[$timestamp] [$level] ${event.message}',
      if (event.error != null) '[$timestamp] [ERROR] Error: ${event.error}',
      if (event.stackTrace != null) '[$timestamp] [STACK] ${event.stackTrace}',
    ];
  }
}
