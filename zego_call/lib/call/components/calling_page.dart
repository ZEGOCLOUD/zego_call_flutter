// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_push/zego_push.dart';

// Project imports:
import 'package:zego_call/call/components/buttons/cancel_call_button.dart';

class ZegoCallingPage extends StatelessWidget {
  const ZegoCallingPage({
    Key? key,
    required this.zimCallID,
    required this.inviter,
    required this.invitees,
    required this.isVideo,
    this.onCanceled,
  }) : super(key: key);

  final String zimCallID;
  final ZegoUser inviter;
  final List<ZegoUser> invitees;
  final bool isVideo;

  final void Function(bool result)? onCanceled;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 140),
        centralName(invitees.map((e) => e.name).toList().join(',')),
        const SizedBox(height: 47),
        callingText(isVideo ? 'Video Call' : 'Audio Call'),
        const Expanded(child: SizedBox()),
        Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: ZegoCancelCallInvitationButton(
              zimCallID: zimCallID,
              invitees: invitees,
              onPressed: onCanceled,
            ),
          ),
        ),
        const SizedBox(height: 105),
      ],
    );
  }

  Widget centralName(String name) {
    return SizedBox(
      height: 59,
      child: Text(
        name,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 30.0,
          decoration: TextDecoration.none,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget callingText(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18.0,
        fontWeight: FontWeight.w400,
        decoration: TextDecoration.none,
      ),
    );
  }
}
