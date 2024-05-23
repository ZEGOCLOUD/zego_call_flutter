// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_dialpad/flutter_dialpad.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

// Project imports:
import 'package:zego_offline_call/app/constants.dart';
import 'package:zego_offline_call/call/components/buttons/send_call_button.dart';
import 'package:zego_offline_call/call/constants.dart';
import 'package:zego_offline_call/call/protocol.dart';
import 'package:zego_offline_call/core/protocol.dart';
import 'package:zego_offline_call/core/defines.dart';

class DialPadTab extends StatefulWidget {
  const DialPadTab({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DialPadTabState();
}

class DialPadTabState extends State<DialPadTab> {
  final callNumberNotifier = ValueNotifier<String>("");

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SafeArea(
        child: DialPad(
          enableDtmf: true,
          outputMask: "000000",
          buttonColor: Colors.grey.withOpacity(0.5),
          backspaceButtonIconColor: Colors.red,
          valueUpdated: (String value) {
            callNumberNotifier.value = value;
          },
          audioDialButtonBuilder: () {
            return ValueListenableBuilder<String>(
              valueListenable: callNumberNotifier,
              builder: (context, callNumber, _) {
                return sendCallButton(
                  isVideoCall: false,
                  inviteeUserID: callNumber,
                  onCallFinished: onSendCallInvitationFinished,
                );
              },
            );
          },
          videoDialButtonBuilder: () {
            return ValueListenableBuilder<String>(
              valueListenable: callNumberNotifier,
              builder: (context, callNumber, _) {
                return sendCallButton(
                  isVideoCall: true,
                  inviteeUserID: callNumber,
                  onCallFinished: onSendCallInvitationFinished,
                );
              },
            );
          },
        ),
      ),
    );
  }

  void onSendCallInvitationFinished(
    String code,
    String message,
    String zimCallID,
    List<String> errorInvitees,
  ) {
    if (errorInvitees.isNotEmpty) {
      String userIDs = "";
      for (int index = 0; index < errorInvitees.length; index++) {
        if (index >= 5) {
          userIDs += '... ';
          break;
        }

        var userID = errorInvitees.elementAt(index);
        userIDs += '$userID ';
      }
      if (userIDs.isNotEmpty) {
        userIDs = userIDs.substring(0, userIDs.length - 1);
      }

      var message = 'User does not exist or is offline: $userIDs';
      if (code.isNotEmpty) {
        message += ', code: $code, message:$message';
      }
      showToast(
        message,
        position: StyledToastPosition.top,
        context: context,
      );
    } else if (code.isNotEmpty) {
      showToast(
        'code: $code, message:$message',
        position: StyledToastPosition.top,
        context: context,
      );
    }
  }

  Widget sendCallButton({
    required bool isVideoCall,
    required String inviteeUserID,
    void Function(
      String code,
      String message,
      String zimCallID,
      List<String> errorInvitees,
    )? onCallFinished,
  }) {
    final callID =
        'call_${currentUser.id}_${DateTime.now().millisecondsSinceEpoch}';
    final inviter = ZegoUser(
      id: currentUser.id,
      name: currentUser.name,
    );
    final invitees = [ZegoUser(id: inviteeUserID, name: '')];
    return ZegoSendCallInvitationButton(
      callID: callID,
      isVideoCall: isVideoCall,
      inviter: inviter,
      invitees: invitees,
      resourceID: offlineResourceID,
      protocol: ZegoCallInvitationSendRequestProtocol(
        callID: callID,
        isVideo: isVideoCall,
        inviter: inviter,
        invitees: invitees,
        timeout: 60,
        customData: '',
      ),
      onWillPressed: () async {
        if (inviteeUserID.isEmpty) {
          return false;
        }

        return true;
      },
      onPressed: (
        String zimCallID,
        ZegoInvitationProtocol requestProtocol,
        String code,
        String message,
        List<String> errorInvitees,
      ) {
        onCallFinished?.call(
          code,
          message,
          zimCallID,
          errorInvitees,
        );
      },
    );
  }
}
