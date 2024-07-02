// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

/// this is used to show the text when the ball is go off the screen.

class GameOver extends StatelessWidget {

  final bool isGameOver;
  final function;

  const GameOver({super.key, required this.isGameOver, this.function});

  @override
  Widget build(BuildContext context) {
    return isGameOver ?
    Stack(
        children: [
        Container(
            alignment: const Alignment(0, -0.2),
            child: const Text("G A M E O V E R",
                style: TextStyle(fontSize: 40,color: Colors.blue)
            )
        ),
        Container(
          alignment: const Alignment(0,0),
          child: GestureDetector(
            onTap: function,
            child: Container(
              alignment: const Alignment(0,0),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                      color: Colors.blue,
                      padding: const EdgeInsets.all(0.1),
                      child: const Text("play again",style: TextStyle(color: Colors.white),)
                  )
              ),
            ),
          ),
        )
        ],
      )
     : Container();
  }
}