// Flutter imports:
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Project imports:
import 'package:zego_live/app/constants.dart';
import 'package:zego_live/app/login_service.dart';
import 'package:zego_live/app/pages/defines.dart';

class PersonalInfoTab extends StatefulWidget {
  const PersonalInfoTab({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PersonalInfoTabState();
}

class PersonalInfoTabState extends State<PersonalInfoTab> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'User ID: ${currentUser.id}',
                textAlign: TextAlign.right,
              ),
            ),
            const SizedBox(height: 10),
            const Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                children: [
                  Text('Followers:'),
                  Text(
                    '(They will be notified when you LIVE)',
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(10),
              ),
              width: screenSize.width - 10,
              height: screenSize.height / 3 * 2,
              child: Stack(
                children: [
                  followers(),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: ElevatedButton(
                      onPressed: () {
                        _showInputDialog(context);
                      },
                      child: const Text('Add A Follower'),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            logoutButton(),
          ],
        ),
      ),
    );
  }

  Widget followers() {
    return ValueListenableBuilder(
      valueListenable: followersUserIDList,
      builder: (context, followers, _) {
        return ListView.builder(
          itemCount: followersUserIDList.value.length,
          itemBuilder: (context, index) {
            final fansUserID = followersUserIDList.value[index];
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  const CircleAvatar(child: Icon(Icons.person)),
                  const SizedBox(width: 15),
                  Column(
                    children: [
                      Text(
                        'User ID: $fansUserID',
                        style: const TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 10,
                        ),
                      ),
                      const Text(
                        'Details: ....',
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget logoutButton() {
    return Ink(
      width: 60,
      height: 60,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.redAccent,
      ),
      child: IconButton(
        icon: const Icon(Icons.exit_to_app_sharp),
        iconSize: 30,
        color: Colors.white,
        onPressed: () {
          logout().then((value) {
            onUserLogout();

            Navigator.pushNamed(
              context,
              PageRouteNames.login,
            );
          });
        },
      ),
    );
  }

  void _showInputDialog(BuildContext context) {
    final textController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter a Follower ID'),
          content: TextField(
            controller: textController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: const InputDecoration(
              hintText: 'Enter a Follower ID',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final followersUserID = textController.text;
                followersUserIDList.value = [
                  followersUserID,
                  ...List.from(followersUserIDList.value),
                ];
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
