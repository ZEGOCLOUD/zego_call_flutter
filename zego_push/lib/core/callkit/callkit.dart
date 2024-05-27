part of 'package:zego_push/service.dart';

mixin ZegoPushCallKitMixin {
  final _callkitImpl = ZegoPushCallKitMixinImpl();
  ZegoPushCallKitMixinImpl get callkit => _callkitImpl;
}

class ZegoPushCallKitMixinImpl {
  final android = ZegoPushCallKitAndroid();
  final iOS = ZegoPushCallKitIOS();
}
