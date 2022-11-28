// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:developer' as dev;

import 'package:flutter/foundation.dart' show debugPrint, kReleaseMode;
import 'package:logging/logging.dart' as log;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sentry/sentry.dart';

/// Simple logger class to log messages to console and/or to a crash reporting system.
///   To ensure correct usage it's implemented via singleton pattern.
///
/// On start the [Logger.instance.init] method must be called once to ensure
///   crash reporting system is configured as needed.
///
/// Internally [Sentry] is used as crash reporting system. It'll be configured
///   automatically, but only if [Env.instance.sentryDns] is configured properly.
///
/// Any log happens to [debugPrint] ONLY in debug mode, nothing will happen in
///   release mode.
///
/// Usage:
/// ```dart
/// Logger.instance
///         ..init()
///         ..logMessage('Message to log to console');
/// ```
class Logger {
  const Logger._();
  static const Logger instance = Logger._();
  static String? _sentryDns;
  Future<void> init({
    String? sentryDns,
  }) async {
    _sentryDns = sentryDns;
    await _initSentry();
    log.hierarchicalLoggingEnabled = true;
    log.Logger.root.level = log.Level.ALL; // defaults to Level.INFO
    log.Logger.root.onRecord.listen((log.LogRecord record) {
      logMessage('${record.level.name}: ${record.time}: ${record.message}\n');
    });
  }

  Future<void> _initSentry() async {
    if (_sentryDns?.isNotEmpty == true) {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();

      await Sentry.init(
        (SentryOptions options) {
          options
            ..debug = false
            ..sentryClientName = 'open_mind'
            ..release =
                'Build: ${packageInfo.buildNumber} :: Version: ${packageInfo.version} Store: ${packageInfo.installerStore} build_signature: ${packageInfo.buildSignature}'
            ..dsn = _sentryDns;
        },
      );
    }
  }

  void logMessage(String msg) {
    if (kReleaseMode) return;

    dev.log('Open_Mind App Log \n Message: $msg');
  }

  Future<void> logError(Object error, {StackTrace? stackTrace}) async {
    logMessage(
      'Open_Mind App Error: $error \n Stacktrace: $stackTrace',
    );
    if (Sentry.isEnabled)
      await Sentry.captureException(
        'Open_Mind App Error: $error',
        stackTrace: stackTrace,
      );
  }
}
