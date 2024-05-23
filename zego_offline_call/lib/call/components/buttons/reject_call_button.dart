// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:zego_offline_call/core/protocol.dart';
import 'package:zego_offline_call/core/zim/service.dart';

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
    await ZIMService()
        .refuseInvitation(
      invitationID: widget.zimCallID,
      extendedData: widget.protocol.toJson(),
    )
        .then((value) {
      widget.onPressed?.call(value);
    });
  }
}
