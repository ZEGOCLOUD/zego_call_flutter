// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_push/zego_push.dart';

class ZegoAcceptCallInvitationButton extends StatefulWidget {
  const ZegoAcceptCallInvitationButton({
    Key? key,
    required this.zimCallID,
    required this.protocol,
    this.onPressed,
  }) : super(key: key);

  final String zimCallID;
  final void Function(bool result)? onPressed;
  final ZegoInvitationProtocol protocol;

  @override
  State<ZegoAcceptCallInvitationButton> createState() =>
      _ZegoAcceptCallInvitationButtonState();
}

/// @nodoc
class _ZegoAcceptCallInvitationButtonState
    extends State<ZegoAcceptCallInvitationButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      onLongPress: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: Colors.green,
        ),
        child: const Icon(
          Icons.check,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> onPressed() async {
    await ZegoPushService()
        .accept(
      invitationID: widget.zimCallID,
      extendedData: widget.protocol.toJson(),
    )
        .then((value) {
      widget.onPressed?.call(value);
    });
  }
}
