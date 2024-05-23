// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:zego_offline_call/call/components/buttons/reject_call_button.dart';
import 'package:zego_offline_call/call/protocol.dart';
import 'buttons/accept_call_button.dart';

class ZegoOnlineInvitationNotify extends StatefulWidget {
  const ZegoOnlineInvitationNotify({
    Key? key,
    required this.zimCallID,
    required this.protocol,
    this.onAccepted,
    this.onRefused,
  }) : super(key: key);

  final String zimCallID;
  final ZegoCallInvitationSendRequestProtocol protocol;

  final void Function(bool result)? onAccepted;
  final void Function(bool result)? onRefused;

  @override
  State<ZegoOnlineInvitationNotify> createState() =>
      _ZegoOnlineInvitationNotifyState();
}

class _ZegoOnlineInvitationNotifyState
    extends State<ZegoOnlineInvitationNotify> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final maxWidth = constraints.maxWidth - 5 * 2;
      return Container(
        padding: const EdgeInsets.all(10),
        width: maxWidth,
        height: 120,
        decoration: BoxDecoration(
          color: const Color(0xff333333).withOpacity(0.8),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Column(
                  children: [
                    userName(maxWidth / 2),
                    subtitle(maxWidth / 2),
                  ],
                ),
                const Expanded(child: SizedBox()),
                circleName(widget.protocol.inviter.name),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                declineButton(maxWidth / 2 - 24),
                const Expanded(child: SizedBox()),
                acceptButton(maxWidth / 2 - 24),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget circleName(String name) {
    return Container(
      width: 35,
      height: 35,
      decoration:
          const BoxDecoration(color: Color(0xffDBDDE3), shape: BoxShape.circle),
      child: Center(
        child: Text(
          name.isNotEmpty ? name.characters.first : '',
          style: const TextStyle(
            fontSize: 20.0,
            color: Color(0xff222222),
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }

  Widget userName(double width) {
    return SizedBox(
      width: width,
      height: 20,
      child: Text(
        widget.protocol.inviter.name,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.left,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12.0,
          fontWeight: FontWeight.w500,
          decoration: TextDecoration.none,
        ),
      ),
    );
  }

  Widget subtitle(double width) {
    return SizedBox(
      width: width,
      height: 20,
      child: Text(
        'Incoming ${widget.protocol.isVideo ? 'Video' : 'Audio'} Call',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12.0,
          fontWeight: FontWeight.w400,
          decoration: TextDecoration.none,
        ),
      ),
    );
  }

  Widget declineButton(double width) {
    return AbsorbPointer(
      absorbing: false,
      child: SizedBox(
        width: width,
        height: 40,
        child: ZegoRejectCallInvitationButton(
          zimCallID: widget.zimCallID,
          onPressed: widget.onRefused,
          protocol: widget.protocol,
        ),
      ),
    );
  }

  Widget acceptButton(double width) {
    return AbsorbPointer(
      absorbing: false,
      child: SizedBox(
        width: width,
        height: 40,
        child: ZegoAcceptCallInvitationButton(
          zimCallID: widget.zimCallID,
          onPressed: widget.onAccepted,
          protocol: widget.protocol,
        ),
      ),
    );
  }
}
