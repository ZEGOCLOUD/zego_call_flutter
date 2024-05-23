// Package imports:
import 'package:zego_callkit/zego_callkit.dart';

/// @nodoc
class ZegoCallKitIncomingPushReceivedEvent {
  Map<String, dynamic> extras;
  UUID uuid;

  ZegoCallKitIncomingPushReceivedEvent({
    required this.extras,
    required this.uuid,
  });
}

/// @nodoc
class ZegoCallKitVoidEvent {}

/// @nodoc
class ZegoCallKitActionEvent {
  CXAction action;

  ZegoCallKitActionEvent({
    required this.action,
  });
}

/// @nodoc
class ZegoCallKitSetMutedCallActionEvent {
  CXSetMutedCallAction action;

  ZegoCallKitSetMutedCallActionEvent({
    required this.action,
  });
}
