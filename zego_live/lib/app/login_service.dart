// Package imports:
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:zego_live/app/constants.dart';
import 'package:zego_live/live/service/service.dart';

/// local virtual login
Future<void> login({
  required String userID,
  required String userName,
}) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(cacheUserIDKey, userID);

  currentUser.id = userID;
  currentUser.name = 'user_$userID';
}

/// local virtual logout
Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove(cacheUserIDKey);
}

/// on user login
void onUserLogin() {
  ZegoLiveService().login(currentUser);
}

/// on user logout
void onUserLogout() {
  ZegoLiveService().logout();
}
