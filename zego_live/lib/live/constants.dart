/// How to resource id(a resource identifier used for configuring offline call invitations.)
///
const offlineResourceID = "zego_data";

const androidChannelID = 'zego_live';
const androidChannelName = 'zego live';
const androidIconName = 'call';
const androidSoundFileName = 'call';

class OfflineLiveCacheKey {
  /// zim ID of offline call
  static String cacheOfflineLiveZIMIDKey = 'cache_offline_live_zim_id_key';

  /// call protocol of offline call
  static String cacheOfflineLiveProtocolKey =
      'cache_offline_zim_live_protocol_key';
}
