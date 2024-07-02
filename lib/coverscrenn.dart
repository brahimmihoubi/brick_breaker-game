import 'package:flutter/material.dart';

///this is used to show the text 'tap to play'.

class CoverScreen extends StatelessWidget {
  final bool hasgamestarted;

  const CoverScreen({super.key, required this.hasgamestarted});

  @override
  Widget build(BuildContext context) {
    return hasgamestarted
        ? Container()
        : Container(
            alignment: const Alignment(0, -0.2),
            child: const Text(
              "Tap to play",
              style: TextStyle(color: Colors.blue, fontSize: 20),
            ));
  }
}
