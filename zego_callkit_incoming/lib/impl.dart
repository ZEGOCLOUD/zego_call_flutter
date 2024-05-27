import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'defines.dart';
import 'plugin.dart';

/// An implementation of [ZegoCallkitIncomingPlatform] that uses method channels.
class ZegoCallIncomingPluginImpl extends ZegoCallIncomingPlugin {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('zego_callkit_incoming');

  /// launch_current_app
  @override
  Future<void> launchCurrentApp() async {
    if (Platform.isAndroid) {
      debugPrint('launchCurrentAPP, not support in Android');
      return;
    }
    debugPrint('launchCurrentAPP');

    try {
      await methodChannel.invokeMethod<String>('launch_current_app');
    } on PlatformException catch (e) {
      debugPrint('Failed to launch current App: $e.');
    }
  }

  /// active audio by callkit
  /// only support ios
  @override
  Future<void> activeAudioByCallKit() async {
    if (Platform.isAndroid) {
      debugPrint('activeAudioByCallKit, not support in Android');
      return;
    }

    debugPrint('activeAudioByCallKit');

    try {
      await methodChannel.invokeMethod<String>('activeAudioByCallKit');
    } on PlatformException catch (e) {
      debugPrint('Failed to active audio by callkit: $e.');
    }
  }

  /// check app running
  /// only support android
  @override
  Future<bool> checkAppRunning() async {
    if (Platform.isIOS) {
      debugPrint('checkAppRunning, not support in iOS');

      return false;
    }

    debugPrint('checkAppRunning');

    var isAppRunning = false;
    try {
      isAppRunning =
          await methodChannel.invokeMethod<bool?>('checkAppRunning') ?? false;
    } on PlatformException catch (e) {
      debugPrint('Failed to check app running: $e.');
    }

    return isAppRunning;
  }

  /// add local call notification
  /// only support android
  @override
  Future<void> addLocalCallNotification(
    ZegoLocalCallNotificationConfig config,
  ) async {
    if (Platform.isIOS) {
      debugPrint('addLocalCallNotification, not support in iOS');

      return;
    }

    debugPrint('addLocalCallNotification:$config');

    try {
      await methodChannel.invokeMethod('addLocalCallNotification', {
        'id': config.id.toString(),
        'sound_source': config.soundSource ?? '',
        'icon_source': config.iconSource ?? '',
        'channel_id': config.channelID,
        'title': config.title,
        'content': config.content,
        'accept_text': config.acceptButtonText,
        'reject_text': config.rejectButtonText,
        'vibrate': config.vibrate,
      });

      /// set buttons callback
      methodChannel.setMethodCallHandler((call) async {
        debugPrint(
            'MethodCallHandler, method:${call.method}, arguments:${call.arguments}.');

        switch (call.method) {
          case 'onNotificationAccepted':
            config.acceptCallback?.call();
            break;
          case 'onNotificationRejected':
            config.rejectCallback?.call();
            break;
          case 'onNotificationCancelled':
            config.cancelCallback?.call();
            break;
          case 'onNotificationClicked':
            config.clickCallback?.call();
        }
      });
    } on PlatformException catch (e) {
      debugPrint('Failed to add local notification: $e.');
    }
  }

  /// create notification channel
  /// only support android
  @override
  Future<void> createNotificationChannel(
    ZegoLocalNotificationChannelConfig config,
  ) async {
    if (Platform.isIOS) {
      debugPrint('createNotificationChannel, not support in iOS');

      return;
    }

    debugPrint('createNotificationChannel:$config');

    try {
      await methodChannel.invokeMethod('createNotificationChannel', {
        'channel_id': config.channelID,
        'channel_name': config.channelName,
        'sound_source': config.soundSource ?? '',
        'vibrate': config.vibrate,
      });
    } on PlatformException catch (e) {
      debugPrint('Failed to create notification channel: $e.');
    }
  }

  /// dismiss all notifications
  /// only support android
  @override
  Future<void> dismissAllNotifications() async {
    if (Platform.isIOS) {
      debugPrint('dismissAllNotifications, not support in iOS');

      return;
    }

    debugPrint('dismissAllNotifications');

    try {
      await methodChannel.invokeMethod('dismissAllNotifications', {});
    } on PlatformException catch (e) {
      debugPrint('Failed to dismiss all notifications: $e.');
    }
  }

  /// active app to foreground
  /// only support android
  @override
  Future<void> activeAppToForeground() async {
    if (Platform.isIOS) {
      debugPrint('activeAppToForeground, not support in iOS');

      return;
    }

    debugPrint('activeAppToForeground');

    try {
      await methodChannel.invokeMethod('activeAppToForeground', {});
    } on PlatformException catch (e) {
      debugPrint('Failed to active app to foreground: $e.');
    }
  }

  /// request dismiss keyguard
  /// only support android
  @override
  Future<void> requestDismissKeyguard() async {
    if (Platform.isIOS) {
      debugPrint('requestDismissKeyguard, not support in iOS');

      return;
    }

    debugPrint('requestDismissKeyguard');

    try {
      await methodChannel.invokeMethod('requestDismissKeyguard', {});
    } on PlatformException catch (e) {
      debugPrint('Failed to request dismiss keyguard: $e.');
    }
  }
}
