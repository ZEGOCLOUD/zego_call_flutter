import 'package:zego_push/core/data.dart';
import 'package:zego_callkit/zego_callkit.dart';

import 'config.dart';
import 'event.dart';

class ZegoPushData {
  bool isInit = false;

  int appID = 0;
  String appSign = '';

  ZegoPushConfig? config;
  ZegoPushEvent? event;
}
