// Dart imports:
import 'dart:async';
import 'dart:io' as io;
import 'dart:io';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:zego_callkit/zego_callkit.dart';
import 'package:zego_push/zego_push.dart';
import 'package:zego_zpns/zego_zpns.dart';

import 'package:zego_push/zim/service.dart';
import 'package:zego_push/zpns/service.dart';
import 'package:zego_push/callkit/ios/service.dart';
import 'package:zego_push/core/data.dart';
import 'package:zego_push/logger.dart';
import 'package:zego_push/core/ios.handler.dart';
import 'package:zego_push/core/callkit/android/android.dart';
import 'package:zego_push/core/callkit/ios/ios.dart';

part 'core/callkit/callkit.dart';

class ZegoPushService with ZegoPushCallKitMixin {
  factory ZegoPushService() {
    return instance;
  }

  ZegoPushService._internal() {
    WidgetsFlutterBinding.ensureInitialized();
  }

  static final ZegoPushService instance = ZegoPushService._internal();

  final _zim = ZIMService();
  final _iOSCallkit = ZegoIOSCallKitService();
  final _zpns = ZPNSService();
  final _data = ZegoPushData();

  ZegoPushData get data => _data;
  ZIMEvent get zimEvent => _zim.event;
  ZPNSEvent get zpnsEvent => _zpns.event;
  ZegoIOSCallKitEvent get iOSCallKitEvent => _iOSCallkit.event;

  void init({
    required int appID,
    required String appSign,
    required ZegoPushConfig config,
    ZegoPushEvent? event,
  }) {
    if (_data.isInit) {
      return;
    }

    _data.isInit = true;

    ZegoPushLogger().initLog();

    _data.appID = appID;
    _data.appSign = appSign;
    _data.config = config;
    _data.event = event;

    _zim.init(appID: appID, appSign: appSign);
    _zpns.init();
    _iOSCallkit.init();

    if (config.offlineConfig?.isSupport ?? false) {
      if (Platform.isAndroid &&
          null != config.offlineConfig?.android?.handler) {
        ZPNs.setBackgroundMessageHandler(
          config.offlineConfig!.android!.handler!,
        );
      } else if (Platform.isIOS && null != config.offlineConfig?.iOS?.handler) {
        var cxConfiguration = CXProviderConfiguration(
          localizedName: config.offlineConfig?.iOS?.localizedName ?? '',
          iconTemplateImageName:
              config.offlineConfig?.iOS?.iconTemplateImageName ?? '',
          supportsVideo: true,
        );
        CallKit.setInitConfiguration(cxConfiguration);

        CallKitEventHandler.didReceiveIncomingPush = onIncomingPushHandler;
      }

      _zpns.enableOfflineNotify(
        androidChannelID: config.offlineConfig?.android?.channelID ?? '',
        androidChannelName: config.offlineConfig?.android?.channelName ?? '',
      );
    }
  }

  void uninit() {
    if (!_data.isInit) {
      return;
    }

    _data.isInit = false;

    _zim.uninit();
    _zpns.uninit();
    _iOSCallkit.uninit();
  }

  Future<bool> login({
    required String userID,
    required String userName,
  }) async {
    return _zim.login(userID: userID, userName: userName);
  }

  Future<bool> logout() async {
    return _zim.logout();
  }

  Future<ZegoZIMSendInvitationResult> send({
    required List<String> invitees,
    required int timeout,
    String extendedData = '',
    ZegoZIMPushConfig? pushConfig,
  }) async {
    return _zim.sendInvitation(
      invitees: invitees,
      timeout: timeout,
      extendedData: extendedData,
      pushConfig: pushConfig,
    );
  }

  Future<ZegoZIMCancelInvitationResult> cancel({
    required String invitationID,
    required List<String> invitees,
    String extendedData = '',
    ZegoZIMIncomingInvitationCancelPushConfig? pushConfig,
  }) async {
    return _zim.cancelInvitation(
      invitationID: invitationID,
      invitees: invitees,
      extendedData: extendedData,
      pushConfig: pushConfig,
    );
  }

  Future<bool> refuse({
    required String invitationID,
    String extendedData = '',
  }) async {
    return _zim.refuseInvitation(
      invitationID: invitationID,
      extendedData: extendedData,
    );
  }

  Future<bool> accept({
    required String invitationID,
    String extendedData = '',
  }) async {
    return _zim.acceptInvitation(
      invitationID: invitationID,
      extendedData: extendedData,
    );
  }
}
