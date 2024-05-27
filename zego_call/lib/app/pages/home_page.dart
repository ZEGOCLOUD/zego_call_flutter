// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// Project imports:
import 'package:zego_call/app/pages/home/contacts.dart';
import 'package:zego_call/app/pages/home/dialpad.dart';
import 'package:zego_call/app/pages/home/personal.dart';
import 'package:zego_call/app/pages/home/recents.dart';
import 'package:zego_call/call/service/service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final currentIndexNotifier = ValueNotifier<int>(0);

  final tabPages = [
    const RecentCallsTab(),
    const ContactsTab(),
    const DialPadTab(),
    const PersonalInfoTab(),
  ];
  final tabTitles = [
    'Recent',
    'Contacts',
    'DialPad',
    'Personal',
  ];
  int get recentTabIndex => 0;
  int get contactsTabIndex => 1;
  int get dialPadTabIndex => 2;
  int get personalInfoTabIndex => 2;

  @override
  void initState() {
    super.initState();

    currentIndexNotifier.value = dialPadTabIndex;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      ZegoCallService().checkHasPendingOfflineCall();
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
                  icon: const Icon(Icons.call),
                  label: tabTitles[recentTabIndex],
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.contacts),
                  label: tabTitles[contactsTabIndex],
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.dialpad),
                  label: tabTitles[dialPadTabIndex],
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.person),
                  label: tabTitles[dialPadTabIndex],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
