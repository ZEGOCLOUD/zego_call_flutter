// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:zego_offline_call/app/constants.dart';
import 'package:zego_offline_call/app/login_service.dart';
import 'package:zego_offline_call/app/pages/defines.dart';
import 'package:zego_offline_call/call/service/defines.dart';
import 'package:zego_offline_call/call/service/service.dart';
import 'package:zego_offline_call/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ZegoCallLogger().initLog().then((_) async {
    ZegoCallLogger.logInfo(
      'main',
      tag: 'call',
      subTag: 'main',
    );

    final prefs = await SharedPreferences.getInstance();
    final cacheUserID = prefs.get(cacheUserIDKey) as String? ?? '';
    if (cacheUserID.isNotEmpty) {
      currentUser.id = cacheUserID;
      currentUser.name = 'user_$cacheUserID';
    }

    ZegoCallService().init(
      appID: yourSecretID,
      appSign: yourSecretAppSign,
      config: ZegoCallServiceConfig(
        supportOffline: true,
        navigatorKey: navigatorKey,
      ),
    );

    runApp(MyApp(navigatorKey: navigatorKey));
  });
}

class MyApp extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const MyApp({
    required this.navigatorKey,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    if (currentUser.id.isNotEmpty) {
      onUserLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: routes,
      initialRoute:
          currentUser.id.isEmpty ? PageRouteNames.login : PageRouteNames.home,
      color: Colors.red,
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFEFEFEF)),
      navigatorKey: widget.navigatorKey,
    );
  }
}
