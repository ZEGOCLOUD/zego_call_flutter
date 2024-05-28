// Flutter imports:
import 'dart:math';

import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:zego_push/zego_push.dart';

// Project imports:
import 'package:zego_live/secret.dart';

/// How to Get AppID and AppSign
///
/// 1. Go to [ZEGOCLOUD Admin Console](https://console.zegocloud.com/) to create a UIKit project.
/// 2. Get the AppID and AppSign of the project
int yourSecretID = NativeSecret.appID;
String yourSecretAppSign = NativeSecret.appSign;

final navigatorKey = GlobalKey<NavigatorState>();
ZegoUser currentUser = ZegoUser.empty();

const String cacheUserIDKey = 'cache_user_id_key';

final followersUserIDList = ValueNotifier<List<String>>(
  List.generate(
    10,
    (index) {
      return 'f_${Random().nextInt(100) + index}';
    },
  ),
);
