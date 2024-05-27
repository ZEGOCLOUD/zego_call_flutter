// Dart imports:
import 'dart:async';

// Package imports:
import 'package:zego_zim/zego_zim.dart';

class ZIMData {
  bool isInit = false;
  List<StreamSubscription<dynamic>?> subscriptions = [];

  ZIMUserInfo? currentUser;
}
