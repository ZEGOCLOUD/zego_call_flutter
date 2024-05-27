import 'package:zego_callkit/zego_callkit.dart';

import 'package:zego_push/service.dart';
import 'package:zego_push/zim/defines.dart';
import 'package:zego_push/logger.dart';

import 'callkit/ios/defines.dart';

void onIncomingPushHandler(Map<dynamic, dynamic> extras, UUID uuid) async {
  ZegoPushLogger.logInfo(
    'on incoming push received: extras:$extras, uuid:$uuid',
    tag: 'call',
    subTag: 'offline, ios',
  );

  final String zimCallID = extras['call_id'] as String? ?? '';
  final payload = extras['payload'] as String? ?? '';

  /// cache data
  ZegoPushService()
      .callkit
      .iOS
      .hideIncomingCall(IncomingCallCloseReason.timeout);
  ZegoPushService()
      .callkit
      .iOS
      .private
      .saveIncomingCallKitData(uuid, zimCallID);

  /// listen cancel notify
  ZegoPushService().zimEvent.incomingInvitationCancelledEvent.stream.listen((
    ZegoZIMIncomingInvitationCancelledEvent event,
  ) {
    if (zimCallID != event.invitationID) {
      return;
    }
  });

  /// Callback
  ZegoPushService()
      .data
      .config
      ?.offlineConfig
      ?.iOS
      ?.handler
      ?.call(zimCallID, payload, extras);
}
