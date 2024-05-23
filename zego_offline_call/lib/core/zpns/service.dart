// Dart imports:
import 'dart:async';
import 'dart:io' as io;

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:zego_zpns/zego_zpns.dart';

// Project imports:
import 'package:zego_offline_call/core/zpns/data.dart';
import 'package:zego_offline_call/core/zpns/defines.dart';
import 'package:zego_offline_call/core/zpns/events.dart';
import 'package:zego_offline_call/logger.dart';

class ZPNSService {
  factory ZPNSService() {
    return instance;
  }

  ZPNSService._internal() {
    WidgetsFlutterBinding.ensureInitialized();
  }

  static final ZPNSService instance = ZPNSService._internal();

  final data = ZPNSData();
  final event = ZPNSEvent();

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

  Future<ZegoSignalingPluginEnableNotifyResult> enableOfflineNotify({
    ZegoSignalingPluginMultiCertificate certificateIndex =
        ZegoSignalingPluginMultiCertificate.firstCertificate,
    bool enableIOSVoIP = true,
    String androidChannelID = "",
    String androidChannelName = "",
    String androidSound = "",
  }) async {
    ZegoCallLogger.logInfo(
      'enable Notify When App Running In Background Or Quit, '
      'enable iOS VoIP:$enableIOSVoIP, '
      'certificate index:$certificateIndex, '
      'androidChannelID: $androidChannelID, '
      'androidChannelName: $androidChannelName, '
      'androidSound: $androidSound',
      tag: 'call',
      subTag: 'zpns',
    );

    if ((!io.Platform.isAndroid) && (!io.Platform.isIOS)) {
      ZegoCallLogger.logInfo(
        'Only Support Android And iOS Platform.',
        tag: 'call',
        subTag: 'zpns',
      );

      return ZegoSignalingPluginEnableNotifyResult(
        error: PlatformException(
          code: '-1',
          message: 'Only Support Android And iOS Platform.',
        ),
      );
    }

    try {
      var zpnsConfig = ZPNsConfig();
      if (io.Platform.isAndroid) {
        final notificationChannel = ZPNsNotificationChannel();
        notificationChannel.channelID = androidChannelID;
        notificationChannel.channelName = androidChannelName;
        notificationChannel.androidSound = androidSound;
        await ZPNs.getInstance().createNotificationChannel(notificationChannel);

        zpnsConfig.enableFCMPush = true;
      } else if (io.Platform.isIOS) {
        await ZPNs.getInstance().applyNotificationPermission();
      }
      zpnsConfig.appType = certificateIndex.id;
      await ZPNs.setPushConfig(zpnsConfig);

      await ZPNs.getInstance().registerPush(
        iOSEnvironment: ZPNsIOSEnvironment.Automatic,
        enableIOSVoIP: enableIOSVoIP,
      );
      ZegoCallLogger.logInfo(
        'register push done',
        tag: 'call',
        subTag: 'zpns',
      );
      return const ZegoSignalingPluginEnableNotifyResult();
    } catch (e) {
      ZegoCallLogger.logInfo(
        'register push, error:${e.toString()}',
        tag: 'call',
        subTag: 'zpns',
      );

      if (e is PlatformException) {
        return ZegoSignalingPluginEnableNotifyResult(
          error: PlatformException(
            code: e.code,
            message: e.message,
          ),
        );
      } else {
        return ZegoSignalingPluginEnableNotifyResult(
          error: PlatformException(
            code: '-2',
            message: e.toString(),
          ),
        );
      }
    }
  }
}
