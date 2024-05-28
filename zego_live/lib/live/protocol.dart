// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:zego_push/zego_push.dart';

// Project imports:
import 'package:zego_live/logger.dart';

class ZegoLiveInvitationSendRequestProtocol extends ZegoInvitationProtocol {
  String liveID = '';
  String hostID = '';
  String hostName = '';
  String customData = '';

  ZegoLiveInvitationSendRequestProtocol.empty();

  ZegoLiveInvitationSendRequestProtocol({
    required this.liveID,
    required this.hostID,
    required this.hostName,
    required this.customData,
  });

  @override
  String toJson() {
    final dict = {
      'live_id': liveID,
      'host_id': hostID,
      'host_name': hostName,
      'data': customData,
    };
    return const JsonEncoder().convert(dict);
  }

  ZegoLiveInvitationSendRequestProtocol.fromJson(String json) {
    var dict = <String, dynamic>{};
    try {
      dict = jsonDecode(json) as Map<String, dynamic>;
    } catch (e) {
      ZegoLiveLogger.logError(
        'ZegoLiveInvitationSendRequestProtocol, json decode data exception:$e',
        tag: 'live',
        subTag: 'protocols',
      );
    }
    _parseFromMap(dict);
  }

  ZegoLiveInvitationSendRequestProtocol.fromJsonMap(Map<String, dynamic> dict) {
    _parseFromMap(dict);
  }

  void _parseFromMap(Map<String, dynamic> dict) {
    liveID = dict['live_id'] as String? ?? '';
    hostID = dict['host_id'] as String? ?? '';
    hostName = dict['host_name'] as String? ?? '';
    customData = dict['data'] as String? ?? '';
  }

  @override
  String toString() {
    return toJson();
  }
}
