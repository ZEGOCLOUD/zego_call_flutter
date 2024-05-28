// Flutter imports:
import 'package:flutter/material.dart';
import 'package:zego_push/zego_push.dart';

// Package imports:
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

// Project imports:
import 'package:zego_live/app/constants.dart';
import 'package:zego_live/live/protocol.dart';
import 'package:zego_live/live/service/service.dart';
import 'package:zego_live/logger.dart';

import 'constants.dart';

Future<bool> skipToLivePage(
  ZegoLiveInvitationSendRequestProtocol protocol,
) async {
  return _skipToLivePage(protocol.liveID, false, []);
}

Future<bool> startLivePage(
  String liveID,
  List<String> followerIDList,
) async {
  return _skipToLivePage(liveID, true, followerIDList);
}

Future<bool> _skipToLivePage(
  String liveID,
  bool isHost,
  List<String> followerIDList,
) async {
  ZegoLiveService().isInLive = true;

  try {
    final currentContext = navigatorKey.currentContext;
    await Navigator.of(currentContext!)
        .push(
      MaterialPageRoute(
        builder: (context) => ZegoUIKitPrebuiltLiveStreaming(
          appID: yourSecretID,
          appSign: yourSecretAppSign,
          liveID: liveID,
          userID: currentUser.id,
          userName: currentUser.name,
          config: isHost
              ? ZegoUIKitPrebuiltLiveStreamingConfig.host()
              : ZegoUIKitPrebuiltLiveStreamingConfig.audience(),
          events: isHost
              ? ZegoUIKitPrebuiltLiveStreamingEvents(
                  onStateUpdated: (ZegoLiveStreamingState state) {
                    if (ZegoLiveStreamingState.living == state) {
                      final protocol = ZegoLiveInvitationSendRequestProtocol(
                        liveID: liveID,
                        hostID: currentUser.id,
                        hostName: currentUser.name,
                        customData: '',
                      );
                      ZegoPushService().send(
                        invitees: followerIDList,
                        timeout: 60,
                        extendedData: protocol.toJson(),

                        /// offline call
                        pushConfig: ZegoZIMPushConfig(
                          resourceID: offlineResourceID,
                          title: currentUser.name,
                          message: 'LIVE has started, join now',
                          payload: protocol.toJson(),
                        ),
                      );
                    }
                  },
                )
              : ZegoUIKitPrebuiltLiveStreamingEvents(),
        ),
      ),
    )
        .then((result) {
      ZegoLiveService().isInLive = false;

      ZegoLiveLogger.logError(
        'page dispose, result:$result, ',
        tag: 'live',
        subTag: 'skipToLivePage',
      );
    });
  } catch (e) {
    ZegoLiveService().isInLive = false;

    ZegoLiveLogger.logError(
      'Navigator push exception:$e, ',
      tag: 'live',
      subTag: 'skipToLivePage',
    );

    return false;
  }

  return true;
}
