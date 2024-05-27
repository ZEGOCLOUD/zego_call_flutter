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
import 'package:zego_call/call/constants.dart';
import 'package:zego_call/call/prebuilt_call_route.dart';
import 'package:zego_call/call/protocol.dart';
import 'package:zego_call/call/service/android.utils.dart';
import 'package:zego_call/call/service/data.dart';
import 'package:zego_call/call/service/defines.dart';
import 'package:zego_call/call/service/offline/android/events.dart';
import 'package:zego_call/call/service/offline/data.dart';
import 'package:zego_call/call/service/offline/ios/events.dart';
import 'package:zego_call/call/service/offline/ios/ios.dart';
import 'package:zego_call/call/service/online/data.dart';
import 'package:zego_call/call/service/online/events.dart';
import 'package:zego_call/call/service/online/popups.dart';
import 'package:zego_call/logger.dart';

part 'package:zego_call/call/service/online/mixin.dart';
part 'package:zego_call/call/service/offline/mixin.dart';

class ZegoCallService
    with ZegoCallServiceOnlineMixin, ZegoCallServiceOfflineMixin {
  factory ZegoCallService() {
    return instance;
  }

  ZegoCallService._internal() {
    WidgetsFlutterBinding.ensureInitialized();
  }

  static final ZegoCallService instance = ZegoCallService._internal();

  final _data = ZegoCallServiceData();

  bool get isInCall => _data.callStatusNotifier.value;
  set isInCall(bool value) => _data.callStatusNotifier.value = value;
  BuildContext? get context => _data.config?.navigatorKey.currentContext;

  void init({
    required int appID,
    required String appSign,
    required ZegoCallServiceConfig config,
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
          iOS: ZegoPushOfflineIOSConfig(
            handler: offline.ios.onIncomingPushReceived,
            localizedName: 'ZegoCall',
            iconTemplateImageName: 'CallKitIcon',
          ),
        ),
      ),
    );

    online.init();
    offline.init();

    _data.callStatusNotifier.addListener(_onCallStatusChanged);
  }

  void uninit() {
    if (!_data.isInit) {
      return;
    }

    _data.isInit = false;
    _data.config = null;

    ZegoPushService().uninit();

    online.uninit();
    offline.uninit();
  }

  void login(ZegoUser user) {
    online.init();

    ZegoPushService().login(
      userID: user.id,
      userName: user.name,
    );
  }

  void logout() {
    online.uninit();

    ZegoPushService().logout();
  }

  void checkHasPendingOfflineCall() {
    offline.checkPendingCall(
      onlineCallIncomingAction: (
        String zimCallID,
        ZegoCallInvitationSendRequestProtocol protocol,
      ) {
        online.data.saveCurrentCallRequest(zimCallID, protocol);
        online.popups.showInvitationTopSheet(zimCallID, protocol);
      },
    );
  }

  void _onCallStatusChanged() {
    final isCalling = _data.callStatusNotifier.value;

    ZegoCallLogger.logInfo(
      "_onCallStatusChanged, "
      "isCalling:$isCalling, ",
      tag: 'call',
      subTag: 'service',
    );
  }
}
