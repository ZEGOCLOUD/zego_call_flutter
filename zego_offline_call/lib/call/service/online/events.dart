// Dart imports:
import 'dart:async';
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_callkit_incoming/plugin.dart';

// Project imports:
import 'package:zego_offline_call/call/prebuilt_call_route.dart';
import 'package:zego_offline_call/call/protocol.dart';
import 'package:zego_offline_call/call/service/offline/ios/defines.dart';
import 'package:zego_offline_call/call/service/online/data.dart';
import 'package:zego_offline_call/call/service/online/popups.dart';
import 'package:zego_offline_call/call/service/service.dart';
import 'package:zego_offline_call/core/zim/defines.dart';
import 'package:zego_offline_call/core/zim/service.dart';
import 'package:zego_offline_call/logger.dart';

class ZegoOnlineCallEvents {
  ZegoOnlineCallData? data;
  ZegoOnlineCallPopUps? popups;
  List<StreamSubscription<dynamic>?> subscriptions = [];

  bool get isAppInBackground {
    final lifecycleState = WidgetsBinding.instance.lifecycleState;
    return lifecycleState == AppLifecycleState.inactive ||
        lifecycleState == AppLifecycleState.paused;
  }

  void register({
    required ZegoOnlineCallData data,
    required ZegoOnlineCallPopUps popups,
  }) {
    this.data = data;
    this.popups = popups;

    subscriptions.add(ZIMService()
        .event
        .localInvitationSentEvent
        .stream
        .listen(_onLocalInvitationSent));
    subscriptions.add(ZIMService()
        .event
        .localInvitationCanceledEvent
        .stream
        .listen(_onLocalInvitationCanceled));
    subscriptions.add(ZIMService()
        .event
        .localInvitationRefusedEvent
        .stream
        .listen(_onLocalInvitationRefused));
    subscriptions.add(ZIMService()
        .event
        .localInvitationAcceptEvent
        .stream
        .listen(_onLocalInvitationAccept));

    subscriptions.add(ZIMService()
        .event
        .incomingInvitationReceivedEvent
        .stream
        .listen(_onIncomingInvitationReceived));
    subscriptions.add(ZIMService()
        .event
        .incomingInvitationCancelledEvent
        .stream
        .listen(_onIncomingInvitationCanceled));
    subscriptions.add(ZIMService()
        .event
        .outgoingInvitationAcceptedEvent
        .stream
        .listen(_onIncomingInvitationAccepted));
    subscriptions.add(ZIMService()
        .event
        .outgoingInvitationRejectedEvent
        .stream
        .listen(_onIncomingInvitationRejected));
    subscriptions.add(ZIMService()
        .event
        .incomingInvitationTimeoutEvent
        .stream
        .listen(_onIncomingInvitationTimeout));
    subscriptions.add(ZIMService()
        .event
        .outgoingInvitationTimeoutEvent
        .stream
        .listen(_onOutgoingInvitationTimeout));
  }

  void unRegister() {
    data = null;
    popups = null;

    for (var subscription in subscriptions) {
      subscription?.cancel();
    }
  }

  void _onOutgoingInvitationTimeout(
      ZegoZIMOutgoingInvitationTimeoutEvent event) {
    if (data?.zimCallIDOfCurrentCallRequest != event.invitationID) {
      return;
    }

    data?.clearCurrentCallRequest();
    popups?.hideCallingInviterView();
  }

  void _onIncomingInvitationTimeout(
      ZegoZIMIncomingInvitationTimeoutEvent event) {
    if (data?.zimCallIDOfCurrentCallRequest != event.invitationID) {
      return;
    }

    data?.clearCurrentCallRequest();

    popups?.hideInvitationTopSheet();
    popups?.hideInvitationByNotification();
  }

  void _onIncomingInvitationRejected(
      ZegoZIMOutgoingInvitationRejectedEvent event) {
    if (data?.zimCallIDOfCurrentCallRequest != event.invitationID) {
      return;
    }

    data?.clearCurrentCallRequest();
    popups?.hideCallingInviterView();
  }

  void _onIncomingInvitationAccepted(
      ZegoZIMOutgoingInvitationAcceptedEvent event) {
    if (data?.zimCallIDOfCurrentCallRequest != event.invitationID) {
      return;
    }

    popups?.hideCallingInviterView();

    final protocol =
        ZegoCallInvitationSendRequestProtocol.fromJson(event.extendedData);
    skipToCallPage(protocol);
  }

  void _onIncomingInvitationCanceled(
      ZegoZIMIncomingInvitationCancelledEvent event) {
    if (data?.zimCallIDOfCurrentCallRequest != event.invitationID) {
      return;
    }

    data?.clearCurrentCallRequest();

    popups?.hideInvitationTopSheet();
    popups?.hideInvitationByNotification();
  }

  void _onIncomingInvitationReceived(
      ZegoZIMIncomingInvitationReceivedEvent event) {
    ZegoCallLogger.logInfo(
      'onIncomingInvitationReceived, event:$event, ',
      tag: 'call',
      subTag: 'online',
    );

    final protocol =
        ZegoCallInvitationSendRequestProtocol.fromJson(event.extendedData);

    if (data?.zimCallIDOfCurrentCallRequest != null ||
        ZegoCallService().isInCall) {
      ZegoCallLogger.logInfo(
        'auto refuse',
        tag: 'call',
        subTag: 'online',
      );

      ZIMService().refuseInvitation(
        invitationID: event.invitationID,
        extendedData: protocol.toJson(),
      );

      return;
    }

    data?.saveCurrentCallRequest(event.invitationID, protocol);

    if (isAppInBackground) {
      popups?.showInvitationByNotification(event.invitationID, protocol);
    } else {
      popups?.showInvitationTopSheet(event.invitationID, protocol);
    }
  }

  void _onLocalInvitationSent(ZegoZIMSendInvitationResult result) {
    final protocol =
        ZegoCallInvitationSendRequestProtocol.fromJson(result.extendedData);
    data?.saveCurrentCallRequest(result.invitationID, protocol);
    popups?.showCallingInviterView(result.invitationID, protocol);
  }

  void _onLocalInvitationCanceled(ZegoZIMCancelInvitationResult result) {
    data?.clearCurrentCallRequest();
    popups?.hideCallingInviterView();
  }

  void _onLocalInvitationRefused(bool result) {
    data?.clearCurrentCallRequest();
    popups?.hideInvitationTopSheet();
  }

  void _onLocalInvitationAccept(ZegoZIMAcceptInvitationResult result) {
    ZegoCallLogger.logInfo(
      '_onLocalInvitationAccept, '
      'result:$result, ',
      tag: 'call',
      subTag: 'online',
    );

    data?.clearCurrentCallRequest();

    popups?.hideInvitationTopSheet();
    if (Platform.isAndroid) {
      ZegoCallIncomingPlugin.instance.dismissAllNotifications();
    }

    final protocol =
        ZegoCallInvitationSendRequestProtocol.fromJson(result.extendedData);
    skipToCallPage(protocol).then((_) {
      if (Platform.isIOS) {
        ZegoCallService()
            .offline
            .ios
            .hideIncomingCall(IncomingCallCloseReason.remoteCancel);
      }
    });
  }
}
