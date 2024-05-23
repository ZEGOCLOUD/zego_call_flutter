// Dart imports:
import 'dart:convert';
import 'dart:io' show Platform;

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';

// Project imports:
import 'package:zego_offline_call/app/login_service.dart';
import 'package:zego_offline_call/app/pages/defines.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _userIDTextCtrl = TextEditingController(text: 'user_id');
  final _passwordVisible = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();

    getUniqueUserId().then((userID) async {
      setState(() {
        _userIDTextCtrl.text = userID;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            logo(),
            const SizedBox(height: 50),
            userIDEditor(),
            passwordEditor(),
            const SizedBox(height: 30),
            signInButton(),
          ],
        ),
      ),
    );
  }

  Widget logo() {
    return Center(
      child: RichText(
        text: const TextSpan(
          text: 'ZE',
          style: TextStyle(color: Colors.black, fontSize: 20),
          children: <TextSpan>[
            TextSpan(
              text: 'GO',
              style: TextStyle(color: Colors.blue),
            ),
            TextSpan(text: 'CLOUD'),
          ],
        ),
      ),
    );
  }

  Widget userIDEditor() {
    return TextFormField(
      controller: _userIDTextCtrl,
      decoration: const InputDecoration(
        labelText: 'User ID',
      ),
    );
  }

  Widget passwordEditor() {
    return ValueListenableBuilder<bool>(
      valueListenable: _passwordVisible,
      builder: (context, isPasswordVisible, _) {
        return TextFormField(
          obscureText: !isPasswordVisible,
          decoration: InputDecoration(
            labelText: 'Password.(Any character for test)',
            suffixIcon: IconButton(
              icon: Icon(
                isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                _passwordVisible.value = !_passwordVisible.value;
              },
            ),
          ),
        );
      },
    );
  }

  Widget signInButton() {
    return ElevatedButton(
      onPressed: _userIDTextCtrl.text.isEmpty
          ? null
          : () async {
              login(
                userID: _userIDTextCtrl.text,
                userName: 'user_${_userIDTextCtrl.text}',
              ).then((value) {
                onUserLogin();

                Navigator.pushNamed(
                  context,
                  PageRouteNames.home,
                );
              });
            },
      child: const Text('Sign In',
          style: TextStyle(
            color: Colors.black,
            fontSize: 13.0,
            decoration: TextDecoration.none,
          )),
    );
  }

  Future<String> getUniqueUserId() async {
    String? deviceID;
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      final iosDeviceInfo = await deviceInfo.iosInfo;
      deviceID = iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      final androidDeviceInfo = await deviceInfo.androidInfo;
      deviceID = androidDeviceInfo.id; // unique ID on Android
    }

    if (deviceID != null && deviceID.length < 4) {
      if (Platform.isAndroid) {
        deviceID += '_android';
      } else if (Platform.isIOS) {
        deviceID += '_ios___';
      }
    }
    if (Platform.isAndroid) {
      deviceID ??= 'flutter_user_id_android';
    } else if (Platform.isIOS) {
      deviceID ??= 'flutter_user_id_ios';
    }

    final userID = md5
        .convert(utf8.encode(deviceID!))
        .toString()
        .replaceAll(RegExp(r'[^0-9]'), '');
    return userID.substring(userID.length - 6);
  }
}
