// Flutter imports:
import 'package:flutter/cupertino.dart';

// Project imports:
import 'package:zego_offline_call/core/defines.dart';

/// How to Get AppID and AppSign
///
/// 1. Go to [ZEGOCLOUD Admin Console](https://console.zegocloud.com/) to create a UIKit project.
/// 2. Get the AppID and AppSign of the project
int yourSecretID = ;
String yourSecretAppSign = ;

final navigatorKey = GlobalKey<NavigatorState>();
ZegoUser currentUser = ZegoUser.empty();

const String cacheUserIDKey = 'cache_user_id_key';
