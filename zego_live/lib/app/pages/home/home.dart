// Flutter imports:
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zego_live/app/constants.dart';
import 'package:zego_live/live/prebuilt_live_route.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomeTabState();
}

class HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Here, \n'
                  'follower will be notified with offline notification when host go LIVE,  \n'
                  'so you need click `Add A Follower` on the `personal tab` to '
                  'add the follower who need to be notified.',
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: screenSize.width / 2,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.5),
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      startLivePage(
                        'live_${currentUser.id}',
                        followersUserIDList.value
                            .where((e) => !e.startsWith('f'))
                            .toList(),
                      );
                    },
                    child: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Start Live',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        )),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
