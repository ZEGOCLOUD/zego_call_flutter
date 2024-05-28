# zego_live

Offline notification implemented using ZEGO SDK

![demo live](./../assets/pics/demo-live.gif)
    
# How to run

## Config AppID & AppSign

- Go to [ZEGOCLOUD Admin Console](https://console.zegocloud.com/) to create a UIKit project.
- Get the `AppID` and `AppSign` of the project
- Config `yourSecretID` and `yourSecretAppSign` in **zego_call/lib/app/constants.dart**

## Config offline call

If you encounter configuration issues, please consult our technical support or refer to this [article](https://www.zegocloud.com/docs/uikit/callkit-flutter/quick-start-(with-call-invitation))

> When you get the resource id from the following steps, you should configure it to `offlineResourceID` in **zego_call/lib/call/constants.dart**

- android

  Please refer to the following steps to configure your Android project.

  - Firebase Console and ZEGO Console Configuration

    - In the Firebase console: Create a project. (Resource may help: [Firebase Console](https://console.firebase.google.com/))

      [![Watch the video](https://img.youtube.com/vi/HhP7rLirCA4/default.jpg)](https://youtu.be/HhP7rLirCA4)
    - In the ZegoCloud console: Add FCM certificate, create a resource ID

      > In the create resource ID popup dialog, you should switch to the VoIP option for APNs, and switch to Data messages for FCM.
      >

      [![Watch the video](https://img.youtube.com/vi/K3kRWyafRIY/default.jpg)](https://youtu.be/K3kRWyafRIY)

      When you have completed the configuration, you will obtain the resourceID. You can refer to the image below for comparison.
      ![android_resource_id](./../assets/pics/android_resource_id.png)
    - In the Firebase console: Create an Android application and modify your code

    [![Watch the video](https://img.youtube.com/vi/0f9Ai2uJM5o/default.jpg)](https://youtu.be/0f9Ai2uJM5o)
  - Replace your google-service.json
- iOS

  Please refer to the following steps to configure your iOS project.

  - Apple Developer Center and ZEGOCLOUD Console Configuration
    - You need to refer to [Create VoIP services certificates](https://developer.apple.com/help/account/create-certificates/create-voip-services-certificates/) to create the   VoIP service certificate, and export a .p12 file on your Mac.
      [![Watch the video](https://img.youtube.com/vi/UK9AUXcTGCE/default.jpg)](https://youtu.be/UK9AUXcTGCE)
    - Add the voip service certificate .p12 file. Then, create a resource ID

      > In the create resource ID popup dialog, you should switch to the VoIP option for APNs, and switch to Data messages for FCM.
      >

      [![Watch the video](https://img.youtube.com/vi/sYFeq7sZFEA/default.jpg)](https://youtu.be/sYFeq7sZFEA)

      When you have completed the configuration, you will obtain the resourceID. You can refer to the image below for comparison.
      ![ios_resource_id](./../assets/pics/ios_resource_id.png)

# Code

## Structure:

```
├── main.dart
├── logger.dart
├── app: App APIs, account logic
│   ├── constants.dart
│   ├── login_service.dart
│   └── pages
│       ├── defines.dart
│       ├── home_page.dart
│       ├── login_page.dart
│       └── home
│           ├── group.dart
│           ├── home.dart
│           ├── lives.dart
│           └── personal.dart
└── live: Live-related logic
    ├── constants.dart
    ├── prebuilt_live_route.dart: Jump to zego_uikit_prebuilt_live_streaming widget
    ├── protocol.dart: Call invitation protocol
    └── service: Encapsulation of call service
        ├── data.dart
        ├── defines.dart
        ├── service.dart
        ├── android.utils.dart
        └── offline: Offline-related logic
            ├── data.dart
            ├── mixin.dart
            └── android: Android offline-related logic
                └── events.dart: Android offline callback
```

