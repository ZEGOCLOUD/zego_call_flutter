import 'package:zego_callkit/zego_callkit.dart';

class ZegoPushCallKitDisplayData {
  UUID? displayingCallKitUUID;
  String? zimCallID;

  void clearCallData() {
    zimCallID = null;
  }

  ZegoPushCallKitDisplayData({
    this.displayingCallKitUUID,
    this.zimCallID,
  });

  @override
  String toString() {
    return 'ZegoPushCallKitDisplayData:{'
        'zim call id:$zimCallID, '
        'uuid:$displayingCallKitUUID, '
        '}';
  }
}
