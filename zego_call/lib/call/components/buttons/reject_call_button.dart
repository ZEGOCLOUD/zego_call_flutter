// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_push/zego_push.dart';

class ZegoRejectCallInvitationButton extends StatefulWidget {
  const ZegoRejectCallInvitationButton({
    Key? key,
    required this.zimCallID,
    required this.protocol,
    this.onPressed,
  }) : super(key: key);

  final String zimCallID;
  final void Function(bool result)? onPressed;
  final ZegoInvitationProtocol protocol;

  @override
  State<ZegoRejectCallInvitationButton> createState() =>
      _ZegoRejectCallInvitationButtonState();
}

/// @nodoc
class _ZegoRejectCallInvitationButtonState
    extends State<ZegoRejectCallInvitationButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      onLongPress: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: Colors.red,
        ),
        child: const Icon(
          Icons.phone,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> onPressed() async {
    await ZegoPushService()
        .refuse(
      invitationID: widget.zimCallID,
      extendedData: widget.protocol.toJson(),
    )
        .then((value) {
      widget.onPressed?.call(value);
    });
  }
}
