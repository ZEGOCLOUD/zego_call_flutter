part of 'package:zego_live/live/service/service.dart';

mixin ZegoLiveServiceOfflineMixin {
  final _offlineImpl = ZegoLiveServiceOfflineMixinImpl();

  ZegoLiveServiceOfflineMixinImpl get offline => _offlineImpl;
}

class ZegoLiveServiceOfflineMixinImpl {
  final data = ZegoOfflineLiveData();

  void init() {
    if (data.isInit) {
      return;
    }

    data.isInit = true;

    if (Platform.isAndroid) {}

    _registerEvents();

    Permission.notification.request();
    Permission.systemAlertWindow.request();
    ZegoPushService().callkit.android.createNotificationChannel(
          ZegoLocalNotificationChannelConfig(
            channelID: androidChannelID,
            channelName: androidChannelName,
            vibrate: true,
            soundSource: getSoundSource(androidSoundFileName),
          ),
        );
  }

  void uninit() {
    if (!data.isInit) {
      return;
    }

    data.isInit = false;

    _unRegisterEvents();
  }

  void checkPendingLive({
    required void Function(
      String zimCallID,
      ZegoLiveInvitationSendRequestProtocol protocol,
    ) onlineCallIncomingAction,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final zimCallID = prefs.getString(
          OfflineLiveCacheKey.cacheOfflineLiveZIMIDKey,
        ) ??
        '';
    final requestProtocolJson = prefs.getString(
          OfflineLiveCacheKey.cacheOfflineLiveProtocolKey,
        ) ??
        '';

    ZegoLiveLogger.logInfo(
      'check offline call, '
      'zim call id:$zimCallID, '
      'request protocol:$requestProtocolJson, ',
      tag: 'live',
      subTag: 'offline',
    );

    if (zimCallID.isNotEmpty && requestProtocolJson.isNotEmpty) {
      prefs.remove(OfflineLiveCacheKey.cacheOfflineLiveZIMIDKey);
      prefs.remove(OfflineLiveCacheKey.cacheOfflineLiveProtocolKey);

      final protocol =
          ZegoLiveInvitationSendRequestProtocol.fromJson(requestProtocolJson);
      skipToLivePage(protocol);
    }
  }

  void _registerEvents() {}

  void _unRegisterEvents() {
    for (var subscription in data.subscriptions) {
      subscription?.cancel();
    }
  }
}
