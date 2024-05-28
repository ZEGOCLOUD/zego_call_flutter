// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// Project imports:
import 'package:zego_live/app/pages/home/group.dart';
import 'package:zego_live/app/pages/home/home.dart';
import 'package:zego_live/app/pages/home/personal.dart';
import 'package:zego_live/app/pages/home/lives.dart';
import 'package:zego_live/live/service/service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final currentIndexNotifier = ValueNotifier<int>(0);

  final tabPages = [
    const HomeTab(),
    const LivesTab(),
    const GroupTab(),
    const PersonalInfoTab(),
  ];
  final tabTitles = [
    'Home',
    'Lives',
    'Group',
    'Personal',
  ];
  int get homeTabIndex => 0;
  int get livesTabIndex => 1;
  int get groupTabIndex => 2;
  int get personalInfoTabIndex => 3;

  @override
  void initState() {
    super.initState();

    currentIndexNotifier.value = livesTabIndex;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      ZegoLiveService().checkHasPendingOfflineLive();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: currentIndexNotifier,
      builder: (context, currentIndex, _) {
        return Scaffold(
          body: tabPages[currentIndex],
          bottomNavigationBar: BottomNavigationBarTheme(
            data: const BottomNavigationBarThemeData(
              selectedItemColor: Colors.blue,
              selectedLabelStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              unselectedItemColor: Colors.grey,
              unselectedLabelStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: (index) {
                currentIndexNotifier.value = index;
              },
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home),
                  label: tabTitles[homeTabIndex],
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.live_tv),
                  label: tabTitles[livesTabIndex],
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.group),
                  label: tabTitles[groupTabIndex],
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.person),
                  label: tabTitles[personalInfoTabIndex],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
