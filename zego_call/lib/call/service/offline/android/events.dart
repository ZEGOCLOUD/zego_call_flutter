// Dart imports:
import 'dart:math';

// Package imports:
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_callkit_incoming/zego_callkit_incoming.dart';
import 'package:zego_push/zego_push.dart';
import 'package:zego_zpns/zego_zpns.dart';

// Project imports:
import 'package:zego_call/app/constants.dart';
import 'package:zego_call/call/constants.dart';
import 'package:zego_call/call/protocol.dart';
import 'package:zego_call/call/service/android.utils.dart';
import 'package:zego_call/logger.dart';

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
  final payload = message.extras['payload'] as String? ?? '';
  final requestProtocol =
      ZegoCallInvitationSendRequestProtocol.fromJson(payload);

  /// for agree/reject and onCancel
  ZegoPushService().init(
    appID: yourSecretID,
    appSign: yourSecretAppSign,
    config: ZegoPushConfig(
      offlineConfig: ZegoPushOfflineConfig(
        android: ZegoPushOfflineAndroidConfig(
          handler: onBackgroundMessageReceived,
        ),
      ),
    ),
  );

  ZegoPushService().zimEvent.incomingInvitationCancelledEvent.stream.listen((
    ZegoZIMIncomingInvitationCancelledEvent event,
  ) {
    if (zimCallID != event.invitationID) {
      return;
    }
    ZegoPushService().callkit.android.dismissAllNotifications();
    ZegoPushService().uninit();
  });

  final prefs = await SharedPreferences.getInstance();
  final cacheUserID = prefs.get(cacheUserIDKey) as String? ?? '';
  if (cacheUserID.isNotEmpty) {
    currentUser.id = cacheUserID;
    currentUser.name = 'user_$cacheUserID';
  }
  await ZegoPushService().login(
    userID: currentUser.id,
    userName: currentUser.name,
  );

  await ZegoPushService().callkit.android.addLocalCallNotification(
        ZegoPushCallKitCallNotificationConfig(
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

            await ZegoPushService().accept(
              invitationID: zimCallID,
              extendedData: requestProtocol.toJson(),
            );
            ZegoPushService().uninit();
          },
          rejectCallback: () async {
            ZegoCallLogger.logInfo(
              'LocalNotification, rejectCallback',
              tag: 'call',
              subTag: 'offline',
            );

            await ZegoPushService().refuse(
              invitationID: zimCallID,
              extendedData: requestProtocol.toJson(),
            );
            ZegoPushService().uninit();
          },
          cancelCallback: () async {
            ZegoCallLogger.logInfo(
              'LocalNotification, cancelCallback',
              tag: 'call',
              subTag: 'offline',
            );

            await ZegoPushService().refuse(
              invitationID: zimCallID,
              extendedData: requestProtocol.toJson(),
            );
            ZegoPushService().uninit();
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

            ZegoPushService().uninit();
          },
        ),
      );
}
