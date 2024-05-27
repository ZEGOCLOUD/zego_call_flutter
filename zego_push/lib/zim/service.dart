// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:zego_zim/zego_zim.dart';

// Project imports:
import 'package:zego_push/zim/data.dart';
import 'package:zego_push/zim/defines.dart';
import 'package:zego_push/zim/events.dart';
import 'package:zego_push/logger.dart';

class ZIMService {
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
    ZegoPushLogger.logInfo(
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
      ZegoPushLogger.logInfo(
        'login exist before, and not same, auto logout....',
        tag: 'call',
        subTag: 'user',
      );

      await logout();
    }

    ZIMLoginConfig config = ZIMLoginConfig()..userName = userName;
    return ZIM.getInstance()!.login(targetUser.userID, config).then((value) {
      ZegoPushLogger.logInfo(
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
        ZegoPushLogger.logError(
          'connectUser, user is same who current login',
          tag: 'call',
          subTag: 'user',
        );

        return true;
      }

      ZegoPushLogger.logInfo(
        'connectUser, error:${error.toString()}',
        tag: 'call',
        subTag: 'user',
      );

      return false;
    });
  }

  Future<bool> logout() async {
    ZegoPushLogger.logInfo(
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
      ZegoPushLogger.logInfo(
        'onConnectionStateChanged, disconnected, clear current user',
        tag: 'call',
        subTag: 'event center',
      );

      data.currentUser = null;
    }
  }

  Future<bool> renewToken(String token) async {
    ZegoPushLogger.logInfo(
      'renewToken, token:$token',
      tag: 'call',
      subTag: 'user',
    );

    return ZIM
        .getInstance()!
        .renewToken(token)
        .then((value) => true)
        .catchError((error) {
      ZegoPushLogger.logError(
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
    String extendedData = '',
    ZegoZIMPushConfig? pushConfig,
  }) async {
    ZegoPushLogger.logInfo(
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
      ..pushConfig = toZIMPushConfig(pushConfig);

    return ZIM
        .getInstance()!
        .callInvite(invitees, config)
        .then((ZIMCallInvitationSentResult zimResult) {
      ZegoPushLogger.logInfo(
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
      ZegoPushLogger.logError(
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
    ZegoPushLogger.logInfo(
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
      ZegoPushLogger.logInfo(
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
      ZegoPushLogger.logError(
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
  }) async {
    ZegoPushLogger.logInfo(
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
      ZegoPushLogger.logInfo(
        'refuse invitation, done, invitation id:${zimResult.callID}',
        tag: 'call',
        subTag: 'zim',
      );

      event.localInvitationRefusedEvent.add(true);

      return true;
    }).catchError((error) {
      ZegoPushLogger.logError(
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
  }) async {
    ZegoPushLogger.logInfo(
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
      ZegoPushLogger.logInfo(
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
      ZegoPushLogger.logError(
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
