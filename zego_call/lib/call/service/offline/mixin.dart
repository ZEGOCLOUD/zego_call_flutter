part of 'package:zego_call/call/service/service.dart';

mixin ZegoCallServiceOfflineMixin {
  final _offlineImpl = ZegoCallServiceOfflineMixinImpl();

  ZegoCallServiceOfflineMixinImpl get offline => _offlineImpl;
}

class ZegoCallServiceOfflineMixinImpl {
  final data = ZegoOfflineCallData();
  final ios = ZegoOfflineCallIOS();

  void init() {
    if (data.isInit) {
      return;
    }

    data.isInit = true;

    if (Platform.isAndroid) {
    } else {
      ios.init();
    }

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

  void checkPendingCall({
    required void Function(
      String zimCallID,
      ZegoCallInvitationSendRequestProtocol protocol,
    ) onlineCallIncomingAction,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final isAccepted = prefs.getBool(
          OfflineCallCacheKey.cacheOfflineZIMCallAcceptKey,
        ) ??
        true;
    final zimCallID = prefs.getString(
          OfflineCallCacheKey.cacheOfflineCallZIMIDKey,
        ) ??
        '';
    final requestProtocolJson = prefs.getString(
          OfflineCallCacheKey.cacheOfflineCallProtocolKey,
        ) ??
        '';

    ZegoCallLogger.logInfo(
      'check offline call, '
      'zim call id:$zimCallID, '
      'request protocol:$requestProtocolJson, ',
      tag: 'call',
      subTag: 'offline',
    );

    if (zimCallID.isNotEmpty && requestProtocolJson.isNotEmpty) {
      prefs.remove(OfflineCallCacheKey.cacheOfflineZIMCallAcceptKey);
      prefs.remove(OfflineCallCacheKey.cacheOfflineCallZIMIDKey);
      prefs.remove(OfflineCallCacheKey.cacheOfflineCallProtocolKey);

      final protocol =
          ZegoCallInvitationSendRequestProtocol.fromJson(requestProtocolJson);
      if (isAccepted) {
        /// click accept button on offline notification dialog
        skipToCallPage(protocol);
      } else {
        /// click empty area on offline notification dialog, just lunch app
        /// and notify as online call
        onlineCallIncomingAction.call(zimCallID, protocol);
      }
    }
  }

  void _registerEvents() {}

  void _unRegisterEvents() {
    for (var subscription in data.subscriptions) {
      subscription?.cancel();
    }
  }
}
