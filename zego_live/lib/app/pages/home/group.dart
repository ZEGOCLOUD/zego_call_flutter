// Flutter imports:
import 'package:flutter/cupertino.dart';

class GroupTab extends StatefulWidget {
  const GroupTab({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => GroupTabState();
}

class GroupTabState extends State<GroupTab> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Group'),
    );
  }
}
