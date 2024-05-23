// Flutter imports:
import 'package:flutter/cupertino.dart';

class RecentCallsTab extends StatefulWidget {
  const RecentCallsTab({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => RecentCallsTabState();
}

class RecentCallsTabState extends State<RecentCallsTab> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Recents'),
    );
  }
}
