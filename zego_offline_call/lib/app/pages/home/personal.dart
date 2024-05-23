// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:zego_offline_call/app/constants.dart';
import 'package:zego_offline_call/app/login_service.dart';
import 'package:zego_offline_call/app/pages/defines.dart';

class PersonalInfoTab extends StatefulWidget {
  const PersonalInfoTab({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PersonalInfoTabState();
}

class PersonalInfoTabState extends State<PersonalInfoTab> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Expanded(child: Container()),
          Text('User ID: ${currentUser.id}'),
          const SizedBox(height: 100),
          logoutButton(),
          Expanded(child: Container()),
        ],
      ),
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
}
