import 'package:flutter/foundation.dart' show PlatformDispatcher, kReleaseMode;
import 'package:flutter/material.dart'
    show
        FlutterErrorDetails,
        FlutterError,
        WidgetsFlutterBinding,
        runApp,
        ErrorWidget,
        Material,
        Text,
        TextAlign,
        Widget;
import 'package:gasstation_locator/src/app.dart';
import 'package:gasstation_locator/src/env.dart';
import 'package:gasstation_locator/src/logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Logger.instance.init(sentryDns: Env.instance.sentryDns);

  /// It ensures crash reporting only happens in release mode
  if (kReleaseMode) _prepareErrorHandling();

  runApp(const App());
}

/// Create error handling
void _prepareErrorHandling() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    Logger.instance.logError(details.exception, stackTrace: details.stack);
  };
  PlatformDispatcher.instance.onError = (Object error, StackTrace? stack) {
    FlutterError.dumpErrorToConsole(
      FlutterErrorDetails(exception: error, stack: stack),
    );
    Logger.instance.logError(error, stackTrace: stack);

    return true;
  };
  ErrorWidget.builder = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    Logger.instance.logError(
      details.exception,
      stackTrace: details.stack,
    );

    final Widget error = Material(
      child: Text(
        'Sorry! An error happened: ${details.exception}',
        textAlign: TextAlign.center,
      ),
    );

    return error;
  };
}
