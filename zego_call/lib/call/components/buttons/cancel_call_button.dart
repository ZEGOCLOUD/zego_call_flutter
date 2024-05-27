// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_push/zego_push.dart';

class ZegoCancelCallInvitationButton extends StatefulWidget {
  const ZegoCancelCallInvitationButton({
    Key? key,
    required this.zimCallID,
    required this.invitees,
    this.onPressed,
  }) : super(key: key);

  final String zimCallID;
  final List<ZegoUser> invitees;
  final void Function(bool result)? onPressed;

  @override
  State<ZegoCancelCallInvitationButton> createState() =>
      _ZegoCancelCallInvitationButtonState();
}

/// @nodoc
class _ZegoCancelCallInvitationButtonState
    extends State<ZegoCancelCallInvitationButton> {
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
        .cancel(
      invitationID: widget.zimCallID,
      invitees: widget.invitees.map((e) => e.id).toList(),
    )
        .then((value) {
      widget.onPressed?.call(value.errorInvitees.isEmpty);
    });
  }
}
