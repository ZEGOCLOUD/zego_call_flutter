// Flutter imports:
import 'package:flutter/cupertino.dart';

class ZegoCallServiceConfig {
  bool supportOffline;
  GlobalKey<NavigatorState> navigatorKey;

  ZegoCallServiceConfig({
    required this.navigatorKey,
    this.supportOffline = true,
  });
}
