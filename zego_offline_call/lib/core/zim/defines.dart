// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:zego_zim/zego_zim.dart';

enum ZegoZIMConnectionState {
  disconnected,
  connecting,
  connected,
  reconnecting,
}

enum ZegoZIMRoomState {
  disconnected,
  connecting,
  connected,
}

enum ZegoZIMConnectionAction {
  unknown,
  success,
  activeLogin,
  loginTimeout,
  interrupted,
  kickedOut,
  tokenExpired,
  unregistered
}

enum ZegoZIMRoomAction {
  success,
  interrupted,
  disconnected,
  roomNotExist,
  activeCreate,
  createFailed,
  activeEnter,
  enterFailed,
  kickedOut,
  connectTimeout,
  kickedOutByOtherDevice
}

enum ZegoZIMInvitationMode {
  unknown,
  general,
  advanced,
}

ZegoZIMInvitationUserState userStateConvertFunc(ZIMCallUserState state) {
  switch (state) {
    case ZIMCallUserState.unknown:
      return ZegoZIMInvitationUserState.unknown;
    case ZIMCallUserState.inviting:
      return ZegoZIMInvitationUserState.inviting;
    case ZIMCallUserState.accepted:
      return ZegoZIMInvitationUserState.accepted;
    case ZIMCallUserState.rejected:
      return ZegoZIMInvitationUserState.rejected;
    case ZIMCallUserState.cancelled:
      return ZegoZIMInvitationUserState.cancelled;
    case ZIMCallUserState.offline:
      return ZegoZIMInvitationUserState.offline;
    case ZIMCallUserState.received:
      return ZegoZIMInvitationUserState.received;
    case ZIMCallUserState.timeout:
      return ZegoZIMInvitationUserState.timeout;
    case ZIMCallUserState.quited:
      return ZegoZIMInvitationUserState.quited;
    case ZIMCallUserState.ended:
      return ZegoZIMInvitationUserState.ended;
    // case ZIMCallUserState.notYetReceived:
    //   return ZegoZIMInvitationUserState.notYetReceived;
  }
}

ZegoZIMInvitationMode fromZIMInvitationMode(ZIMCallInvitationMode mode) {
  switch (mode) {
    case ZIMCallInvitationMode.unknown:
      return ZegoZIMInvitationMode.unknown;
    case ZIMCallInvitationMode.general:
      return ZegoZIMInvitationMode.general;
    case ZIMCallInvitationMode.advanced:
      return ZegoZIMInvitationMode.advanced;
  }
}

/// @nodoc
/// error event
class ZegoZIMErrorEvent {
  ZegoZIMErrorEvent({
    required this.code,
    required this.message,
  });

  final int code;
  final String message;

  @override
  String toString() => '{code: $code, message: $message}';
}

/// @nodoc
/// connection state changed event
class ZegoZIMConnectionStateChangedEvent {
  const ZegoZIMConnectionStateChangedEvent({
    required this.state,
    required this.action,
    required this.extendedData,
  });

  final ZegoZIMConnectionState state;
  final ZegoZIMConnectionAction action;
  final Map<dynamic, dynamic> extendedData;

  @override
  String toString() => '{state: $state, '
      'action: $action, '
      'extendedData: $extendedData}';
}

/// @nodoc
/// token will expire event
class ZegoZIMTokenWillExpireEvent {
  const ZegoZIMTokenWillExpireEvent({
    required this.second,
  });

  final int second;

  @override
  String toString() => '{second: $second}';
}

/// @nodoc
/// incoming invitation received event
class ZegoZIMIncomingInvitationReceivedEvent {
  const ZegoZIMIncomingInvitationReceivedEvent({
    required this.invitationID,
    required this.inviterID,
    required this.timeoutSecond,
    required this.extendedData,
    required this.mode,
    required this.createTime,
    required this.callUserList,
  });

  final String invitationID;
  final String inviterID;
  final int timeoutSecond;
  final String extendedData;
  final int createTime;
  final ZegoZIMInvitationMode mode;
  final List<ZegoZIMInvitationUserInfo> callUserList;

  @override
  String toString() => '{invitationID: $invitationID, '
      'mode:$mode, '
      'inviterID: $inviterID, '
      'timeoutSecond: $timeoutSecond, '
      'createTime:$createTime, '
      'callUserList:$callUserList, '
      'extendedData: $extendedData}';
}

/// @nodoc
/// incoming invitation canceled event
class ZegoZIMIncomingInvitationCancelledEvent {
  const ZegoZIMIncomingInvitationCancelledEvent({
    required this.invitationID,
    required this.inviterID,
    required this.extendedData,
    required this.mode,
  });

  final String invitationID;
  final String inviterID;
  final String extendedData;
  final ZegoZIMInvitationMode mode;

  @override
  String toString() => '{invitationID: $invitationID, '
      'mode:$mode, '
      'inviterID: $inviterID, '
      'extendedData: $extendedData}';
}

/// @nodoc
/// outgoing invitation accepted event
class ZegoZIMOutgoingInvitationAcceptedEvent {
  const ZegoZIMOutgoingInvitationAcceptedEvent({
    required this.invitationID,
    required this.inviteeID,
    required this.extendedData,
  });

  final String invitationID;
  final String inviteeID;
  final String extendedData;

  @override
  String toString() => '{invitationID: $invitationID, '
      'inviteeID: $inviteeID, '
      'extendedData: $extendedData}';
}

/// @nodoc
class ZegoZIMOutgoingInvitationRejectedEvent {
  const ZegoZIMOutgoingInvitationRejectedEvent({
    required this.invitationID,
    required this.inviteeID,
    required this.extendedData,
  });

  final String invitationID;
  final String inviteeID;
  final String extendedData;

  @override
  String toString() => '{invitationID: $invitationID, '
      'inviteeID: $inviteeID, '
      'extendedData: $extendedData}';
}

/// @nodoc
class ZegoZIMOutgoingInvitationEndedEvent {
  const ZegoZIMOutgoingInvitationEndedEvent({
    required this.invitationID,
    required this.callerID,
    required this.operatedUserID,
    required this.endTime,
    required this.extendedData,
    required this.mode,
  });

  final String invitationID;
  final String callerID;
  final String operatedUserID;
  final String extendedData;
  final int endTime;
  final ZegoZIMInvitationMode mode;

  @override
  String toString() => '{invitationID: $invitationID, '
      'mode:$mode, '
      'callerID: $callerID, '
      'operatedUserID: $operatedUserID, '
      'endTime: $endTime, '
      'extendedData: $extendedData}';
}

/// Call invitation user state.
enum ZegoZIMInvitationUserState {
  unknown,
  inviting,
  accepted,
  rejected,
  cancelled,
  offline,
  received,
  timeout,
  quited,
  ended,
  notYetReceived,
}

class ZegoZIMInvitationUserStateChangedEvent {
  final String invitationID;
  final List<ZegoZIMInvitationUserInfo> callUserList;

  ZegoZIMInvitationUserStateChangedEvent({
    required this.invitationID,
    required this.callUserList,
  });

  @override
  String toString() {
    return '{invitationID:$invitationID, callUserList:$callUserList}';
  }
}

/// Call invitation user information.
class ZegoZIMInvitationUserInfo {
  /// Description:  userID.
  final String userID;

  /// Description:  user status.
  final ZegoZIMInvitationUserState state;

  final String extendedData;

  ZegoZIMInvitationUserInfo({
    this.userID = '',
    this.state = ZegoZIMInvitationUserState.inviting,
    this.extendedData = '',
  });

  @override
  String toString() {
    return '{userID:$userID, state:$state, extended data:$extendedData}';
  }
}

/// @nodoc
class ZegoZIMIncomingInvitationTimeoutEvent {
  const ZegoZIMIncomingInvitationTimeoutEvent({
    required this.invitationID,
    required this.mode,
  });

  final String invitationID;
  final ZegoZIMInvitationMode mode;

  @override
  String toString() => '{invitationID: $invitationID, '
      'mode:$mode}';
}

/// @nodoc
class ZegoZIMOutgoingInvitationTimeoutEvent {
  const ZegoZIMOutgoingInvitationTimeoutEvent({
    required this.invitationID,
    required this.invitees,
  });

  final String invitationID;
  final List<String> invitees;

  @override
  String toString() => '{invitationID: $invitationID, invitees: $invitees}';
}

/// @nodoc
class ZegoZIMRoomMemberJoinedEvent {
  const ZegoZIMRoomMemberJoinedEvent({
    required this.usersID,
    required this.usersName,
    required this.roomID,
  });

  final List<String> usersID;
  final List<String> usersName;
  final String roomID;

  @override
  String toString() => '{usersID: $usersID, '
      'usersName: $usersName, '
      'roomID: $roomID}';
}

/// @nodoc
class ZegoZIMRoomMemberLeftEvent {
  const ZegoZIMRoomMemberLeftEvent({
    required this.usersID,
    required this.usersName,
    required this.roomID,
  });

  final List<String> usersID;
  final List<String> usersName;
  final String roomID;

  @override
  String toString() => '{usersID: $usersID, '
      'usersName: $usersName, '
      'roomID: $roomID}';
}

/// @nodoc
class ZegoZIMRoomStateChangedEvent {
  const ZegoZIMRoomStateChangedEvent({
    required this.roomID,
    required this.state,
    required this.action,
    required this.extendedData,
  });

  final String roomID;
  final ZegoZIMRoomState state;
  final ZegoZIMRoomAction action;
  final Map<dynamic, dynamic> extendedData;

  @override
  String toString() => '{roomID: $roomID, '
      'state: $state, '
      'action: $action, '
      'extendedData: $extendedData}';
}

/// @nodoc
class ZegoZIMRoomPropertiesUpdatedEvent {
  const ZegoZIMRoomPropertiesUpdatedEvent({
    required this.roomID,
    required this.setProperties,
    required this.deleteProperties,
  });

  final String roomID;
  final Map<String, String> setProperties;
  final Map<String, String> deleteProperties;

  @override
  String toString() => '{roomID: $roomID, '
      'setProperties: $setProperties, '
      'deleteProperties: $deleteProperties}';
}

/// @nodoc
class ZegoZIMUsersInRoomAttributesUpdatedEvent {
  const ZegoZIMUsersInRoomAttributesUpdatedEvent({
    required this.attributes,
    required this.editorID,
    required this.roomID,
  });

  // key: userID, value: attributes
  final Map<String, Map<String, String>> attributes;
  final String editorID;
  final String roomID;

  @override
  String toString() => '{attributes: $attributes, '
      'editorID: $editorID, '
      'roomID: $roomID}';
}

/// @nodoc
class ZegoZIMRoomPropertiesBatchUpdatedEvent {
  const ZegoZIMRoomPropertiesBatchUpdatedEvent({
    required this.roomID,
    required this.setProperties,
    required this.deleteProperties,
  });

  final String roomID;
  final Map<String, String> setProperties;
  final Map<String, String> deleteProperties;

  @override
  String toString() => '{roomID: $roomID, '
      'setProperties: $setProperties, '
      'deleteProperties: $deleteProperties}';
}

/// @nodoc
class ZegoZIMInRoomTextMessage {
  ZegoZIMInRoomTextMessage({
    required this.text,
    required this.senderUserID,
    required this.orderKey,
    required this.timestamp,
  });

  final String text;
  final String senderUserID;
  final int timestamp;
  final int orderKey;

  @override
  String toString() => '{text: $text, '
      'senderUserID: $senderUserID, '
      'timestamp: $timestamp, '
      'orderKey: $orderKey}';
}

/// @nodoc
class ZegoZIMInRoomTextMessageReceivedEvent {
  ZegoZIMInRoomTextMessageReceivedEvent({
    required this.messages,
    required this.roomID,
  });

  final List<ZegoZIMInRoomTextMessage> messages;
  final String roomID;

  @override
  String toString() => '{messages: $messages, '
      'roomID: $roomID}';
}

/// @nodoc
class ZegoZIMInRoomCommandMessage {
  ZegoZIMInRoomCommandMessage({
    required this.message,
    required this.senderUserID,
    required this.orderKey,
    required this.timestamp,
  });

  /// If you have a string encoded in UTF-8 and want to convert a Uint8List
  /// to that string, you can use the following method:
  ///
  /// import 'dart:convert';
  /// import 'dart:typed_data';
  ///
  /// String result = utf8.decode(commandMessage.message); // Convert the Uint8List to a string
  ///
  final Uint8List message;

  final String senderUserID;
  final int timestamp;
  final int orderKey;

  @override
  String toString() => '{message: $message, '
      'senderUserID: $senderUserID, '
      'timestamp: $timestamp, '
      'orderKey: $orderKey}';
}

/// @nodoc
class ZegoZIMInRoomCommandMessageReceivedEvent {
  ZegoZIMInRoomCommandMessageReceivedEvent({
    required this.messages,
    required this.roomID,
  });

  final List<ZegoZIMInRoomCommandMessage> messages;
  final String roomID;

  @override
  String toString() => '{messages: $messages, '
      'roomID: $roomID}';
}

extension ZIMCallUserInfoExtension on ZIMCallUserInfo {
  String toStringX() {
    return 'ZIMCallUserInfo{'
        'userID:$userID, '
        'state:$state, '
        'extendedData:$extendedData}';
  }
}

extension ZIMRoomAttributesUpdateInfoExtension on ZIMRoomAttributesUpdateInfo {
  String toStringX() {
    return 'ZIMRoomAttributesUpdateInfo{'
        'action:${action.name}, '
        'roomAttributes:$roomAttributes}';
  }
}

extension ZIMCallInvitationReceivedInfoSignalingExtension
    on ZIMCallInvitationReceivedInfo {
  String toStringX() {
    return 'ZIMCallInvitationReceivedInfo{'
        'timeout:$timeout, '
        'inviter:$inviter, '
        'caller:$caller, '
        'extendedData:$extendedData, '
        'createTime:$createTime, '
        'mode:$mode, '
        'callUserList:${callUserList.map((e) => e.toStringX()).toList()}';
  }
}

/// @nodoc
/// Description:Offline push configuration.
class ZegoZIMPushConfig {
  const ZegoZIMPushConfig({
    this.resourceID = '',
    this.title = '',
    this.message = '',
    this.payload = '',
    this.voipConfig,
  });

  final String resourceID;

  /// Description: Used to set the push title.
  final String title;

  /// Description: Used to set offline push content.
  final String message;

  /// Description: This parameter is used to set the pass-through field of offline push.
  final String payload;

  final ZegoZIMVoIPConfig? voipConfig;

  @override
  String toString() => '{'
      'title: $title, '
      'message: $message, '
      'payload: $payload, '
      'resourceID: $resourceID, '
      'voipConfig:$voipConfig'
      '}';
}

class ZegoZIMVoIPConfig {
  final bool iOSVoIPHasVideo;
  final String inviterName;

  const ZegoZIMVoIPConfig({
    this.inviterName = '',
    this.iOSVoIPHasVideo = false,
  });

  @override
  String toString() => '{'
      'inviterName: $inviterName, '
      'iOSVoIPHasVideo: $iOSVoIPHasVideo, '
      '}';
}

ZIMPushConfig? toZIMPushConfig(
  ZegoZIMPushConfig? pushConfig,
) {
  ZIMPushConfig? zimPushConfig = (pushConfig != null)
      ? (ZIMPushConfig()
        ..title = pushConfig.title
        ..content = pushConfig.message
        ..resourcesID = pushConfig.resourceID
        ..payload = pushConfig.payload)
      : null;
  if (null != pushConfig?.voipConfig) {
    zimPushConfig?.voIPConfig = ZIMVoIPConfig();
    zimPushConfig?.voIPConfig?.iOSVoIPHandleValue =
        pushConfig?.voipConfig?.inviterName ?? '';
    zimPushConfig?.voIPConfig?.iOSVoIPHasVideo =
        pushConfig?.voipConfig?.iOSVoIPHasVideo ?? false;
  }

  return zimPushConfig;
}

/// @nodoc
/// send invitation result
class ZegoZIMSendInvitationResult {
  const ZegoZIMSendInvitationResult({
    this.error,
    required this.invitationID,
    required this.extendedData,
    required this.errorInvitees,
  });

  final PlatformException? error;
  final String invitationID;
  final String extendedData;
  final Map<String, int /*reason*/ > errorInvitees;

  @override
  String toString() => '{error: $error, '
      'invitationID: $invitationID, '
      'extendedData: $extendedData, '
      'errorInvitees: $errorInvitees}';
}

/// Description:Offline push configuration for cancel invitation
class ZegoZIMIncomingInvitationCancelPushConfig {
  /// Description: Used to set the push title.
  String title;

  /// Description: Used to set offline push content.
  String content;

  /// Description: This parameter is used to set the pass-through field of offline push.
  String payload;

  final String resourcesID;

  ZegoZIMIncomingInvitationCancelPushConfig({
    this.title = '',
    this.content = '',
    this.payload = '',
    this.resourcesID = '',
  });

  @override
  String toString() {
    return 'title:$title, content:$content, payload:$payload, resourcesID:$resourcesID';
  }
}

/// @nodoc
/// cancel invitation result
class ZegoZIMCancelInvitationResult {
  const ZegoZIMCancelInvitationResult({
    this.error,
    required this.errorInvitees,
  });

  final PlatformException? error;
  final List<String> errorInvitees;

  @override
  String toString() => '{error: $error, '
      'errorInvitees: $errorInvitees}';
}

/// @nodoc
class ZegoZIMAcceptInvitationResult {
  const ZegoZIMAcceptInvitationResult({
    this.error,
    required this.invitationID,
    required this.extendedData,
  });

  final PlatformException? error;
  final String invitationID;
  final String extendedData;

  @override
  String toString() => '{error: $error, '
      'invitationID: $invitationID, '
      'extendedData: $extendedData, '
      '}';
}
