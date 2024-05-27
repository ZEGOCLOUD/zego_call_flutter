import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'defines.dart';
import 'impl.dart';

abstract class ZegoCallIncomingPlugin extends PlatformInterface {
  /// Constructs a ZegoCallPluginPlatformInterface.
  ZegoCallIncomingPlugin() : super(token: _token);

  static final Object _token = Object();

  static ZegoCallIncomingPlugin _instance = ZegoCallIncomingPluginImpl();

  /// The default instance of [ZegoCallIncomingPlugin] to use.
  ///
  /// Defaults to [MethodChannelUntitled].
  static ZegoCallIncomingPlugin get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ZegoCallIncomingPlugin] when
  /// they register themselves.
  static set instance(ZegoCallIncomingPlugin instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// launch_current_app
  Future<void> launchCurrentApp() {
    throw UnimplementedError('launchCurrentAPP has not been implemented.');
  }

  /// activeAudioByCallKit
  Future<void> activeAudioByCallKit() {
    throw UnimplementedError('activeAudioByCallKit has not been implemented.');
  }

  /// checkAppRunning
  Future<bool> checkAppRunning() {
    throw UnimplementedError('checkAppRunning has not been implemented.');
  }

  /// addLocalCallNotification
  Future<void> addLocalCallNotification(
    ZegoLocalCallNotificationConfig config,
  ) {
    throw UnimplementedError(
        'addLocalCallNotification has not been implemented.');
  }

  /// createNotificationChannel
  Future<void> createNotificationChannel(
    ZegoLocalNotificationChannelConfig config,
  ) {
    throw UnimplementedError(
        'createNotificationChannel has not been implemented.');
  }

  /// dismissAllNotifications
  Future<void> dismissAllNotifications() {
    throw UnimplementedError(
        'dismissAllNotifications has not been implemented.');
  }

  /// activeAppToForeground
  Future<void> activeAppToForeground() {
    throw UnimplementedError('activeAppToForeground has not been implemented.');
  }

  Future<void> requestDismissKeyguard() {
    throw UnimplementedError(
        'requestDismissKeyguard has not been implemented.');
  }
}
