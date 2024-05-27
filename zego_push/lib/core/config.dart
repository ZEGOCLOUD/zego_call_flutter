import 'package:zego_callkit/zego_callkit.dart';
import 'package:zego_zpns/zego_zpns.dart';

class ZegoPushConfig {
  ZegoPushOfflineConfig? offlineConfig;
  ZegoPushConfig({
    this.offlineConfig,
  });
}

class ZegoPushOfflineConfig {
  ZegoPushOfflineAndroidConfig? android;
  ZegoPushOfflineIOSConfig? iOS;

  bool get isSupport => null != android?.handler || null != iOS?.handler;

  ZegoPushOfflineConfig({
    this.android,
    this.iOS,
  });
}

class ZegoPushOfflineAndroidConfig {
  ZPNsBackgroundMessageHandler? handler;

  String channelID;
  String channelName;

  ZegoPushOfflineAndroidConfig({
    this.handler,
    this.channelID = 'zego_push',
    this.channelName = 'Zego Push',
  });
}

class ZegoPushOfflineIOSConfig {
  void Function(String zimCallID, String payload, Map extras)? handler;

  String localizedName;
  String iconTemplateImageName;

  ZegoPushOfflineIOSConfig({
    this.handler,
    this.localizedName = '',
    this.iconTemplateImageName = '',
  });
}
