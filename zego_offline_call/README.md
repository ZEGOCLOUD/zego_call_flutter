# zego_call_flutter

使用ZEGO SDK实现的在线/离线呼叫

# 代码解析
## 代码结构:
```
├── main.dart
├── logger.dart
├── app: App interface, account logic
│   ├── constants.dart
│   ├── login_service.dart
│   └── pages
│       ├── defines.dart
│       ├── home_page.dart
│       ├── login_page.dart
│       └── home
│           ├── contacts.dart
│           ├── dialpad.dart
│           ├── personal.dart
│           └── recents.dart
├── call: Call-related logic
│   ├── constants.dart
│   ├── prebuilt_call_route.dart: Jump to zego_uikit_prebuilt_call interface
│   ├── protocol.dart: Call invitation protocol
│   ├── components: Encapsulation of call components
│   │   ├── calling_page.dart: Call interface (inviter)
│   │   ├── online_invitation_notify.dart: Online invitation notification (invitee)
│   │   └── buttons
│   │       ├── send_call_button.dart: Call invitation button (for inviter)
│   │       ├── cancel_call_button.dart: Cancel call button (for inviter)
│   │       ├── accept_call_button.dart: Accept call button (for invitee)
│   │       └── reject_call_button.dart: Reject call button (for invitee)
│   └── service: Encapsulation of call service
│       ├── data.dart
│       ├── defines.dart
│       ├── service.dart
│       ├── android.utils.dart
│       └── offline: Offline-related logic
│       │   ├── android.dart: Android offline-related logic
│       │   ├── data.dart
│       │   ├── mixin.dart
│       │   └── ios: iOS offline-related logic
│       │       ├── ios.dart
│       │       ├── data.dart
│       │       ├── defines.dart
│       │       └── events.dart: iOS offline callback
│       └── online: Online-related logic
│           ├── data.dart
│           ├── events.dart
│           ├── mixin.dart
│           └── popups.dart
└── core
    ├── defines.dart
    ├── protocol.dart
    ├── callkit: Zego_callkit interface encapsulation
    │   ├── data.dart
    │   ├── defines.dart
    │   ├── events.dart
    │   └── service.dart
    ├── zim: Zego_zim interface encapsulation
    │   ├── data.dart
    │   ├── defines.dart
    │   ├── events.dart
    │   └── service.dart
    └── zpns: Zego_zpns interface encapsulation
        ├── data.dart
        ├── defines.dart
        ├── events.dart
        └── service.dart
```


## Online Call Sequence Diagram:

![plot](./../assets/pics/online-call-sequence-diagram.png)


## Offline Call Sequence Diagram:

![plot](./../assets/pics/offline-call-sequence-diagram.png)