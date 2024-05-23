// Flutter imports:
import 'package:flutter/cupertino.dart';

// Project imports:
import 'package:zego_offline_call/core/defines.dart';

int yourSecretID = ;
String yourSecretAppSign = ;

final navigatorKey = GlobalKey<NavigatorState>();
ZegoUser currentUser = ZegoUser.empty();

const String cacheUserIDKey = 'cache_user_id_key';
