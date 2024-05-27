// Project imports:
import 'package:zego_push/callkit/ios/data.dart';
import 'package:zego_push/callkit/ios/events.dart';

class ZegoIOSCallKitService {
  final data = ZegoIOSCallKitData();
  final event = ZegoIOSCallKitEvent();

  void init() {
    if (data.isInit) {
      return;
    }

    data.isInit = true;

    event.register();
  }

  void uninit() {
    if (!data.isInit) {
      return;
    }

    data.isInit = false;

    event.unRegister();
  }
}
