// Dart imports:
import 'dart:math';

// Package imports:
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_callkit_incoming/zego_callkit_incoming.dart';
import 'package:zego_zpns/zego_zpns.dart';

// Project imports:
import 'package:zego_offline_call/app/constants.dart';
import 'package:zego_offline_call/call/constants.dart';
import 'package:zego_offline_call/call/protocol.dart';
import 'package:zego_offline_call/call/service/android.utils.dart';
import 'package:zego_offline_call/core/zim/defines.dart';
import 'package:zego_offline_call/core/zim/service.dart';
import 'package:zego_offline_call/core/zpns/service.dart';
import 'package:zego_offline_call/logger.dart';

class ZegoOfflineCallAndroid {
  void init() {
    ZPNs.setBackgroundMessageHandler(onBackgroundMessageReceived);
  }

  void uninit() {}
}

/// [Android] Silent Notification event notify
///
/// Note: @pragma('vm:entry-point') must be placed on a function to indicate that it can be parsed, allocated, or called directly from native or VM code in AOT mode.
@pragma('vm:entry-point')
Future<void> onBackgroundMessageReceived(ZPNsMessage message) async {
  ZegoCallLogger.logInfo(
    'on background message received: '
    'title:${message.title}, '
    'content:${message.content}, '
    'extras:${message.extras}, ',
    tag: 'call',
    subTag: 'offline, android',
  );

  final isZegoMessage = message.extras.keys.contains('zego');
  if (!isZegoMessage) {
    ZegoCallLogger.logInfo(
      'is not zego protocol, drop it',
      tag: 'call',
      subTag: 'offline, android',
    );
    return;
  }

  final String zimCallID = message.extras['call_id'] as String? ?? '';

  /// todo@yoer push sdk
  /// how to custom protocol
  final payload = message.extras['payload'] as String? ?? '';
  final requestProtocol =
      ZegoCallInvitationSendRequestProtocol.fromJson(payload);

  /// for agree/reject and onCancel
  ZIMService().init(appID: yourSecretID, appSign: yourSecretAppSign);
  final prefs = await SharedPreferences.getInstance();
  final cacheUserID = prefs.get(cacheUserIDKey) as String? ?? '';
  if (cacheUserID.isNotEmpty) {
    currentUser.id = cacheUserID;
    currentUser.name = 'user_$cacheUserID';
  }
  ZIMService().event.incomingInvitationCancelledEvent.stream.listen((
    ZegoZIMIncomingInvitationCancelledEvent event,
  ) {
    if (zimCallID != event.invitationID) {
      return;
    }
    ZegoCallIncomingPlugin.instance.dismissAllNotifications();
    ZIMService().uninit();
  });
  await ZIMService().login(userID: currentUser.id, userName: currentUser.name);
  await ZPNSService().enableOfflineNotify();

  /// todo@yoer push sdk
  /// how to custom notification
  await ZegoCallIncomingPlugin.instance.addLocalCallNotification(
    ZegoLocalCallNotificationConfig(
      id: Random().nextInt(2147483647),
      channelID: androidChannelID,
      iconSource: getIconSource(androidIconName),
      soundSource: getSoundSource(androidSoundFileName),
      vibrate: true,
      title: requestProtocol.inviter.name,
      content: requestProtocol.isVideo ? 'Video Call' : 'Audio Call',
      acceptButtonText: 'Accept',
      rejectButtonText: 'Reject',
      acceptCallback: () async {
        ZegoCallLogger.logInfo(
          'LocalNotification, acceptCallback',
          tag: 'call',
          subTag: 'offline',
        );

        final prefs = await SharedPreferences.getInstance();

        /// Mark as accept.
        /// When the app is called up, if it is accepted, it will directly enter the call
        prefs.setBool(
          OfflineCallCacheKey.cacheOfflineZIMCallAcceptKey,
          true,
        );
        prefs.setString(
          OfflineCallCacheKey.cacheOfflineZIMCallIDKey,
          zimCallID,
        );
        prefs.setString(
          OfflineCallCacheKey.cacheOfflineCallProtocolKey,
          requestProtocol.toJson(),
        );

        await ZegoCallIncomingPlugin.instance.dismissAllNotifications();
        await ZegoCallIncomingPlugin.instance.activeAppToForeground();
        await ZegoCallIncomingPlugin.instance.requestDismissKeyguard();

        await ZIMService().acceptInvitation(
          invitationID: zimCallID,
          extendedData: requestProtocol.toJson(),
        );
        ZIMService().uninit();

        await ZegoCallIncomingPlugin.instance.launchCurrentApp();
      },
      rejectCallback: () async {
        ZegoCallLogger.logInfo(
          'LocalNotification, rejectCallback',
          tag: 'call',
          subTag: 'offline',
        );

        await ZegoCallIncomingPlugin.instance.dismissAllNotifications();

        await ZIMService().refuseInvitation(
          invitationID: zimCallID,
          extendedData: requestProtocol.toJson(),
        );
        ZIMService().uninit();
      },
      cancelCallback: () async {
        ZegoCallLogger.logInfo(
          'LocalNotification, cancelCallback',
          tag: 'call',
          subTag: 'offline',
        );

        await ZIMService().refuseInvitation(
          invitationID: zimCallID,
          extendedData: requestProtocol.toJson(),
        );
        ZIMService().uninit();
      },
      clickCallback: () async {
        ZegoCallLogger.logInfo(
          'LocalNotification, clickCallback',
          tag: 'call',
          subTag: 'offline',
        );

        /// save, lunch app and run as online call
        final prefs = await SharedPreferences.getInstance();

        /// Mark as not accepted.
        /// When the app is called up, run like received online call
        prefs.setBool(
          OfflineCallCacheKey.cacheOfflineZIMCallAcceptKey,
          false,
        );
        prefs.setString(
          OfflineCallCacheKey.cacheOfflineZIMCallIDKey,
          zimCallID,
        );
        prefs.setString(
          OfflineCallCacheKey.cacheOfflineCallProtocolKey,
          requestProtocol.toJson(),
        );

        await ZegoCallIncomingPlugin.instance.dismissAllNotifications();
        await ZegoCallIncomingPlugin.instance.activeAppToForeground();
        await ZegoCallIncomingPlugin.instance.requestDismissKeyguard();

        ZIMService().uninit();
      },
    ),
  );
}
