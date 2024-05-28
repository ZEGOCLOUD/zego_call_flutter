// Flutter imports:
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;

// Package imports:
import 'package:flutter_logs/flutter_logs.dart';

/// @nodoc
class ZegoLiveLogger {
  static bool isZegoLiveLoggerInit = false;

  /// init log
  Future<void> initLog() async {
    if (isZegoLiveLoggerInit) {
      return;
    }

    if (kIsWeb) {
      return;
    }

    isZegoLiveLoggerInit = true;

    return FlutterLogs.initLogs(
            logLevelsEnabled: [
              LogLevel.INFO,
              LogLevel.WARNING,
              LogLevel.ERROR,
              LogLevel.SEVERE
            ],
            timeStampFormat: TimeStampFormat.TIME_FORMAT_24_FULL,
            directoryStructure: DirectoryStructure.SINGLE_FILE_FOR_DAY,
            logTypesEnabled: ['device', 'network', 'errors'],
            logFileExtension: LogFileExtension.LOG,
            logsWriteDirectoryName: 'zego/live',
            logsExportDirectoryName: 'zego/live/Exported',
            debugFileOperations: true,
            isDebuggable: true)
        .then((value) {
      FlutterLogs.setDebugLevel(0);
      FlutterLogs.logInfo(
        'log',
        'init',
        '==========================================$value',
      );
    });
  }

  /// clear logs
  Future<void> clearLogs() async {
    FlutterLogs.clearLogs();
  }

  /// log info
  static Future<void> logInfo(
    String logMessage, {
    String tag = '',
    String subTag = '',
  }) async {
    if (!isZegoLiveLoggerInit) {
      debugPrint(
          '[INFO] ${DateTime.now().toString()} [$tag] [$subTag] $logMessage');
      return;
    }

    return FlutterLogs.logInfo(tag, subTag, logMessage);
  }

  /// log warn
  static Future<void> logWarn(
    String logMessage, {
    String tag = '',
    String subTag = '',
  }) async {
    if (!isZegoLiveLoggerInit) {
      debugPrint(
          '[WARN] ${DateTime.now().toString()} [$tag] [$subTag] $logMessage');
      return;
    }

    return FlutterLogs.logWarn(tag, subTag, logMessage);
  }

  /// log error
  static Future<void> logError(
    String logMessage, {
    String tag = '',
    String subTag = '',
  }) async {
    if (!isZegoLiveLoggerInit) {
      debugPrint(
          '[ERROR] ${DateTime.now().toString()} [$tag] [$subTag] $logMessage');
      return;
    }

    return FlutterLogs.logError(tag, subTag, logMessage);
  }

  /// log error trace
  static Future<void> logErrorTrace(
    String logMessage,
    Error e, {
    String tag = '',
    String subTag = '',
  }) async {
    if (!isZegoLiveLoggerInit) {
      debugPrint(
          '[ERROR] ${DateTime.now().toString()} [$tag] [$subTag] $logMessage');
      return;
    }

    return FlutterLogs.logErrorTrace(tag, subTag, logMessage, e);
  }
}
