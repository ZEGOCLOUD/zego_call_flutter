// Dart imports:
import 'dart:convert';

// Package imports:
import 'package:zego_push/zego_push.dart';

// Project imports:
import 'package:zego_call/logger.dart';

class ZegoCallInvitationSendRequestProtocol extends ZegoInvitationProtocol {
  String callID = '';
  ZegoUser inviter = ZegoUser.empty();
  List<ZegoUser> invitees = [];
  int timeout = 60;
  bool isVideo = false;
  String customData = '';

  ZegoCallInvitationSendRequestProtocol.empty();

  ZegoCallInvitationSendRequestProtocol({
    required this.callID,
    required this.inviter,
    required this.invitees,
    required this.timeout,
    required this.customData,
    required this.isVideo,
  });

  @override
  String toJson() {
    final dict = {
      'call_id': callID,
      'is_video': isVideo,
      'inviter_id': inviter.id,
      'inviter_name': inviter.name,
      'invitees': invitees
          .map((user) => {
                'user_id': user.id,
                'user_name': user.name,
              })
          .toList(),
      'timeout': timeout,
      'data': customData,
    };
    return const JsonEncoder().convert(dict);
  }

  ZegoCallInvitationSendRequestProtocol.fromJson(String json) {
    var dict = <String, dynamic>{};
    try {
      dict = jsonDecode(json) as Map<String, dynamic>;
    } catch (e) {
      ZegoCallLogger.logError(
        'InvitationSendRequestData, json decode data exception:$e',
        tag: 'call',
        subTag: 'protocols',
      );
    }
    _parseFromMap(dict);
  }

  ZegoCallInvitationSendRequestProtocol.fromJsonMap(Map<String, dynamic> dict) {
    _parseFromMap(dict);
  }

  void _parseFromMap(Map<String, dynamic> dict) {
    callID = dict['call_id'] as String? ?? '';
    timeout = dict['timeout'] as int? ?? 60;
    customData = dict['data'] as String? ?? '';
    isVideo = dict['is_video'] as bool? ?? false;
    inviter = ZegoUser(
      id: dict['inviter_id'] as String? ?? '',
      name: dict['inviter_name'] as String? ?? '',
    );
    for (final invitee in dict['invitees'] as List) {
      final inviteeDict = invitee as Map<String, dynamic>;
      final user = ZegoUser(
        id: inviteeDict['user_id'] as String,
        name: inviteeDict['user_name'] as String,
      );
      invitees.add(user);
    }
  }

  @override
  String toString() {
    return toJson();
  }
}
