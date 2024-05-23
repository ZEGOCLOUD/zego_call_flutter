# zego_call_flutter

Online/Offline call implemented using ZEGO SDK

## Libraries

- flutter_dialpad-1.0.5

  call dialpad from [pub.dev](https://pub.dev/packages/flutter_dialpad)
- zego_callkit_incoming

  plugin library of android notification
- zego_offline_call

  App project, online/offline call

  - Effects:

    ![run_gif](./assets/pics/run.gif)

    | Online Notification                                         | Offline Notification(iOS)                                             | Notification(Android)                                                         | In Call                                   |
    | ----------------------------------------------------------- | --------------------------------------------------------------------- | ----------------------------------------------------------------------------- | ----------------------------------------- |
    | ![online-notification](./assets/pics/online-notification.jpg) | ![offline-notification-ios](./assets/pics/offline-notification-ios.jpg) | ![offline-notification-android](./assets/pics/offline-notification-android.jpg) | ![video-call](./assets/pics/video-call.jpg) |
  - How to run

    - Config AppID & AppSign
      - Go to [ZEGOCLOUD Admin Console](https://console.zegocloud.com/) to create a UIKit project.
      - Get the `AppID` and `AppSign` of the project
      - Config `yourSecretID` and `yourSecretAppSign` in **zego_offline_call/lib/app/constants.dart**
    - Config offline call
      - android
        - ... editing
      - iOS
        - ... editing
