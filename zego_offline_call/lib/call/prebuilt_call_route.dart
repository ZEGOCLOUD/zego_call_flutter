// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

// Project imports:
import 'package:zego_offline_call/app/constants.dart';
import 'package:zego_offline_call/call/protocol.dart';
import 'package:zego_offline_call/call/service/service.dart';
import 'package:zego_offline_call/logger.dart';

Future<bool> skipToCallPage(
  ZegoCallInvitationSendRequestProtocol protocol,
) async {
  ZegoCallService().isInCall = true;

  try {
    final currentContext = navigatorKey.currentContext;
    await Navigator.of(currentContext!)
        .push(
      MaterialPageRoute(
        builder: (context) => ZegoUIKitPrebuiltCall(
            appID: yourSecretID,
            appSign: yourSecretAppSign,
            callID: protocol.callID,
            userID: currentUser.id,
            userName: currentUser.name,
            config: protocol.invitees.length > 1
                ? (protocol.isVideo
                    ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
                    : ZegoUIKitPrebuiltCallConfig.groupVoiceCall())
                : (protocol.isVideo
                    ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
                    : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall())),
      ),
    )
        .then((result) {
      ZegoCallService().isInCall = false;

      ZegoCallLogger.logError(
        'page dispose, result:$result, ',
        tag: 'call',
        subTag: 'skipToCallPage',
      );
    });
  } catch (e) {
    ZegoCallService().isInCall = false;

    ZegoCallLogger.logError(
      'Navigator push exception:$e, ',
      tag: 'call',
      subTag: 'skipToCallPage',
    );

    return false;
  }

  return true;
}
