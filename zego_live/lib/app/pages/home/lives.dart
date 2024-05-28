// Flutter imports:
import 'dart:math';

import 'package:flutter/material.dart';

class LivesTab extends StatefulWidget {
  const LivesTab({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LivesTabState();
}

class LivesTabState extends State<LivesTab> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
              child: Text('Lives'),
            ),
            Expanded(
              child: hostList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget hostList() {
    final screenSize = MediaQuery.of(context).size;

    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: (screenSize.width / 3) / (screenSize.height / 4),
      children: List.generate(8, (index) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black),
            ),
            child: Center(
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Icon(
                      Icons.person,
                      size: screenSize.width / 4,
                      color: Colors.white,
                    ),
                  ),
                  Positioned(
                    bottom: 2,
                    left: 10,
                    child: Text(
                      'Host $index',
                      style: const TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 2,
                    right: 10,
                    child: Text(
                      '${Random().nextInt(10000) + 1000}',
                      style: const TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
