// Flutter imports:
import 'package:flutter/cupertino.dart';

// Project imports:
import 'package:zego_offline_call/core/callkit/data.dart';
import 'package:zego_offline_call/core/callkit/events.dart';

class ZegoCallKitService {
  factory ZegoCallKitService() {
    return instance;
  }

  ZegoCallKitService._internal() {
    WidgetsFlutterBinding.ensureInitialized();
  }

  static final ZegoCallKitService instance = ZegoCallKitService._internal();

  final data = ZegoCallKitData();
  final event = ZegoCallKitEvent();

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
