// Package imports:
import 'package:zego_callkit/zego_callkit.dart';

// Project imports:
import 'package:zego_call/call/protocol.dart';

class ZegoOfflineCallIOSData {
  ZegoOfflineCallIOSCallKitDisplayData? displayingCallKitData;
}

class ZegoOfflineCallIOSCallKitDisplayData {
  String? zimCallID;
  ZegoCallInvitationSendRequestProtocol? protocol;

  void clearCallData() {
    zimCallID = null;
    protocol = null;
  }

  ZegoOfflineCallIOSCallKitDisplayData({
    this.zimCallID,
    this.protocol,
  });

  @override
  String toString() {
    return 'ZegoOfflineCallIOSCallKitDisplayData:{'
        'zim call id:$zimCallID, '
        'protocol:$protocol, '
        '}';
  }
}
