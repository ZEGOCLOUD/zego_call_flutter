// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_callkit_incoming/zego_callkit_incoming.dart';
import 'package:zego_push/zego_push.dart';

// Project imports:
import 'package:zego_live/live/constants.dart';
import 'package:zego_live/live/prebuilt_live_route.dart';
import 'package:zego_live/live/protocol.dart';
import 'package:zego_live/live/service/android.utils.dart';
import 'package:zego_live/live/service/data.dart';
import 'package:zego_live/live/service/defines.dart';
import 'package:zego_live/live/service/offline/android/events.dart';
import 'package:zego_live/live/service/offline/data.dart';
import 'package:zego_live/logger.dart';

part 'package:zego_live/live/service/offline/mixin.dart';

/// 关注的直播开播，主播给粉丝发送通知，观众点击离线通知直接进入直播间
class ZegoLiveService with ZegoLiveServiceOfflineMixin {
  factory ZegoLiveService() {
    return instance;
  }

  ZegoLiveService._internal() {
    WidgetsFlutterBinding.ensureInitialized();
  }

  static final ZegoLiveService instance = ZegoLiveService._internal();

  final _data = ZegoLiveServiceData();

  bool get isInLive => _data.liveStatusNotifier.value;
  set isInLive(bool value) => _data.liveStatusNotifier.value = value;
  BuildContext? get context => _data.config?.navigatorKey.currentContext;

  void init({
    required int appID,
    required String appSign,
    required ZegoLiveServiceConfig config,
  }) {
    if (_data.isInit) {
      return;
    }

    _data.isInit = true;
    _data.config = config;

    ZegoPushService().init(
      appID: appID,
      appSign: appSign,
      config: ZegoPushConfig(
        offlineConfig: ZegoPushOfflineConfig(
          android: ZegoPushOfflineAndroidConfig(
            handler: onBackgroundMessageReceived,
          ),
        ),
      ),
    );

    offline.init();

    _data.liveStatusNotifier.addListener(_onLiveStatusChanged);
  }

  void uninit() {
    if (!_data.isInit) {
      return;
    }

    _data.isInit = false;
    _data.config = null;

    ZegoPushService().uninit();

    offline.uninit();
  }

  void login(ZegoUser user) {
    ZegoPushService().login(
      userID: user.id,
      userName: user.name,
    );
  }

  void logout() {
    ZegoPushService().logout();
  }

  void checkHasPendingOfflineLive() {
    offline.checkPendingLive(
      onlineCallIncomingAction: (
        String zimCallID,
        ZegoLiveInvitationSendRequestProtocol protocol,
      ) {},
    );
  }

  void _onLiveStatusChanged() {
    final isInLive = _data.liveStatusNotifier.value;

    ZegoLiveLogger.logInfo(
      "_onLiveStatusChanged, "
      "isInLive:$isInLive, ",
      tag: 'live',
      subTag: 'service',
    );
  }
}
