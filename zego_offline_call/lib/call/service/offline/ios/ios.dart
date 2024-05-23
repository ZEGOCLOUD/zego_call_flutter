// Package imports:
import 'package:zego_callkit/zego_callkit.dart';

// Project imports:
import 'package:zego_offline_call/call/protocol.dart';
import 'package:zego_offline_call/call/service/offline/ios/data.dart';
import 'package:zego_offline_call/call/service/offline/ios/defines.dart';
import 'package:zego_offline_call/call/service/offline/ios/events.dart';
import 'package:zego_offline_call/logger.dart';

class ZegoOfflineCallIOS {
  final _event = ZegoOfflineCallIOSEvent();
  final _data = ZegoOfflineCallIOSData();

  void init() {
    var cxConfiguration = CXProviderConfiguration(
      localizedName: 'ZegoCall',
      iconTemplateImageName: 'CallKitIcon',
      supportsVideo: true,
    );
    CallKit.setInitConfiguration(cxConfiguration);

    _event.register(data: _data);
  }

  void uninit() {
    _event.unRegister();
  }

  void onIncomingPushReceived(
    UUID uuid,
    String zimCallID,
    ZegoCallInvitationSendRequestProtocol protocol,
  ) {
    hideIncomingCall(IncomingCallCloseReason.timeout);

    _data.displayingCallKitData = ZegoOfflineCallIOSCallKitDisplayData(
      displayingCallKitUUID: uuid,
      zimCallID: zimCallID,
      protocol: protocol,
    );
    ZegoCallLogger.logInfo(
      "onIncomingPushReceived, "
      "data:${_data.displayingCallKitData}",
      tag: 'call',
      subTag: 'offline, ios',
    );
  }

  UUID showIncomingCall(
    String zimCallID,
    ZegoCallInvitationSendRequestProtocol protocol,
  ) {
    ZegoCallLogger.logInfo(
      "try showIncomingCall, "
      "zim call id:$zimCallID, "
      "protocol:$protocol, ",
      tag: 'call',
      subTag: 'offline, ios',
    );

    hideIncomingCall(IncomingCallCloseReason.timeout);

    var config = CXProviderConfiguration(
      localizedName: 'ZegoCall',
      iconTemplateImageName: 'CallKitIcon',
    );
    config.supportsVideo_ = protocol.isVideo;
    CallKit.setInitConfiguration(config);

    CXCallUpdate update = CXCallUpdate();
    update.hasVideo = protocol.isVideo;
    update.remoteHandle = CXHandle(
      type: CXHandleType.CXHandleTypeGeneric,
      value: protocol.inviter.name,
    );

    UUID uuid = UUID.getUUID();

    _data.displayingCallKitData = ZegoOfflineCallIOSCallKitDisplayData(
      displayingCallKitUUID: uuid,
      zimCallID: zimCallID,
      protocol: protocol,
    );
    ZegoCallLogger.logInfo(
      "showIncomingCall now, "
      "data:${_data.displayingCallKitData}",
      tag: 'call',
      subTag: 'offline, ios',
    );

    CallKit.getInstance().reportIncomingCall(update, uuid);

    return uuid;
  }

  void hideIncomingCall(IncomingCallCloseReason reason) {
    if (_data.displayingCallKitData?.displayingCallKitUUID == null) {
      ZegoCallLogger.logInfo(
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

    ZegoCallLogger.logInfo(
      "hideIncomingCall, "
      "data:${_data.displayingCallKitData}, ",
      tag: 'call',
      subTag: 'offline, ios',
    );

    CallKit.getInstance().reportCallEnded(
      endedReason,
      _data.displayingCallKitData!.displayingCallKitUUID!,
    );

    _data.displayingCallKitData = null;
  }
}
