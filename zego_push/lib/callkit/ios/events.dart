// Dart imports:
import 'dart:async';

// Package imports:
import 'package:zego_callkit/zego_callkit.dart';
// Project imports:
import 'package:zego_push/callkit/ios/defines.dart';
import 'package:zego_push/logger.dart';

class ZegoIOSCallKitEvent {
  /// Called when the provider has been reset. Delegates must respond to this callback by cleaning up all internal call state (disconnecting communication channels, releasing network resources, etc.). This callback can be treated as a request to end all calls without the need to respond to any actions
  final callkitProviderDidResetEvent =
      StreamController<ZegoIOSCallKitVoidEvent>.broadcast();

  /// Called when the provider has been fully created and is ready to send actions and receive updates
  final callkitProviderDidBeginEvent =
      StreamController<ZegoIOSCallKitVoidEvent>.broadcast();

  /// Called when the provider's audio session activation state changes.
  final callkitActivateAudioEvent =
      StreamController<ZegoIOSCallKitVoidEvent>.broadcast();
  final callkitDeactivateAudioEvent =
      StreamController<ZegoIOSCallKitVoidEvent>.broadcast();

  /// Called when an action was not performed in time and has been inherently failed. Depending on the action, this timeout may also force the call to end. An action that has already timed out should not be fulfilled or failed by the provider delegate
  final callkitTimedOutPerformingActionEvent =
      StreamController<ZegoIOSCallKitActionEvent>.broadcast();

  /// each perform*CallAction method is called sequentially for each action in the transaction
  final callkitPerformStartCallActionEvent =
      StreamController<ZegoIOSCallKitStartCallActionEvent>.broadcast();
  final callkitPerformAnswerCallActionEvent =
      StreamController<ZegoIOSCallKitAnswerCallActionEvent>.broadcast();
  final callkitPerformEndCallActionEvent =
      StreamController<ZegoIOSCallKitEndCallActionEvent>.broadcast();
  final callkitPerformSetHeldCallActionEvent =
      StreamController<ZegoIOSCallKitSetHeldCallActionEvent>.broadcast();
  final callkitPerformSetMutedCallActionEvent =
      StreamController<ZegoIOSCallKitSetMutedCallActionEvent>.broadcast();
  final callkitPerformSetGroupCallActionEvent =
      StreamController<ZegoIOSSetGroupCallActionEvent>.broadcast();
  final callkitPerformPlayDTMFCallActionEvent =
      StreamController<ZegoIOSPlayDTMFCallActionEvent>.broadcast();

  void register() {
    CallKitEventHandler.providerDidReset = () {
      ZegoPushLogger.logInfo(
        'providerDidReset',
        tag: 'call',
        subTag: 'callkit,event',
      );

      callkitProviderDidResetEvent.add(ZegoIOSCallKitVoidEvent());
    };
    CallKitEventHandler.providerDidBegin = () {
      ZegoPushLogger.logInfo(
        'providerDidBegin',
        tag: 'call',
        subTag: 'callkit,event',
      );

      callkitProviderDidBeginEvent.add(ZegoIOSCallKitVoidEvent());
    };
    CallKitEventHandler.didActivateAudioSession = () {
      ZegoPushLogger.logInfo(
        'didActivateAudioSession',
        tag: 'call',
        subTag: 'callkit,event',
      );

      callkitActivateAudioEvent.add(ZegoIOSCallKitVoidEvent());
    };
    CallKitEventHandler.didDeactivateAudioSession = () {
      ZegoPushLogger.logInfo(
        'didDeactivateAudioSession',
        tag: 'call',
        subTag: 'callkit,event',
      );

      callkitDeactivateAudioEvent.add(ZegoIOSCallKitVoidEvent());
    };
    CallKitEventHandler.timedOutPerformingAction = (CXAction action) {
      ZegoPushLogger.logInfo(
        'timedOutPerformingAction',
        tag: 'call',
        subTag: 'callkit,event',
      );

      action.fulfill();

      callkitTimedOutPerformingActionEvent
          .add(ZegoIOSCallKitActionEvent(action: action));
    };
    CallKitEventHandler.performStartCallAction = (CXStartCallAction action) {
      ZegoPushLogger.logInfo(
        'performStartCallAction',
        tag: 'call',
        subTag: 'callkit,event',
      );

      action.fulfill();

      callkitPerformStartCallActionEvent
          .add(ZegoIOSCallKitStartCallActionEvent(action: action));
    };
    CallKitEventHandler.performAnswerCallAction = (CXAnswerCallAction action) {
      ZegoPushLogger.logInfo(
        'performAnswerCallAction',
        tag: 'call',
        subTag: 'callkit,event',
      );

      action.fulfill();

      callkitPerformAnswerCallActionEvent
          .add(ZegoIOSCallKitAnswerCallActionEvent(action: action));
    };
    CallKitEventHandler.performEndCallAction = (CXEndCallAction action) {
      ZegoPushLogger.logInfo(
        'performEndCallAction',
        tag: 'call',
        subTag: 'callkit,event',
      );

      action.fulfill();

      callkitPerformEndCallActionEvent
          .add(ZegoIOSCallKitEndCallActionEvent(action: action));
    };
    CallKitEventHandler.performSetHeldCallAction =
        (CXSetHeldCallAction action) {
      ZegoPushLogger.logInfo(
        'performSetHeldCallAction',
        tag: 'call',
        subTag: 'callkit,event',
      );

      action.fulfill();

      callkitPerformSetHeldCallActionEvent
          .add(ZegoIOSCallKitSetHeldCallActionEvent(action: action));
    };
    CallKitEventHandler.performSetMutedCallAction =
        (CXSetMutedCallAction action) {
      ZegoPushLogger.logInfo(
        'performSetMutedCallAction',
        tag: 'call',
        subTag: 'callkit,event',
      );

      action.fulfill();

      callkitPerformSetMutedCallActionEvent
          .add(ZegoIOSCallKitSetMutedCallActionEvent(action: action));
    };
    CallKitEventHandler.performSetGroupCallAction =
        (CXSetGroupCallAction action) {
      ZegoPushLogger.logInfo(
        'performSetGroupCallAction',
        tag: 'call',
        subTag: 'callkit,event',
      );

      action.fulfill();

      callkitPerformSetGroupCallActionEvent
          .add(ZegoIOSSetGroupCallActionEvent(action: action));
    };
    CallKitEventHandler.performPlayDTMFCallAction =
        (CXPlayDTMFCallAction action) {
      ZegoPushLogger.logInfo(
        'performPlayDTMFCallAction',
        tag: 'call',
        subTag: 'callkit,event',
      );

      action.fulfill();

      callkitPerformPlayDTMFCallActionEvent
          .add(ZegoIOSPlayDTMFCallActionEvent(action: action));
    };
  }

  void unRegister() {}
}
