// Package imports:
import 'package:zego_callkit/zego_callkit.dart';

/// @nodoc
class ZegoIOSCallKitIncomingPushReceivedEvent {
  Map<String, dynamic> extras;
  UUID uuid;

  ZegoIOSCallKitIncomingPushReceivedEvent({
    required this.extras,
    required this.uuid,
  });
}

/// @nodoc
class ZegoIOSCallKitVoidEvent {}

/// @nodoc
class ZegoIOSCallKitActionEvent {
  CXAction action;

  ZegoIOSCallKitActionEvent({
    required this.action,
  });
}

class ZegoIOSCallKitStartCallActionEvent {
  CXStartCallAction action;

  ZegoIOSCallKitStartCallActionEvent({
    required this.action,
  });
}

class ZegoIOSCallKitAnswerCallActionEvent {
  CXAnswerCallAction action;

  ZegoIOSCallKitAnswerCallActionEvent({
    required this.action,
  });
}

class ZegoIOSCallKitEndCallActionEvent {
  CXEndCallAction action;

  ZegoIOSCallKitEndCallActionEvent({
    required this.action,
  });
}

class ZegoIOSCallKitSetHeldCallActionEvent {
  CXSetHeldCallAction action;

  ZegoIOSCallKitSetHeldCallActionEvent({
    required this.action,
  });
}

/// @nodoc
class ZegoIOSCallKitSetMutedCallActionEvent {
  CXSetMutedCallAction action;

  ZegoIOSCallKitSetMutedCallActionEvent({
    required this.action,
  });
}

class ZegoIOSSetGroupCallActionEvent {
  CXSetGroupCallAction action;

  ZegoIOSSetGroupCallActionEvent({
    required this.action,
  });
}

class ZegoIOSPlayDTMFCallActionEvent {
  CXPlayDTMFCallAction action;

  ZegoIOSPlayDTMFCallActionEvent({
    required this.action,
  });
}
