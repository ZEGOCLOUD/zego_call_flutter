// Dart imports:
import 'dart:math';

// Package imports:
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_callkit_incoming/zego_callkit_incoming.dart';
import 'package:zego_push/zego_push.dart';
import 'package:zego_zpns/zego_zpns.dart';

// Project imports:
import 'package:zego_live/app/constants.dart';
import 'package:zego_live/live/constants.dart';
import 'package:zego_live/live/protocol.dart';
import 'package:zego_live/live/service/android.utils.dart';
import 'package:zego_live/logger.dart';

/// [Android] Silent Notification event notify
///
/// Note: @pragma('vm:entry-point') must be placed on a function to indicate that it can be parsed, allocated, or called directly from native or VM code in AOT mode.
@pragma('vm:entry-point')
Future<void> onBackgroundMessageReceived(ZPNsMessage message) async {
  ZegoLiveLogger.logInfo(
    'on background message received: '
    'title:${message.title}, '
    'content:${message.content}, '
    'extras:${message.extras}, ',
    tag: 'live',
    subTag: 'offline, android',
  );

  final isZegoMessage = message.extras.keys.contains('zego');
  if (!isZegoMessage) {
    ZegoLiveLogger.logInfo(
      'is not zego protocol, drop it',
      tag: 'live',
      subTag: 'offline, android',
    );
    return;
  }

  final String zimCallID = message.extras['call_id'] as String? ?? '';
  final payload = message.extras['payload'] as String? ?? '';
  final requestProtocol =
      ZegoLiveInvitationSendRequestProtocol.fromJson(payload);

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
          title: requestProtocol.hostName,
          content: 'is living, click to join',
          acceptButtonText: '',
          rejectButtonText: '',
          clickCallback: () async {
            ZegoLiveLogger.logInfo(
              'LocalNotification, clickCallback',
              tag: 'live',
              subTag: 'offline',
            );

            /// save, lunch app and run as online call
            final prefs = await SharedPreferences.getInstance();

            prefs.setString(
              OfflineLiveCacheKey.cacheOfflineLiveZIMIDKey,
              zimCallID,
            );
            prefs.setString(
              OfflineLiveCacheKey.cacheOfflineLiveProtocolKey,
              requestProtocol.toJson(),
            );

            ZegoPushService().uninit();
          },
        ),
      );
}
