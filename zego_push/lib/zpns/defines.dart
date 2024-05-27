// Flutter imports:
import 'package:flutter/services.dart';

/// @nodoc
class ZegoZPNSNotificationRegisteredEvent {
  ZegoZPNSNotificationRegisteredEvent({
    required this.pushID,
    required this.code,
  });

  final String pushID;
  final int code;

  @override
  String toString() => '{pushID: $pushID, '
      'code: $code}';
}

/// @nodoc
class ZegoZPNSMessageEvent {
  ZegoZPNSMessageEvent({
    required this.title,
    required this.content,
    required this.extras,
  });

  final String title;
  final String content;
  final Map<String, Object?> extras;

  @override
  String toString() => 'ZegoZPNSMessageEvent{'
      'title: $title, '
      'content: $content, '
      'extras: $extras, '
      '}';
}

/// @nodoc
class ZegoSignalingPluginEnableNotifyResult {
  const ZegoSignalingPluginEnableNotifyResult({
    this.error,
  });

  final PlatformException? error;

  @override
  String toString() => '{error: $error}';
}

enum ZegoSignalingPluginMultiCertificate {
  firstCertificate,
  secondCertificate,
}

extension ZegoSignalingPluginIOSMultiCertificateExtension
    on ZegoSignalingPluginMultiCertificate {
  static ZegoSignalingPluginMultiCertificate fromID(int id) {
    switch (id) {
      case 0:
      case 1:
        return ZegoSignalingPluginMultiCertificate.firstCertificate;
      case 2:
        return ZegoSignalingPluginMultiCertificate.secondCertificate;
    }
    assert(false);
    return ZegoSignalingPluginMultiCertificate.firstCertificate;
  }

  int get id {
    switch (this) {
      case ZegoSignalingPluginMultiCertificate.firstCertificate:
        return 1;
      case ZegoSignalingPluginMultiCertificate.secondCertificate:
        return 2;
    }
  }
}
