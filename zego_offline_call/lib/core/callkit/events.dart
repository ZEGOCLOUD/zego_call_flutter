// Dart imports:
import 'dart:async';

// Package imports:
import 'package:zego_callkit/zego_callkit.dart';

// Project imports:
import 'package:zego_offline_call/core/callkit/defines.dart';
import 'package:zego_offline_call/logger.dart';

class ZegoCallKitEvent {
  /// Called when the provider has been reset. Delegates must respond to this callback by cleaning up all internal call state (disconnecting communication channels, releasing network resources, etc.). This callback can be treated as a request to end all calls without the need to respond to any actions
  final callkitProviderDidResetEvent =
      StreamController<ZegoCallKitVoidEvent>.broadcast();

  /// Called when the provider has been fully created and is ready to send actions and receive updates
  final callkitProviderDidBeginEvent =
      StreamController<ZegoCallKitVoidEvent>.broadcast();

  /// Called when the provider's audio session activation state changes.
  final callkitActivateAudioEvent =
      StreamController<ZegoCallKitVoidEvent>.broadcast();
  final callkitDeactivateAudioEvent =
      StreamController<ZegoCallKitVoidEvent>.broadcast();

  /// Called when an action was not performed in time and has been inherently failed. Depending on the action, this timeout may also force the call to end. An action that has already timed out should not be fulfilled or failed by the provider delegate
  final callkitTimedOutPerformingActionEvent =
      StreamController<ZegoCallKitActionEvent>.broadcast();

  /// each perform*CallAction method is called sequentially for each action in the transaction
  final callkitPerformStartCallActionEvent =
      StreamController<ZegoCallKitActionEvent>.broadcast();
  final callkitPerformAnswerCallActionEvent =
      StreamController<ZegoCallKitActionEvent>.broadcast();
  final callkitPerformEndCallActionEvent =
      StreamController<ZegoCallKitActionEvent>.broadcast();
  final callkitPerformSetHeldCallActionEvent =
      StreamController<ZegoCallKitActionEvent>.broadcast();
  final callkitPerformSetMutedCallActionEvent =
      StreamController<ZegoCallKitSetMutedCallActionEvent>.broadcast();
  final callkitPerformSetGroupCallActionEvent =
      StreamController<ZegoCallKitActionEvent>.broadcast();
  final callkitPerformPlayDTMFCallActionEvent =
      StreamController<ZegoCallKitActionEvent>.broadcast();

  void register() {
    CallKitEventHandler.providerDidReset = () {
      ZegoCallLogger.logInfo(
        'providerDidReset',
        tag: 'call',
        subTag: 'callkit,event',
      );

      callkitProviderDidResetEvent.add(ZegoCallKitVoidEvent());
    };
    CallKitEventHandler.providerDidBegin = () {
      ZegoCallLogger.logInfo(
        'providerDidBegin',
        tag: 'call',
        subTag: 'callkit,event',
      );

      callkitProviderDidBeginEvent.add(ZegoCallKitVoidEvent());
    };
    CallKitEventHandler.didActivateAudioSession = () {
      ZegoCallLogger.logInfo(
        'didActivateAudioSession',
        tag: 'call',
        subTag: 'callkit,event',
      );

      callkitActivateAudioEvent.add(ZegoCallKitVoidEvent());
    };
    CallKitEventHandler.didDeactivateAudioSession = () {
      ZegoCallLogger.logInfo(
        'didDeactivateAudioSession',
        tag: 'call',
        subTag: 'callkit,event',
      );

      callkitDeactivateAudioEvent.add(ZegoCallKitVoidEvent());
    };
    CallKitEventHandler.timedOutPerformingAction = (CXAction action) {
      ZegoCallLogger.logInfo(
        'timedOutPerformingAction',
        tag: 'call',
        subTag: 'callkit,event',
      );

      callkitTimedOutPerformingActionEvent
          .add(ZegoCallKitActionEvent(action: action));
    };
    CallKitEventHandler.performStartCallAction = (CXAction action) {
      ZegoCallLogger.logInfo(
        'performStartCallAction',
        tag: 'call',
        subTag: 'callkit,event',
      );

      callkitPerformStartCallActionEvent
          .add(ZegoCallKitActionEvent(action: action));
    };
    CallKitEventHandler.performAnswerCallAction = (CXAction action) {
      ZegoCallLogger.logInfo(
        'performAnswerCallAction',
        tag: 'call',
        subTag: 'callkit,event',
      );

      callkitPerformAnswerCallActionEvent
          .add(ZegoCallKitActionEvent(action: action));
    };
    CallKitEventHandler.performEndCallAction = (CXAction action) {
      ZegoCallLogger.logInfo(
        'performEndCallAction',
        tag: 'call',
        subTag: 'callkit,event',
      );

      callkitPerformEndCallActionEvent
          .add(ZegoCallKitActionEvent(action: action));
    };
    CallKitEventHandler.performSetHeldCallAction = (CXAction action) {
      ZegoCallLogger.logInfo(
        'performSetHeldCallAction',
        tag: 'call',
        subTag: 'callkit,event',
      );

      callkitPerformSetHeldCallActionEvent
          .add(ZegoCallKitActionEvent(action: action));
    };
    CallKitEventHandler.performSetMutedCallAction =
        (CXSetMutedCallAction action) {
      ZegoCallLogger.logInfo(
        'performSetMutedCallAction',
        tag: 'call',
        subTag: 'callkit,event',
      );

      callkitPerformSetMutedCallActionEvent
          .add(ZegoCallKitSetMutedCallActionEvent(action: action));
    };
    CallKitEventHandler.performSetGroupCallAction = (CXAction action) {
      ZegoCallLogger.logInfo(
        'performSetGroupCallAction',
        tag: 'call',
        subTag: 'callkit,event',
      );

      callkitPerformSetGroupCallActionEvent
          .add(ZegoCallKitActionEvent(action: action));
    };
    CallKitEventHandler.performPlayDTMFCallAction = (CXAction action) {
      ZegoCallLogger.logInfo(
        'performPlayDTMFCallAction',
        tag: 'call',
        subTag: 'callkit,event',
      );

      callkitPerformPlayDTMFCallActionEvent
          .add(ZegoCallKitActionEvent(action: action));
    };
  }

  void unRegister() {}
}
