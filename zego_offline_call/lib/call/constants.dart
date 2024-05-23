const offlineResourceID = "zego_data";
const androidChannelID = 'zego_offline_call';
const androidChannelName = 'zego offline call';
const androidIconName = 'call';
const androidSoundFileName = 'call';

class OfflineCallCacheKey {
  /// zim ID of offline call
  static String cacheOfflineZIMCallIDKey = 'cache_offline_zim_call_id_key';

  /// how to active the app in offline notification, click the Agree button or
  /// click the blank area.
  /// value:(true/false)
  ///
  /// If marked as accepted, it means that the application is triggered by
  /// clicking the agree button in the notification, so you should directly
  /// enter the call.
  ///
  /// Otherwise, if the application is triggered by clicking on a blank area,
  /// then after activating the app, the online call invitation notification
  /// notify should pop up again.
  static String cacheOfflineZIMCallAcceptKey =
      'cache_offline_zim_call_accept_key';

  /// call protocol of offline call
  static String cacheOfflineCallProtocolKey =
      'cache_offline_zim_call_protocol_key';
}
