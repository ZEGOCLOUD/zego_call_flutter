part of 'package:zego_offline_call/call/service/service.dart';

mixin ZegoCallServiceOnlineMixin {
  final _onlineImpl = ZegoCallServiceOnlineMixinImpl();

  ZegoCallServiceOnlineMixinImpl get online => _onlineImpl;
}

class ZegoCallServiceOnlineMixinImpl {
  final data = ZegoOnlineCallData();
  final events = ZegoOnlineCallEvents();
  final popups = ZegoOnlineCallPopUps();

  void init() {
    if (data.isInit) {
      return;
    }

    data.isInit = true;

    events.register(
      data: data,
      popups: popups,
    );
  }

  void uninit() {
    if (!data.isInit) {
      return;
    }

    data.isInit = false;

    events.unRegister();
    data.clear();
  }
}
