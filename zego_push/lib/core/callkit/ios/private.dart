import 'package:zego_callkit/zego_callkit.dart';

import 'package:zego_push/logger.dart';

import 'data.dart';

class ZegoPushIOSMixinImplPrivate {
  ZegoPushCallKitDisplayData? callKitDisplayData;

  void saveIncomingCallKitData(
    UUID uuid,
    String zimCallID,
  ) {
    callKitDisplayData ??= ZegoPushCallKitDisplayData(
      displayingCallKitUUID: uuid,
      zimCallID: zimCallID,
    );

    ZegoPushLogger.logInfo(
      "saveIncomingCallKitData, "
      "data:$callKitDisplayData",
      tag: 'call',
      subTag: 'offline, ios',
    );
  }

  void clearIncomingCallKitSData() {
    ZegoPushLogger.logInfo(
      "clearIncomingCallKitSData, "
      "data:$callKitDisplayData",
      tag: 'call',
      subTag: 'offline, ios',
    );

    callKitDisplayData = null;
  }
}
