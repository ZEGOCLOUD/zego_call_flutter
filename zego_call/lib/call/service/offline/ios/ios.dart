// Package imports:
import 'package:zego_callkit/zego_callkit.dart';
import 'package:zego_push/zego_push.dart';

// Project imports:
import 'package:zego_call/call/protocol.dart';
import 'package:zego_call/call/service/offline/ios/data.dart';
import 'package:zego_call/call/service/offline/ios/events.dart';
import 'package:zego_call/logger.dart';

class ZegoOfflineCallIOS {
  final _event = ZegoOfflineCallIOSEvent();
  final _data = ZegoOfflineCallIOSData();

  void init() {
    _event.register(data: _data);
  }

  void uninit() {
    _event.unRegister();
  }

  void onIncomingPushReceived(
    String zimCallID,
    String payload,
    Map extras,
  ) {
    final protocol = ZegoCallInvitationSendRequestProtocol.fromJson(payload);

    _data.displayingCallKitData = ZegoOfflineCallIOSCallKitDisplayData(
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
}
