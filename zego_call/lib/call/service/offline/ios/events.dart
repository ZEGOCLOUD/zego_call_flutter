// Dart imports:
import 'dart:async';

// Package imports:
import 'package:zego_callkit/zego_callkit.dart';
import 'package:zego_push/service.dart';
import 'package:zego_push/zego_push.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

// Project imports:
import 'package:zego_call/call/protocol.dart';
import 'package:zego_call/call/service/offline/ios/data.dart';
import 'package:zego_call/call/service/service.dart';
import 'package:zego_call/logger.dart';

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

    subscriptions
      ..add(ZegoPushService()
          .zpnsEvent
          .throughMessageReceivedEvent
          .stream
          .listen(onThroughMessageReceivedEvent))
      ..add(ZegoPushService()
          .iOSCallKitEvent
          .callkitPerformAnswerCallActionEvent
          .stream
          .listen(onPerformAnswerCallAction))
      ..add(ZegoPushService()
          .iOSCallKitEvent
          .callkitPerformEndCallActionEvent
          .stream
          .listen(onPerformEndCallAction));
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

  void onPerformAnswerCallAction(ZegoIOSCallKitAnswerCallActionEvent event) {
    ZegoCallLogger.logInfo(
      'onPerformAnswerCallAction, '
      'action:${event.action}, ',
      tag: 'call',
      subTag: 'offline, ios',
    );

    final zimCallID = data?.displayingCallKitData?.zimCallID ?? '';
    final protocolJson = data?.displayingCallKitData?.protocol?.toJson() ?? '';

    data?.displayingCallKitData?.clearCallData();

    ZegoPushService().accept(
      invitationID: zimCallID,
      extendedData: protocolJson,
    );
  }

  void onPerformEndCallAction(ZegoIOSCallKitEndCallActionEvent event) {
    ZegoCallLogger.logInfo(
      'onPerformEndCallAction, '
      'action:${event.action}, '
      'displayingCallKitData:${data?.displayingCallKitData}, '
      'is in calling:${ZegoCallService().isInCall}, ',
      tag: 'call',
      subTag: 'offline, ios',
    );

    if (ZegoCallService().isInCall) {
      if (!(ZegoCallService().context?.mounted ?? false)) {
        ZegoCallLogger.logInfo(
          'onPerformEndCallAction, context is not mounted,',
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
        ZegoPushService().refuse(
          invitationID: zimCallID,
          extendedData: protocolJson,
        );
      }
    }
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
