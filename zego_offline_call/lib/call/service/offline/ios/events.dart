// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:zego_callkit/zego_callkit.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

// Project imports:
import 'package:zego_offline_call/call/constants.dart';
import 'package:zego_offline_call/call/protocol.dart';
import 'package:zego_offline_call/call/service/offline/ios/data.dart';
import 'package:zego_offline_call/call/service/service.dart';
import 'package:zego_offline_call/core/zim/defines.dart';
import 'package:zego_offline_call/core/zim/service.dart';
import 'package:zego_offline_call/core/zpns/defines.dart';
import 'package:zego_offline_call/core/zpns/service.dart';
import 'package:zego_offline_call/logger.dart';
import 'defines.dart';

/// [iOS] VoIP event callback
void onIncomingPushReceived(Map<dynamic, dynamic> extras, UUID uuid) async {
  ZegoCallLogger.logInfo(
    'on incoming push received: extras:$extras, uuid:$uuid',
    tag: 'call',
    subTag: 'offline, ios',
  );

  final String zimCallID = extras['call_id'] as String? ?? '';
  final payload = extras['payload'] as String? ?? '';
  final requestProtocol =
      ZegoCallInvitationSendRequestProtocol.fromJson(payload);

  ZegoCallService().offline.ios.onIncomingPushReceived(
        uuid,
        zimCallID,
        requestProtocol,
      );

  ZIMService().event.incomingInvitationCancelledEvent.stream.listen((
    ZegoZIMIncomingInvitationCancelledEvent event,
  ) {
    if (zimCallID != event.invitationID) {
      return;
    }
  });
}

class ZegoOfflineCallIOSEvent {
  bool isRegistered = false;
  ZegoOfflineCallIOSData? data;

  List<StreamSubscription<dynamic>?> subscriptions = [];

  void register({
    required ZegoOfflineCallIOSData data,
  }) {
    if (isRegistered) {
      return;
    }

    isRegistered = true;

    this.data = data;

    subscriptions.add(ZPNSService()
        .event
        .throughMessageReceivedEvent
        .stream
        .listen(onThroughMessageReceivedEvent));

    CallKitEventHandler.didReceiveIncomingPush = onIncomingPushReceived;

    CallKitEventHandler.providerDidReset = providerDidReset;
    CallKitEventHandler.providerDidBegin = providerDidBegin;
    CallKitEventHandler.didActivateAudioSession = didActivateAudioSession;
    CallKitEventHandler.didDeactivateAudioSession = didDeactivateAudioSession;
    CallKitEventHandler.timedOutPerformingAction = timedOutPerformingAction;
    CallKitEventHandler.performStartCallAction = performStartCallAction;
    CallKitEventHandler.performAnswerCallAction = performAnswerCallAction;
    CallKitEventHandler.performEndCallAction = performEndCallAction;
    CallKitEventHandler.performSetHeldCallAction = performSetHeldCallAction;
    CallKitEventHandler.performSetMutedCallAction = performSetMutedCallAction;
    CallKitEventHandler.performSetGroupCallAction = performSetGroupCallAction;
    CallKitEventHandler.performPlayDTMFCallAction = performPlayDTMFCallAction;
  }

  void unRegister() {
    if (!isRegistered) {
      return;
    }

    isRegistered = false;

    data = null;

    for (var subscription in subscriptions) {
      subscription?.cancel();
    }
  }

  void providerDidReset() {
    ZegoCallLogger.logInfo(
      'providerDidReset, ',
      tag: 'call',
      subTag: 'offline, ios',
    );
  }

  void providerDidBegin() {
    ZegoCallLogger.logInfo(
      'providerDidBegin, ',
      tag: 'call',
      subTag: 'offline, ios',
    );
  }

  void didActivateAudioSession() {
    ZegoCallLogger.logInfo(
      'didActivateAudioSession, ',
      tag: 'call',
      subTag: 'offline, ios',
    );
  }

  void didDeactivateAudioSession() {
    ZegoCallLogger.logInfo(
      'didDeactivateAudioSession, ',
      tag: 'call',
      subTag: 'offline, ios',
    );
  }

  void timedOutPerformingAction(CXAction action) {
    ZegoCallLogger.logInfo(
      'timedOutPerformingAction, '
      'action:$action, ',
      tag: 'call',
      subTag: 'offline, ios',
    );

    action.fulfill();
  }

  void performStartCallAction(CXStartCallAction action) {
    ZegoCallLogger.logInfo(
      'performStartCallAction, '
      'action:$action, '
      'handle:${action.handle}, '
      'video:${action.video}, '
      'contactIdentifier:${action.contactIdentifier}, ',
      tag: 'call',
      subTag: 'offline, ios',
    );

    action.fulfill();
  }

  void performAnswerCallAction(CXAnswerCallAction action) {
    ZegoCallLogger.logInfo(
      'performAnswerCallAction, '
      'action:$action, ',
      tag: 'call',
      subTag: 'offline, ios',
    );

    action.fulfill();

    final zimCallID = data?.displayingCallKitData?.zimCallID ?? '';
    final protocolJson = data?.displayingCallKitData?.protocol?.toJson() ?? '';

    data?.displayingCallKitData?.clearCallData();

    ZIMService().acceptInvitation(
      invitationID: zimCallID,
      extendedData: protocolJson,
    );
  }

  void performEndCallAction(CXEndCallAction action) {
    ZegoCallLogger.logInfo(
      'performEndCallAction, '
      'action:$action, '
      'displayingCallKitData:${data?.displayingCallKitData}, '
      'is in calling:${ZegoCallService().isInCall}, ',
      tag: 'call',
      subTag: 'offline, ios',
    );

    action.fulfill();

    if (ZegoCallService().isInCall) {
      if (!(ZegoCallService().context?.mounted ?? false)) {
        ZegoCallLogger.logInfo(
          'performEndCallAction, context is not mounted,',
          tag: 'uikit',
          subTag: 'dialogs',
        );
      } else {
        ZegoUIKitPrebuiltCallController().hangUp(
          ZegoCallService().context!,
        );
      }
    } else {
      final zimCallID = data?.displayingCallKitData?.zimCallID ?? '';
      final protocolJson =
          data?.displayingCallKitData?.protocol?.toJson() ?? '';

      data?.displayingCallKitData?.clearCallData();

      if (zimCallID.isNotEmpty) {
        ZIMService().refuseInvitation(
          invitationID: zimCallID,
          extendedData: protocolJson,
        );
      }
    }
  }

  void performSetHeldCallAction(CXSetHeldCallAction action) {
    ZegoCallLogger.logInfo(
      'performSetHeldCallAction, '
      'action:$action, '
      'onHold:${action.onHold}, ',
      tag: 'call',
      subTag: 'offline, ios',
    );

    action.fulfill();
  }

  void performSetMutedCallAction(CXSetMutedCallAction action) {
    ZegoCallLogger.logInfo(
      'performSetMutedCallAction, '
      'action:$action, '
      'muted:${action.muted}, ',
      tag: 'call',
      subTag: 'offline, ios',
    );

    final isMuted = action.muted;

    action.fulfill();
  }

  void performSetGroupCallAction(CXSetGroupCallAction action) {
    ZegoCallLogger.logInfo(
      'performSetGroupCallAction, '
      'action:$action, ',
      tag: 'call',
      subTag: 'offline, ios',
    );

    action.fulfill();
  }

  void performPlayDTMFCallAction(CXPlayDTMFCallAction action) {
    ZegoCallLogger.logInfo(
      'performPlayDTMFCallAction, '
      'action:$action, '
      'type:${action.type}, '
      'digits:${action.digits}, ',
      tag: 'call',
      subTag: 'offline, ios',
    );

    action.fulfill();
  }

  void onThroughMessageReceivedEvent(ZegoZPNSMessageEvent event) {
    ZegoCallLogger.logInfo(
      'onThroughMessageReceivedEvent, '
      'event:$event, ',
      tag: 'call',
      subTag: 'offline, ios',
    );

    final payload = event.extras['payload'] as String? ?? '';
    final requestProtocol =
        ZegoCallInvitationSendRequestProtocol.fromJson(payload);
  }
}
