// Package imports:
import 'package:zego_zpns/zego_zpns.dart';

// Project imports:
import 'package:zego_offline_call/call/service/offline/android/events.dart';

class ZegoOfflineCallAndroid {
  void init() {
    ZPNs.setBackgroundMessageHandler(onBackgroundMessageReceived);
  }

  void uninit() {}
}
