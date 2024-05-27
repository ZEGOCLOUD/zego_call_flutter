// Flutter imports:
import 'package:flutter/cupertino.dart';

// Project imports:
import 'home_page.dart';
import 'login_page.dart';

class PageRouteNames {
  static const String login = '/login';
  static const String home = '/home_page';
}

Map<String, WidgetBuilder> routes = {
  PageRouteNames.login: (context) => const LoginPage(),
  PageRouteNames.home: (context) => const HomePage(),
};
