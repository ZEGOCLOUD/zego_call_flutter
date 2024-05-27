// Dart imports:
import 'dart:async';

// Package imports:
import 'package:zego_zim/zego_zim.dart';

// Project imports:
import 'package:zego_push/zim/defines.dart';
import 'package:zego_push/logger.dart';

class ZIMEvent {
  ZIMConnectionState connectionState = ZIMConnectionState.disconnected;

  /// local event

  final localInvitationSentEvent =
      StreamController<ZegoZIMSendInvitationResult>.broadcast();
  final localInvitationCanceledEvent =
      StreamController<ZegoZIMCancelInvitationResult>.broadcast();
  final localInvitationRefusedEvent = StreamController<bool>.broadcast();
  final localInvitationAcceptEvent =
      StreamController<ZegoZIMAcceptInvitationResult>.broadcast();

  // base
  final connectionStateChangedEvent =
      StreamController<ZegoZIMConnectionStateChangedEvent>.broadcast();
  final tokenWillExpireEvent =
      StreamController<ZegoZIMTokenWillExpireEvent>.broadcast();
  final errorEvent = StreamController<ZegoZIMErrorEvent>.broadcast();

  // invitation
  final userStateChangedEvent =
      StreamController<ZegoZIMInvitationUserStateChangedEvent>.broadcast();
  final incomingInvitationReceivedEvent =
      StreamController<ZegoZIMIncomingInvitationReceivedEvent>.broadcast();
  final incomingInvitationCancelledEvent =
      StreamController<ZegoZIMIncomingInvitationCancelledEvent>.broadcast();
  final outgoingInvitationAcceptedEvent =
      StreamController<ZegoZIMOutgoingInvitationAcceptedEvent>.broadcast();
  final outgoingInvitationRejectedEvent =
      StreamController<ZegoZIMOutgoingInvitationRejectedEvent>.broadcast();
  final outgoingInvitationEndedEvent =
      StreamController<ZegoZIMOutgoingInvitationEndedEvent>.broadcast();
  final incomingInvitationTimeoutEvent =
      StreamController<ZegoZIMIncomingInvitationTimeoutEvent>.broadcast();
  final outgoingInvitationTimeoutEvent =
      StreamController<ZegoZIMOutgoingInvitationTimeoutEvent>.broadcast();

  // room
  ZIMRoomState roomState = ZIMRoomState.disconnected;
  final roomMemberJoinedEvent =
      StreamController<ZegoZIMRoomMemberJoinedEvent>.broadcast();
  final roomMemberLeftEvent =
      StreamController<ZegoZIMRoomMemberLeftEvent>.broadcast();
  final roomStateChangedEvent =
      StreamController<ZegoZIMRoomStateChangedEvent>.broadcast();
  final roomPropertiesUpdatedEvent =
      StreamController<ZegoZIMRoomPropertiesUpdatedEvent>.broadcast();
  final roomPropertiesBatchUpdatedEvent =
      StreamController<ZegoZIMRoomPropertiesBatchUpdatedEvent>.broadcast();
  final usersInRoomAttributesUpdatedEvent =
      StreamController<ZegoZIMUsersInRoomAttributesUpdatedEvent>.broadcast();

  // message
  final inRoomTextMessageReceived =
      StreamController<ZegoZIMInRoomTextMessageReceivedEvent>.broadcast();
  final inRoomCommandMessageReceived =
      StreamController<ZegoZIMInRoomCommandMessageReceivedEvent>.broadcast();

  void register() {
    _registerBase();
    _registerRoomEvent();
    _registerInvitationEvent();
  }

  void _registerBase() {
    ZIMEventHandler.onError = (
      ZIM zim,
      ZIMError errorInfo,
    ) {
      ZegoPushLogger.logInfo(
        'onError, errorInfo:$errorInfo',
        tag: 'call',
        subTag: 'zim,event',
      );

      errorEvent.add(
        ZegoZIMErrorEvent(
          code: errorInfo.code,
          message: errorInfo.message,
        ),
      );
    };
    ZIMEventHandler.onConnectionStateChanged = (
      ZIM zim,
      ZIMConnectionState state,
      ZIMConnectionEvent event,
      Map extendedData,
    ) {
      ZegoPushLogger.logInfo(
        'onConnectionStateChanged, state:$state, event:$event, extendedData:$extendedData',
        tag: 'call',
        subTag: 'zim,event',
      );

      connectionState = state;
      connectionStateChangedEvent.add(
        ZegoZIMConnectionStateChangedEvent(
          state: ZegoZIMConnectionState.values[state.index],
          action: ZegoZIMConnectionAction.values[event.index],
          extendedData: extendedData,
        ),
      );
    };

    ZIMEventHandler.onTokenWillExpire = (
      ZIM zim,
      int second,
    ) {
      ZegoPushLogger.logInfo(
        'onTokenWillExpire, second:$second',
        tag: 'call',
        subTag: 'zim,event',
      );

      tokenWillExpireEvent.add(ZegoZIMTokenWillExpireEvent(second: second));
    };
  }

  void _registerInvitationEvent() {
    ZIMEventHandler.onCallInvitationReceived = (
      ZIM zim,
      ZIMCallInvitationReceivedInfo info,
      String invitationID,
    ) {
      ZegoPushLogger.logInfo(
        'onCallInvitationReceived, invitationID:$invitationID, '
        'info:${info.toStringX()} ',
        tag: 'call',
        subTag: 'zim,event',
      );
      incomingInvitationReceivedEvent.add(
        ZegoZIMIncomingInvitationReceivedEvent(
          invitationID: invitationID,
          mode: fromZIMInvitationMode(info.mode),
          inviterID: info.inviter,
          timeoutSecond: info.timeout,
          extendedData: info.extendedData,
          createTime: info.createTime,
          callUserList: info.callUserList
              .map((userInfo) => ZegoZIMInvitationUserInfo(
                    userID: userInfo.userID,
                    state: userStateConvertFunc(userInfo.state),
                    extendedData: userInfo.extendedData,
                  ))
              .toList(),
        ),
      );
    };

    ZIMEventHandler.onCallInvitationCancelled = (
      ZIM zim,
      ZIMCallInvitationCancelledInfo info,
      String invitationID,
    ) {
      ZegoPushLogger.logInfo(
        'onCallInvitationCancelled, info:$info, invitationID:$invitationID',
        tag: 'call',
        subTag: 'zim,event',
      );

      incomingInvitationCancelledEvent.add(
        ZegoZIMIncomingInvitationCancelledEvent(
          invitationID: invitationID,
          mode: fromZIMInvitationMode(info.mode),
          inviterID: info.inviter,
          extendedData: info.extendedData,
        ),
      );
    };
    ZIMEventHandler.onCallInvitationAccepted = (
      ZIM zim,
      ZIMCallInvitationAcceptedInfo info,
      String invitationID,
    ) {
      ZegoPushLogger.logInfo(
        'onCallInvitationAccepted, info:$info, invitationID:$invitationID',
        tag: 'call',
        subTag: 'zim,event',
      );

      outgoingInvitationAcceptedEvent.add(
        ZegoZIMOutgoingInvitationAcceptedEvent(
          invitationID: invitationID,
          inviteeID: info.invitee,
          extendedData: info.extendedData,
        ),
      );
    };
    ZIMEventHandler.onCallInvitationRejected = (
      ZIM zim,
      ZIMCallInvitationRejectedInfo info,
      String invitationID,
    ) {
      ZegoPushLogger.logInfo(
        'onCallInvitationRejected, info:$info, invitationID:$invitationID',
        tag: 'call',
        subTag: 'zim,event',
      );

      outgoingInvitationRejectedEvent.add(
        ZegoZIMOutgoingInvitationRejectedEvent(
          invitationID: invitationID,
          inviteeID: info.invitee,
          extendedData: info.extendedData,
        ),
      );
    };
    ZIMEventHandler.onCallInvitationEnded = (
      ZIM zim,
      ZIMCallInvitationEndedInfo info,
      String invitationID,
    ) {
      ZegoPushLogger.logInfo(
        'onCallInvitationEnded, info:{'
        '${info.mode}'
        '}, invitationID:$invitationID',
        tag: 'call',
        subTag: 'zim,event',
      );

      outgoingInvitationEndedEvent.add(
        ZegoZIMOutgoingInvitationEndedEvent(
          invitationID: invitationID,
          mode: fromZIMInvitationMode(info.mode),
          callerID: info.caller,
          operatedUserID: info.operatedUserID,
          endTime: info.endTime,
          extendedData: info.extendedData,
        ),
      );
    };
    ZIMEventHandler.onCallUserStateChanged = (
      ZIM zim,
      ZIMCallUserStateChangeInfo info,
      String invitationID,
    ) {
      ZegoPushLogger.logInfo(
        'onCallUserStateChanged, '
        'callUserList:${info.callUserList.map((userInfo) => '{userID:${userInfo.userID}, state:${userInfo.state}, extendedData:${userInfo.extendedData}}')},'
        'invitationID:$invitationID',
        tag: 'call',
        subTag: 'zim,event',
      );

      userStateChangedEvent.add(
        ZegoZIMInvitationUserStateChangedEvent(
          invitationID: invitationID,
          callUserList: info.callUserList
              .map((userInfo) => ZegoZIMInvitationUserInfo(
                    userID: userInfo.userID,
                    state: userStateConvertFunc(userInfo.state),
                    extendedData: userInfo.extendedData,
                  ))
              .toList(),
        ),
      );
    };
    ZIMEventHandler.onCallInvitationTimeout = (
      ZIM zim,
      ZIMCallInvitationTimeoutInfo info,
      String invitationID,
    ) {
      ZegoPushLogger.logInfo(
        'onCallInvitationTimeout, mode:${info.mode}, invitationID:$invitationID',
        tag: 'call',
        subTag: 'zim,event',
      );

      incomingInvitationTimeoutEvent.add(
        ZegoZIMIncomingInvitationTimeoutEvent(
          invitationID: invitationID,
          mode: fromZIMInvitationMode(info.mode),
        ),
      );
    };
    ZIMEventHandler.onCallInviteesAnsweredTimeout = (
      ZIM zim,
      List<String> invitees,
      String invitationID,
    ) {
      ZegoPushLogger.logInfo(
        'onCallInviteesAnsweredTimeout, invitees:$invitees, invitationID:$invitationID',
        tag: 'call',
        subTag: 'zim,event',
      );

      outgoingInvitationTimeoutEvent.add(
        ZegoZIMOutgoingInvitationTimeoutEvent(
          invitationID: invitationID,
          invitees: invitees,
        ),
      );
    };
  }

  void _registerRoomEvent() {
    ZIMEventHandler.onRoomMemberJoined = (
      ZIM zim,
      List<ZIMUserInfo> memberList,
      String roomID,
    ) {
      ZegoPushLogger.logInfo(
        'onRoomMemberJoined, memberList:$memberList, roomID:$roomID',
        tag: 'call',
        subTag: 'zim,event',
      );

      roomMemberJoinedEvent.add(
        ZegoZIMRoomMemberJoinedEvent(
          roomID: roomID,
          usersID: memberList.map((e) => e.userID).toList(),
          usersName: memberList.map((e) => e.userName).toList(),
        ),
      );
    };
    ZIMEventHandler.onRoomMemberLeft = (
      ZIM zim,
      List<ZIMUserInfo> memberList,
      String roomID,
    ) {
      ZegoPushLogger.logInfo(
        'onRoomMemberLeft, memberList:$memberList, roomID:$roomID',
        tag: 'call',
        subTag: 'zim,event',
      );

      roomMemberLeftEvent.add(
        ZegoZIMRoomMemberLeftEvent(
          roomID: roomID,
          usersID: memberList.map((e) => e.userID).toList(),
          usersName: memberList.map((e) => e.userName).toList(),
        ),
      );
    };
    ZIMEventHandler.onRoomStateChanged = (
      ZIM zim,
      ZIMRoomState state,
      ZIMRoomEvent event,
      Map extendedData,
      String roomID,
    ) {
      ZegoPushLogger.logInfo(
        'onRoomStateChanged, state:$state, event:$event, extendedData:$extendedData, roomID:$roomID',
        tag: 'call',
        subTag: 'zim,event',
      );

      roomState = state;
      roomStateChangedEvent.add(
        ZegoZIMRoomStateChangedEvent(
          roomID: roomID,
          state: ZegoZIMRoomState.values[state.index],
          action: ZegoZIMRoomAction.values[event.index],
          extendedData: extendedData,
        ),
      );
    };
    ZIMEventHandler.onRoomAttributesUpdated = (
      ZIM zim,
      ZIMRoomAttributesUpdateInfo updateInfo,
      String roomID,
    ) {
      ZegoPushLogger.logInfo(
        'onRoomAttributesUpdated, updateInfo:${updateInfo.toStringX()}, roomID:$roomID',
        tag: 'call',
        subTag: 'zim,event',
      );

      roomPropertiesUpdatedEvent.add(
        ZegoZIMRoomPropertiesUpdatedEvent(
          roomID: roomID,
          setProperties: ZIMRoomAttributesUpdateAction.set == updateInfo.action
              ? updateInfo.roomAttributes
              : {},
          deleteProperties:
              ZIMRoomAttributesUpdateAction.delete == updateInfo.action
                  ? updateInfo.roomAttributes
                  : {},
        ),
      );
    };
    ZIMEventHandler.onRoomAttributesBatchUpdated = (
      ZIM zim,
      List<ZIMRoomAttributesUpdateInfo> updateInfo,
      String roomID,
    ) {
      ZegoPushLogger.logInfo(
        'onRoomAttributesBatchUpdated, updateInfo:$updateInfo, roomID:$roomID',
        tag: 'call',
        subTag: 'zim,event',
      );

      roomPropertiesBatchUpdatedEvent.add(
        ZegoZIMRoomPropertiesBatchUpdatedEvent(
          roomID: roomID,
          setProperties: updateInfo
              .where((element) =>
                  ZIMRoomAttributesUpdateAction.set == element.action)
              .map((e) => e.roomAttributes)
              .fold({}, (value, element) => value..addAll(element)),
          deleteProperties: updateInfo
              .where((element) =>
                  ZIMRoomAttributesUpdateAction.delete == element.action)
              .map((e) => e.roomAttributes)
              .fold({}, (value, element) => value..addAll(element)),
        ),
      );
    };
    ZIMEventHandler.onRoomMemberAttributesUpdated = (
      ZIM zim,
      List<ZIMRoomMemberAttributesUpdateInfo> infos,
      ZIMRoomOperatedInfo operatedInfo,
      String roomID,
    ) {
      ZegoPushLogger.logInfo(
        'onRoomMemberAttributesUpdated, infos:$infos, operatedInfo:$operatedInfo, roomID:$roomID',
        tag: 'call',
        subTag: 'zim,event',
      );

      usersInRoomAttributesUpdatedEvent.add(
        ZegoZIMUsersInRoomAttributesUpdatedEvent(
          roomID: roomID,
          editorID: operatedInfo.userID,
          attributes: {
            for (var element in infos)
              element.attributesInfo.userID: element.attributesInfo.attributes
          },
        ),
      );
    };
    ZIMEventHandler.onReceiveRoomMessage = (
      ZIM zim,
      List<ZIMMessage> messageList,
      String fromRoomID,
    ) {
      ZegoPushLogger.logInfo(
        'onReceiveRoomMessage, messageList:$messageList, fromRoomID:$fromRoomID',
        tag: 'call',
        subTag: 'zim,event',
      );

      List<ZegoZIMInRoomTextMessage> textMessages = [];
      List<ZegoZIMInRoomCommandMessage> commandMessages = [];
      for (var message in messageList) {
        if (message is ZIMTextMessage) {
          textMessages.add(ZegoZIMInRoomTextMessage(
            orderKey: message.orderKey,
            senderUserID: message.senderUserID,
            text: message.message,
            timestamp: message.timestamp,
          ));
        } else if (message is ZIMCommandMessage) {
          commandMessages.add(ZegoZIMInRoomCommandMessage(
            orderKey: message.orderKey,
            senderUserID: message.senderUserID,
            message: message.message,
            timestamp: message.timestamp,
          ));
        } else {
          ZegoPushLogger.logError(
            'onReceiveRoomMessage, message type(${message.type}) is not support',
            tag: 'call',
            subTag: 'zim,event',
          );
        }
      }
      if (textMessages.isNotEmpty) {
        inRoomTextMessageReceived.add(
          ZegoZIMInRoomTextMessageReceivedEvent(
            messages: textMessages,
            roomID: fromRoomID,
          ),
        );
      }
      if (commandMessages.isNotEmpty) {
        inRoomCommandMessageReceived.add(
          ZegoZIMInRoomCommandMessageReceivedEvent(
            messages: commandMessages,
            roomID: fromRoomID,
          ),
        );
      }
    };
  }

  void unRegister() {}
}
