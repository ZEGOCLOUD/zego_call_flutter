// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:zego_zim/zego_zim.dart';

// Project imports:
import 'package:zego_offline_call/core/zim/data.dart';
import 'package:zego_offline_call/core/zim/defines.dart';
import 'package:zego_offline_call/core/zim/events.dart';
import 'package:zego_offline_call/logger.dart';

class ZIMService {
  factory ZIMService() {
    return instance;
  }

  ZIMService._internal() {
    WidgetsFlutterBinding.ensureInitialized();
  }

  static final ZIMService instance = ZIMService._internal();

  final data = ZIMData();
  final event = ZIMEvent();

  void init({
    required int appID,
    required String appSign,
  }) {
    if (data.isInit) {
      return;
    }

    data.isInit = true;

    event.register();
    data.subscriptions.add(event.connectionStateChangedEvent.stream
        .asBroadcastStream()
        .listen(_onConnectStateChanged));

    ZIM.create(
      ZIMAppConfig()
        ..appID = appID
        ..appSign = appSign,
    );
  }

  void uninit() {
    if (!data.isInit) {
      return;
    }

    data.isInit = false;

    for (var subscription in data.subscriptions) {
      subscription?.cancel();
    }

    event.unRegister();
    ZIM.getInstance()?.destroy();
  }

  Future<bool> login({
    required String userID,
    required String userName,
  }) async {
    ZegoCallLogger.logInfo(
      'connectUser, id:$userID, name:$userName',
      tag: 'call',
      subTag: 'user',
    );

    var targetUser = ZIMUserInfo()
      ..userID = userID
      ..userName = userName;

    if (null != data.currentUser &&
        (data.currentUser!.userID.isNotEmpty &&
            data.currentUser!.userID != userID)) {
      ZegoCallLogger.logInfo(
        'login exist before, and not same, auto logout....',
        tag: 'call',
        subTag: 'user',
      );

      await logout();
    }

    ZIMLoginConfig config = ZIMLoginConfig()..userName = userName;
    return ZIM.getInstance()!.login(targetUser.userID, config).then((value) {
      ZegoCallLogger.logInfo(
        'connectUser success.',
        tag: 'call',
        subTag: 'user',
      );

      data.currentUser = targetUser;

      return true;
    }).catchError((error) {
      if (error is PlatformException &&
          int.parse(error.code) ==
              ZIMErrorCode.networkModuleUserHasAlreadyLogged &&
          data.currentUser?.userID == targetUser.userID &&
          data.currentUser?.userName == targetUser.userName) {
        ZegoCallLogger.logError(
          'connectUser, user is same who current login',
          tag: 'call',
          subTag: 'user',
        );

        return true;
      }

      ZegoCallLogger.logInfo(
        'connectUser, error:${error.toString()}',
        tag: 'call',
        subTag: 'user',
      );

      return false;
    });
  }

  Future<bool> logout() async {
    ZegoCallLogger.logInfo(
      'disconnectUser, current id:${data.currentUser?.userID}, '
      'current name:${data.currentUser?.userName}',
      tag: 'call',
      subTag: 'user',
    );

    data.currentUser = null;
    ZIM.getInstance()!.logout();

    return true;
  }

  void _onConnectStateChanged(ZegoZIMConnectionStateChangedEvent event) {
    if (event.state == ZegoZIMConnectionState.disconnected) {
      ZegoCallLogger.logInfo(
        'onConnectionStateChanged, disconnected, clear current user',
        tag: 'call',
        subTag: 'event center',
      );

      data.currentUser = null;
    }
  }

  Future<bool> renewToken(String token) async {
    ZegoCallLogger.logInfo(
      'renewToken, token:$token',
      tag: 'call',
      subTag: 'user',
    );

    return ZIM
        .getInstance()!
        .renewToken(token)
        .then((value) => true)
        .catchError((error) {
      ZegoCallLogger.logError(
        'renewToken error:${error.toString()}',
        tag: 'call',
        subTag: 'user',
      );

      return false;
    });
  }

  Future<ZegoZIMSendInvitationResult> sendInvitation({
    required List<String> invitees,
    required int timeout,
    bool isAdvancedMode = false,
    String extendedData = '',
    ZegoZIMPushConfig? pushConfig,
  }) async {
    ZegoCallLogger.logInfo(
      'send invitation, invitees:$invitees, '
      'timeout:$timeout, '
      'extendedData:$extendedData, '
      'push config:${pushConfig.toString()}',
      tag: 'call',
      subTag: 'zim',
    );

    final config = ZIMCallInviteConfig()
      ..extendedData = extendedData
      ..timeout = timeout
      ..mode = isAdvancedMode
          ? ZIMCallInvitationMode.advanced
          : ZIMCallInvitationMode.general
      ..pushConfig = toZIMPushConfig(pushConfig);

    return ZIM
        .getInstance()!
        .callInvite(invitees, config)
        .then((ZIMCallInvitationSentResult zimResult) {
      ZegoCallLogger.logInfo(
        'send invitation, done, invitation id:${zimResult.callID}, '
        'error user list:${zimResult.info.errorUserList.map((e) => '${e.userID}, reason:${e.reason}')}, '
        'error invitees:${zimResult.info.errorInvitees.map((e) => '${e.userID}, ')}',
        tag: 'call',
        subTag: 'zim',
      );

      final result = ZegoZIMSendInvitationResult(
        invitationID: zimResult.callID,
        extendedData: extendedData,
        errorInvitees: {
          for (var element in zimResult.info.errorUserList)
            element.userID: element.reason
        },
      );

      event.localInvitationSentEvent.add(result);

      return result;
    }).catchError((error) {
      ZegoCallLogger.logError(
        'send invitation, error:${error.toString()}',
        tag: 'call',
        subTag: 'zim',
      );

      final result = ZegoZIMSendInvitationResult(
        invitationID: '',
        extendedData: extendedData,
        errorInvitees: {},
        error: error,
      );

      event.localInvitationSentEvent.add(result);

      return result;
    });
  }

  /// cancel invitation
  Future<ZegoZIMCancelInvitationResult> cancelInvitation({
    required String invitationID,
    required List<String> invitees,
    String extendedData = '',
    ZegoZIMIncomingInvitationCancelPushConfig? pushConfig,
  }) async {
    ZegoCallLogger.logInfo(
      'cancel invitation, invitation id:$invitationID, invitees:$invitees, '
      'extendedData:$extendedData, pushConfig:$pushConfig',
      tag: 'call',
      subTag: 'zim',
    );

    var config = ZIMCallCancelConfig();
    config.extendedData = extendedData;
    if (null != pushConfig) {
      var zimPushConfig = ZIMPushConfig();
      zimPushConfig.title = pushConfig.title;
      zimPushConfig.content = pushConfig.content;
      zimPushConfig.payload = pushConfig.payload;
      zimPushConfig.resourcesID = pushConfig.resourcesID;

      config.pushConfig = zimPushConfig;
    }
    return ZIM
        .getInstance()!
        .callCancel(
          invitees,
          invitationID,
          config,
        )
        .then((ZIMCallCancelSentResult zimResult) {
      ZegoCallLogger.logInfo(
        'cancel invitation, done, invitation id:${zimResult.callID}, '
        'error invitees:${zimResult.errorInvitees}',
        tag: 'call',
        subTag: 'zim',
      );

      final result = ZegoZIMCancelInvitationResult(
        errorInvitees: zimResult.errorInvitees,
      );

      event.localInvitationCanceledEvent.add(result);

      return result;
    }).catchError((error) {
      ZegoCallLogger.logError(
        'cancel invitation, error:${error.toString()}',
        tag: 'call',
        subTag: 'zim',
      );

      final result = ZegoZIMCancelInvitationResult(
        errorInvitees: invitees,
        error: error,
      );

      event.localInvitationCanceledEvent.add(result);

      return result;
    });
  }

  /// refuse invitation
  Future<bool> refuseInvitation({
    required String invitationID,
    String extendedData = '',
  }) {
    ZegoCallLogger.logInfo(
      'refuse invitation, invitation id:$invitationID, extendedData:$extendedData',
      tag: 'call',
      subTag: 'zim',
    );

    return ZIM
        .getInstance()!
        .callReject(
          invitationID,
          ZIMCallRejectConfig()..extendedData = extendedData,
        )
        .then((ZIMCallRejectionSentResult zimResult) {
      ZegoCallLogger.logInfo(
        'refuse invitation, done, invitation id:${zimResult.callID}',
        tag: 'call',
        subTag: 'zim',
      );

      event.localInvitationRefusedEvent.add(true);

      return true;
    }).catchError((error) {
      ZegoCallLogger.logError(
        'refuse invitation, error:${error.toString()}',
        tag: 'call',
        subTag: 'zim',
      );

      event.localInvitationRefusedEvent.add(false);

      return false;
    });
  }

  /// accept invitation
  Future<bool> acceptInvitation({
    required String invitationID,
    String extendedData = '',
  }) {
    ZegoCallLogger.logInfo(
      'accept invitation, invitation id:$invitationID, extendedData:$extendedData',
      tag: 'call',
      subTag: 'zim',
    );

    return ZIM
        .getInstance()!
        .callAccept(
          invitationID,
          ZIMCallAcceptConfig()..extendedData = extendedData,
        )
        .then((ZIMCallAcceptanceSentResult zimResult) {
      ZegoCallLogger.logInfo(
        'accept invitation, done, invitation id:${zimResult.callID}',
        tag: 'call',
        subTag: 'zim',
      );

      event.localInvitationAcceptEvent.add(
        ZegoZIMAcceptInvitationResult(
          invitationID: invitationID,
          extendedData: extendedData,
        ),
      );

      return true;
    }).catchError((error) {
      ZegoCallLogger.logError(
        'accept invitation, error:${error.toString()}',
        tag: 'call',
        subTag: 'zim',
      );

      event.localInvitationAcceptEvent.add(
        ZegoZIMAcceptInvitationResult(
          invitationID: invitationID,
          extendedData: extendedData,
          error: error,
        ),
      );

      return false;
    });
  }
}
