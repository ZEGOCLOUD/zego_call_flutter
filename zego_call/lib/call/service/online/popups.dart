// Dart imports:
import 'dart:io';
import 'dart:math';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_callkit_incoming/defines.dart';
import 'package:zego_callkit_incoming/plugin.dart';
import 'package:zego_push/zego_push.dart';

// Project imports:
import 'package:zego_call/call/components/calling_page.dart';
import 'package:zego_call/call/components/online_invitation_notify.dart';
import 'package:zego_call/call/constants.dart';
import 'package:zego_call/call/protocol.dart';
import 'package:zego_call/call/service/android.utils.dart';
import 'package:zego_call/call/service/service.dart';
import 'package:zego_call/logger.dart';

class ZegoOnlineCallPopUps {
  bool invitationTopSheetVisibility = false;
  bool callingInviterViewVisibility = false;

  void showInvitationByNotification(
    String zimCallID,
    ZegoCallInvitationSendRequestProtocol protocol,
  ) {
    ZegoCallLogger.logInfo(
      'showInvitationByNotification',
      tag: 'call',
      subTag: 'online',
    );

    if (Platform.isAndroid) {
      ZegoPushService().callkit.android.addLocalCallNotification(
            ZegoPushCallKitCallNotificationConfig(
              channelID: androidChannelID,
              iconSource: getIconSource(androidIconName),
              soundSource: getSoundSource(androidSoundFileName),
              vibrate: true,
              title: protocol.inviter.name,
              content: protocol.isVideo ? 'Video Call' : 'Audio Call',
              acceptButtonText: 'Accept',
              rejectButtonText: 'Reject',
              acceptCallback: () async {
                ZegoCallLogger.logInfo(
                  'android notification, acceptCallback',
                  tag: 'call',
                  subTag: 'online',
                );

                await ZegoPushService().accept(
                  invitationID: zimCallID,
                  extendedData: protocol.toJson(),
                );
              },
              rejectCallback: () async {
                ZegoCallLogger.logInfo(
                  'android notification, rejectCallback',
                  tag: 'call',
                  subTag: 'online',
                );

                await ZegoPushService().refuse(
                  invitationID: zimCallID,
                  extendedData: protocol.toJson(),
                );
              },
              cancelCallback: () async {
                ZegoCallLogger.logInfo(
                  'android notification, cancelCallback',
                  tag: 'call',
                  subTag: 'online',
                );

                await ZegoPushService().refuse(
                  invitationID: zimCallID,
                  extendedData: protocol.toJson(),
                );
              },
              clickCallback: () async {
                ZegoCallLogger.logInfo(
                  'android notification, clickCallback',
                  tag: 'call',
                  subTag: 'online',
                );

                /// show as online notification
                showInvitationTopSheet(zimCallID, protocol);
              },
            ),
          );
    } else {
      if (kDebugMode) {
        ZegoCallLogger.logInfo(
          'showIncomingCall in debug mode',
          tag: 'call',
          subTag: 'online',
        );

        /// only need in debug mode
        /// if in release mode, voip call will be received if app in background
        // ZegoCallService().offline.ios.showIncomingCall(zimCallID, protocol);
      }
    }
  }

  void hideInvitationByNotification() async {
    ZegoCallLogger.logInfo(
      'hideInvitationByNotification',
      tag: 'call',
      subTag: 'online',
    );

    if (Platform.isAndroid) {
      await ZegoPushService().callkit.android.dismissAllNotifications();
    } else {
      ZegoPushService()
          .callkit
          .iOS
          .hideIncomingCall(IncomingCallCloseReason.remoteCancel);
    }
  }

  void showInvitationTopSheet(
    String zimCallID,
    ZegoCallInvitationSendRequestProtocol protocol,
  ) {
    if (invitationTopSheetVisibility) {
      return;
    }

    invitationTopSheetVisibility = true;
    _showTopModalDialog(
      ZegoCallService().context,
      ZegoOnlineInvitationNotify(
        zimCallID: zimCallID,
        protocol: protocol,
      ),
    );
  }

  void hideInvitationTopSheet() {
    if (invitationTopSheetVisibility) {
      try {
        if (!(ZegoCallService().context?.mounted ?? false)) {
          ZegoCallLogger.logInfo(
            'hide invitation top sheet error, context is not mounted,',
            tag: 'uikit',
            subTag: 'dialogs',
          );
        } else {
          Navigator.of(ZegoCallService().context!).pop();
        }
      } catch (e) {
        ZegoCallLogger.logError(
          'Navigator pop exception:$e, ',
          tag: 'call',
          subTag: 'page manager',
        );
      }

      invitationTopSheetVisibility = false;
    }
  }

  void showCallingInviterView(
    String zimCallID,
    ZegoCallInvitationSendRequestProtocol protocol,
  ) {
    hideCallingInviterView();

    callingInviterViewVisibility = true;

    try {
      if (!(ZegoCallService().context?.mounted ?? false)) {
        ZegoCallLogger.logInfo(
          'show calling inviter view, context is not mounted,',
          tag: 'uikit',
          subTag: 'dialogs',
        );
      } else {
        Navigator.of(ZegoCallService().context!).push(MaterialPageRoute(
          builder: (context) => ZegoCallingPage(
            zimCallID: zimCallID,
            inviter: protocol.inviter,
            invitees: protocol.invitees,
            isVideo: protocol.isVideo,
          ),
        ));
      }
    } catch (e) {
      callingInviterViewVisibility = false;

      ZegoCallLogger.logError(
        'Navigator push exception:$e, ',
        tag: 'call',
        subTag: 'machine',
      );
    }
  }

  void hideCallingInviterView() {
    if (!callingInviterViewVisibility) {
      return;
    }

    callingInviterViewVisibility = false;
    try {
      if (!(ZegoCallService().context?.mounted ?? false)) {
        ZegoCallLogger.logInfo(
          'hide calling inviter view, context is not mounted,',
          tag: 'uikit',
          subTag: 'dialogs',
        );
      } else {
        Navigator.of(ZegoCallService().context!).pop();
      }
    } catch (e) {
      ZegoCallLogger.logError(
        'Navigator pop exception:$e, ',
        tag: 'call',
        subTag: 'machine',
      );
    }
  }

  Future<bool> _showTopModalDialog<T>(
    BuildContext? context,
    Widget widget, {
    bool barrierDismissible = true,
  }) async {
    if (!(context?.mounted ?? false)) {
      ZegoCallLogger.logInfo(
        'show top model dialog error, context is not mounted, '
        'context:$context, ',
        tag: 'uikit',
        subTag: 'dialogs',
      );

      return false;
    }

    bool result = false;

    try {
      result = await showGeneralDialog<bool>(
            context: context!,
            barrierDismissible: barrierDismissible,
            transitionDuration: const Duration(milliseconds: 250),
            barrierLabel: MaterialLocalizations.of(context).dialogLabel,
            barrierColor: Colors.black.withOpacity(0.5),
            pageBuilder: (context, _, __) => SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  widget,
                ],
              ),
            ),
            transitionBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: CurvedAnimation(
                        parent: animation, curve: Curves.easeOutCubic)
                    .drive(
                  Tween<Offset>(
                    begin: const Offset(0, -1.0),
                    end: Offset.zero,
                  ),
                ),
                child: child,
              );
            },
          ) ??
          false;
    } catch (e) {
      ZegoCallLogger.logError(
        'showTopModalSheet, $e, '
        'context:$context, ',
        tag: 'uikit',
        subTag: 'dialogs',
      );
    }

    return result;
  }
}
