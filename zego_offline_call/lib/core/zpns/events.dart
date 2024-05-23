// Dart imports:
import 'dart:async';

// Package imports:
import 'package:zego_zpns/zego_zpns.dart';

// Project imports:
import 'package:zego_offline_call/core/zpns/defines.dart';
import 'package:zego_offline_call/logger.dart';

class ZPNSEvent {
  /// zpns notification
  final notificationRegisteredEvent =
      StreamController<ZegoZPNSNotificationRegisteredEvent>.broadcast();
  final notificationArrivedEvent =
      StreamController<ZegoZPNSMessageEvent>.broadcast();
  final notificationClickedEvent =
      StreamController<ZegoZPNSMessageEvent>.broadcast();
  final throughMessageReceivedEvent =
      StreamController<ZegoZPNSMessageEvent>.broadcast();

  void register() {
    ZPNsEventHandler.onRegistered = (ZPNsRegisterMessage registerMessage) {
      ZegoCallLogger.logInfo(
        'onRegistered, registerMessage: { '
        'pushID:${registerMessage.pushID}, '
        'errorCode:${registerMessage.errorCode}, '
        'pushSourceType:${registerMessage.pushSourceType}, '
        'errorMessage:${registerMessage.errorMessage}, '
        'commandResult:${registerMessage.commandResult} }',
        tag: 'call',
        subTag: 'zpns,event',
      );

      notificationRegisteredEvent.add(
        ZegoZPNSNotificationRegisteredEvent(
          pushID: registerMessage.pushID,
          code: registerMessage.errorCode,
        ),
      );
    };

    ZPNsEventHandler.onNotificationArrived = (ZPNsMessage message) {
      ZegoCallLogger.logInfo(
        'onNotificationArrived, message:{ '
        'title: ${message.title}'
        'content: ${message.content}'
        'extras: ${message.extras}'
        'pushSourceType: ${message.pushSourceType} }',
        tag: 'call',
        subTag: 'zpns,event',
      );

      notificationArrivedEvent.add(
        ZegoZPNSMessageEvent(
          title: message.title,
          content: message.content,
          extras: message.extras,
        ),
      );
    };

    ZPNsEventHandler.onNotificationClicked = (ZPNsMessage message) {
      ZegoCallLogger.logInfo(
        'onNotificationClicked, message:{ '
        'title: ${message.title}'
        'content: ${message.content}'
        'extras: ${message.extras}'
        'pushSourceType: ${message.pushSourceType} }',
        tag: 'call',
        subTag: 'zpns,event',
      );

      notificationClickedEvent.add(
        ZegoZPNSMessageEvent(
          title: message.title,
          content: message.content,
          extras: message.extras,
        ),
      );
    };

    ZPNsEventHandler.onThroughMessageReceived = (ZPNsMessage message) {
      ZegoCallLogger.logInfo(
        'onThroughMessageReceived, message:{ '
        'title: ${message.title}'
        'content: ${message.content}'
        'extras: ${message.extras}'
        'pushSourceType: ${message.pushSourceType} }',
        tag: 'call',
        subTag: 'zpns,event',
      );

      throughMessageReceivedEvent.add(
        ZegoZPNSMessageEvent(
          title: message.title,
          content: message.content,
          extras: message.extras,
        ),
      );
    };
  }

  void unRegister() {}
}
