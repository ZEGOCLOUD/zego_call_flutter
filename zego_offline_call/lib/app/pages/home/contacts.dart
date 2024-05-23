// Flutter imports:
import 'package:flutter/cupertino.dart';

class ContactsTab extends StatefulWidget {
  const ContactsTab({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ContactsTabState();
}

class ContactsTabState extends State<ContactsTab> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Contacts'),
    );
  }
}
