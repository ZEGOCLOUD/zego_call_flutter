// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:zego_offline_call/core/protocol.dart';
import 'package:zego_offline_call/core/defines.dart';
import 'package:zego_offline_call/core/zim/defines.dart';
import 'package:zego_offline_call/core/zim/service.dart';
import 'package:zego_offline_call/logger.dart';

class ZegoSendCallInvitationButton extends StatefulWidget {
  const ZegoSendCallInvitationButton({
    Key? key,
    required this.inviter,
    required this.invitees,
    required this.isVideoCall,
    required this.callID,
    required this.resourceID,
    required this.protocol,
    this.onWillPressed,
    this.onPressed,
  }) : super(key: key);
  final ZegoUser inviter;

  /// The list of invitees to send the call invitation to.
  final List<ZegoUser> invitees;

  /// you can specify the call ID.
  /// If not provided, the system will generate one automatically based on certain rules.
  final String callID;

  /// Determines whether the call is a video call. If false, it is an audio call by default.
  final bool isVideoCall;

  final ZegoInvitationProtocol protocol;

  /// start invitation if return true false will do nothing
  final Future<bool> Function()? onWillPressed;

  /// Callback function that is executed when the button is pressed.
  final void Function(
    String zimCallID,
    ZegoInvitationProtocol requestProtocol,
    String code,
    String message,
    List<String> errorInvitees,
  )? onPressed;

  /// The [resource id] for notification which same as [Zego Console](https://console.zegocloud.com/)
  final String resourceID;

  @override
  State<ZegoSendCallInvitationButton> createState() =>
      _ZegoSendCallInvitationButtonState();
}

/// @nodoc
class _ZegoSendCallInvitationButtonState
    extends State<ZegoSendCallInvitationButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      onLongPress: onPressed,
      child: Container(
        width: 60,
        height: 60,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.green,
        ),
        child: Icon(
          widget.isVideoCall ? Icons.video_camera_front : Icons.call,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> onPressed() async {
    final canSendInvitation = await widget.onWillPressed?.call() ?? true;
    if (!canSendInvitation) {
      ZegoCallLogger.logInfo(
        'onWillPressed stop click process',
        tag: 'call',
        subTag: 'start invitation button',
      );

      return;
    }

    await ZIMService()
        .sendInvitation(
      invitees: widget.invitees.map((e) => e.id).toList(),
      timeout: 60,
      extendedData: widget.protocol.toJson(),

      /// offline call
      pushConfig: ZegoZIMPushConfig(
        resourceID: widget.resourceID,
        title: widget.inviter.name,
        message: widget.isVideoCall ? 'Video Call' : 'Audio Call',
        payload: widget.protocol.toJson(),
        voipConfig: ZegoZIMVoIPConfig(
          inviterName: widget.inviter.name,
          iOSVoIPHasVideo: widget.isVideoCall,
        ),
      ),
    )
        .then((result) {
      widget.onPressed?.call(
        result.invitationID,
        widget.protocol,
        result.error?.code ?? '',
        result.error?.message ?? '',
        result.errorInvitees.keys.toList(),
      );
    });
  }
}
