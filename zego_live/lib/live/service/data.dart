// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';

// Project imports:
import 'package:zego_live/live/service/defines.dart';

class ZegoLiveServiceData {
  bool isInit = false;
  ZegoLiveServiceConfig? config;

  List<StreamSubscription<dynamic>?> subscriptions = [];

  final liveStatusNotifier = ValueNotifier<bool>(false);
}
