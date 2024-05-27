import 'package:zego_callkit/zego_callkit.dart';

import 'package:zego_push/logger.dart';

import 'defines.dart';
import 'data.dart';
import 'private.dart';

class ZegoPushCallKitIOS {
  final private = ZegoPushIOSMixinImplPrivate();

  UUID showIncomingCall(
    String zimCallID,
    bool isVideo,
    String handlerName,
  ) {
    ZegoPushLogger.logInfo(
      "try showIncomingCall, "
      "isVideo:$isVideo, "
      "handlerName:$handlerName, "
      "zim call id:$zimCallID, ",
      tag: 'call',
      subTag: 'offline, ios',
    );

    hideIncomingCall(IncomingCallCloseReason.timeout);

    var config = CXProviderConfiguration(
      localizedName: 'ZegoCall',
      iconTemplateImageName: 'CallKitIcon',
    );
    config.supportsVideo_ = isVideo;
    CallKit.setInitConfiguration(config);

    CXCallUpdate update = CXCallUpdate();
    update.hasVideo = isVideo;
    update.remoteHandle = CXHandle(
      type: CXHandleType.CXHandleTypeGeneric,
      value: handlerName,
    );

    UUID uuid = UUID.getUUID();

    private.saveIncomingCallKitData(uuid, zimCallID);
    ZegoPushLogger.logInfo(
      "showIncomingCall now, "
      "data:${private.callKitDisplayData}",
      tag: 'call',
      subTag: 'offline, ios',
    );

    CallKit.getInstance().reportIncomingCall(update, uuid);

    return uuid;
  }

  void hideIncomingCall(IncomingCallCloseReason reason) {
    if (private.callKitDisplayData?.displayingCallKitUUID == null) {
      ZegoPushLogger.logInfo(
        "hideIncomingCall, not exist displaying callkit",
        tag: 'call',
        subTag: 'offline, ios',
      );

      return;
    }

    var endedReason = CXCallEndedReason.CXCallEndedReasonFailed;
    switch (reason) {
      case IncomingCallCloseReason.remoteCancel:
      case IncomingCallCloseReason.remoteHangUp:
        endedReason = CXCallEndedReason.CXCallEndedReasonRemoteEnded;
        break;
      case IncomingCallCloseReason.timeout:
        endedReason = CXCallEndedReason.CXCallEndedReasonUnanswered;
        break;
    }

    ZegoPushLogger.logInfo(
      "hideIncomingCall, "
      "data:${private.callKitDisplayData}, ",
      tag: 'call',
      subTag: 'offline, ios',
    );

    CallKit.getInstance().reportCallEnded(
      endedReason,
      private.callKitDisplayData!.displayingCallKitUUID!,
    );

    private.clearIncomingCallKitSData();
  }
}
