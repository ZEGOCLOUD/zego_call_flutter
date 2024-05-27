// Dart imports:
import 'dart:async';
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_callkit_incoming/plugin.dart';
import 'package:zego_push/zego_push.dart';

// Project imports:
import 'package:zego_call/call/prebuilt_call_route.dart';
import 'package:zego_call/call/protocol.dart';
import 'package:zego_call/call/service/online/data.dart';
import 'package:zego_call/call/service/online/popups.dart';
import 'package:zego_call/call/service/service.dart';
import 'package:zego_call/logger.dart';

class ZegoOnlineCallEvents {
  ZegoOnlineCallData? data;
  ZegoOnlineCallPopUps? popups;
  List<StreamSubscription<dynamic>?> subscriptions = [];

  ZIMEvent get zimEvent => ZegoPushService().zimEvent;

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

    subscriptions.add(zimEvent.localInvitationSentEvent.stream
        .listen(_onLocalInvitationSent));
    subscriptions.add(zimEvent.localInvitationCanceledEvent.stream
        .listen(_onLocalInvitationCanceled));
    subscriptions.add(zimEvent.localInvitationRefusedEvent.stream
        .listen(_onLocalInvitationRefused));
    subscriptions.add(zimEvent.localInvitationAcceptEvent.stream
        .listen(_onLocalInvitationAccept));

    subscriptions.add(zimEvent.incomingInvitationReceivedEvent.stream
        .listen(_onIncomingInvitationReceived));
    subscriptions.add(zimEvent.incomingInvitationCancelledEvent.stream
        .listen(_onIncomingInvitationCanceled));
    subscriptions.add(zimEvent.outgoingInvitationAcceptedEvent.stream
        .listen(_onIncomingInvitationAccepted));
    subscriptions.add(zimEvent.outgoingInvitationRejectedEvent.stream
        .listen(_onIncomingInvitationRejected));
    subscriptions.add(zimEvent.incomingInvitationTimeoutEvent.stream
        .listen(_onIncomingInvitationTimeout));
    subscriptions.add(zimEvent.outgoingInvitationTimeoutEvent.stream
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

      ZegoPushService().refuse(
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
      ZegoPushService().callkit.android.dismissAllNotifications();
    }

    final protocol =
        ZegoCallInvitationSendRequestProtocol.fromJson(result.extendedData);
    skipToCallPage(protocol).then((_) {
      if (Platform.isIOS) {
        ZegoPushService()
            .callkit
            .iOS
            .hideIncomingCall(IncomingCallCloseReason.remoteCancel);
      }
    });
  }
}
