// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';

// Project imports:
import 'package:zego_call/call/service/defines.dart';

class ZegoCallServiceData {
  bool isInit = false;
  ZegoCallServiceConfig? config;

  List<StreamSubscription<dynamic>?> subscriptions = [];

  final callStatusNotifier = ValueNotifier<bool>(false);
}
