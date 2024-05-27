import 'package:flutter/services.dart';

import 'package:zego_callkit_incoming/zego_callkit_incoming.dart';

typedef ZegoPushCallKitNotificationChannelConfig
    = ZegoLocalNotificationChannelConfig;

class ZegoPushCallKitCallNotificationConfig {
  const ZegoPushCallKitCallNotificationConfig({
    this.vibrate = true,
    this.iconSource,
    this.soundSource,
    this.acceptButtonText = 'Accept',
    this.rejectButtonText = 'Reject',
    required this.channelID,
    required this.title,
    required this.content,
    this.acceptCallback,
    this.rejectCallback,
    this.cancelCallback,
    this.clickCallback,
  });

  final bool vibrate;
  final String? iconSource;
  final String? soundSource;
  final String channelID;
  final String title;
  final String content;
  final String acceptButtonText;
  final String rejectButtonText;
  final VoidCallback? acceptCallback;
  final VoidCallback? rejectCallback;
  final VoidCallback? cancelCallback;
  final VoidCallback? clickCallback;

  @override
  String toString() {
    return 'ZegoPushCallKitCallNotificationConfig: {'
        'icon source:$iconSource, '
        'sound source:$soundSource,'
        'channel id:$channelID, '
        'title:$title, '
        'content:$content, '
        'accept button text:$acceptButtonText, '
        'reject button text:$rejectButtonText, '
        '}';
  }
}
