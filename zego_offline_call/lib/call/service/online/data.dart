// Project imports:
import 'package:zego_offline_call/call/protocol.dart';

class ZegoOnlineCallData {
  bool isInit = false;

  String? zimCallIDOfCurrentCallRequest;
  ZegoCallInvitationSendRequestProtocol? currentCallRequest;

  void clear() {
    zimCallIDOfCurrentCallRequest = null;
    currentCallRequest = null;
  }

  void saveCurrentCallRequest(
    String zimCallID,
    ZegoCallInvitationSendRequestProtocol protocol,
  ) {
    zimCallIDOfCurrentCallRequest = zimCallID;
    currentCallRequest = protocol;
  }

  void clearCurrentCallRequest() {
    zimCallIDOfCurrentCallRequest = null;
    currentCallRequest = null;
  }
}
