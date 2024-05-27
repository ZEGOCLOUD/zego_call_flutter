// Dart imports:
import 'dart:math';

import 'package:zego_callkit_incoming/zego_callkit_incoming.dart';

import 'defines.dart';
import 'package:zego_push/logger.dart';

class ZegoPushCallKitAndroid {
  Future<void> launchCurrentApp() async {
    return ZegoCallIncomingPlugin.instance.launchCurrentApp();
  }

  Future<bool> checkAppRunning() async {
    return ZegoCallIncomingPlugin.instance.checkAppRunning();
  }

  Future<void> addLocalCallNotification(
    ZegoPushCallKitCallNotificationConfig config,
  ) async {
    return ZegoCallIncomingPlugin.instance
        .addLocalCallNotification(ZegoLocalCallNotificationConfig(
      id: Random().nextInt(2147483647),
      vibrate: config.vibrate,
      iconSource: config.iconSource,
      soundSource: config.soundSource,
      channelID: config.channelID,
      title: config.title,
      content: config.content,
      acceptButtonText: config.acceptButtonText,
      rejectButtonText: config.rejectButtonText,
      acceptCallback: () async {
        ZegoPushLogger.logInfo(
          'LocalCallNotification, acceptCallback',
          tag: 'push',
          subTag: 'android-callkit',
        );

        config.acceptCallback?.call();

        await dismissAllNotifications();
        await activeAppToForeground();
        await requestDismissKeyguard();

        await launchCurrentApp();
      },
      rejectCallback: () async {
        ZegoPushLogger.logInfo(
          'LocalCallNotification, rejectCallback',
          tag: 'push',
          subTag: 'android-callkit',
        );

        config.rejectCallback?.call();

        await dismissAllNotifications();
      },
      cancelCallback: () {
        ZegoPushLogger.logInfo(
          'LocalCallNotification, cancelCallback',
          tag: 'push',
          subTag: 'android-callkit',
        );

        config.cancelCallback?.call();
      },
      clickCallback: () async {
        ZegoPushLogger.logInfo(
          'LocalCallNotification, acceptCallback',
          tag: 'push',
          subTag: 'android-callkit',
        );

        config.clickCallback?.call();

        await dismissAllNotifications();
        await activeAppToForeground();
        await requestDismissKeyguard();
      },
    ));
  }

  Future<void> createNotificationChannel(
    ZegoPushCallKitNotificationChannelConfig config,
  ) async {
    return ZegoCallIncomingPlugin.instance.createNotificationChannel(config);
  }

  Future<void> dismissAllNotifications() async {
    return ZegoCallIncomingPlugin.instance.dismissAllNotifications();
  }

  Future<void> activeAppToForeground() async {
    return ZegoCallIncomingPlugin.instance.activeAppToForeground();
  }

  Future<void> requestDismissKeyguard() async {
    return ZegoCallIncomingPlugin.instance.requestDismissKeyguard();
  }
}
