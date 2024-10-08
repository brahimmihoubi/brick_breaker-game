// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'dart:async';

import 'package:brick_breaker/ball.dart';
import 'package:brick_breaker/brick.dart';
import 'package:brick_breaker/coverscrenn.dart';
import 'package:brick_breaker/isgameover.dart';
import 'package:brick_breaker/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

///for direction of ball
// ignore: constant_identifier_names
enum direction { UP, DOWN, RIGHT, LEFT }

class _MyHomePageState extends State<MyHomePage> {
  ///for ball dimensions
  double ballx = 0;
  double bally = 0;
  double ballXincrements = 0.01;
  double ballYincrements = 0.01;
  var ballYdirection = direction.DOWN;
  var ballXdirection = direction.RIGHT;

  ///player width and height
  double playerx = -0.2;
  double playery = 0.4;

  ///for game uses.
  bool HasGameStarted = false;
  bool isGameOver = false;

  ///direction of ball
  ///var balldirection = direction.DOWN;

  ///for bricks
  static double firstbrickX = 0.01;
  static double firstbrickY = -0.9;
  static double brickHeigth = 0.05; // out of 2.
  static double brickWidth = 0.4; // out of 2.
  static double brickGap = 0.001; //mentions gap between the brick.
  static int n = 4;
  // ignore: unused_field
  static double wallgap = 0.5 * (2 - n * brickWidth - (n - 1 * brickGap));

  ///for multiple bricks
  List MyBricks = [
    //[brickx ,bricky ,hasbroken = either true or false]
    [firstbrickX, firstbrickY, false],
    [firstbrickX + 1 * (brickGap + brickWidth), firstbrickY, false],
    [firstbrickX + 2 * (brickGap + brickWidth), firstbrickY, false],
    [firstbrickX + 3 * (brickGap + brickWidth), firstbrickY, false],
  ];

  ///for moving right the tab.
  moveLeft() {
    ///if player reaches screen off then we should stop him
    setState(() {
      if (!(playerx - 0.07 < -1)) {
        playerx -= 0.07;
      }
    });
  }

  ///for moving left the tab.
  moveRight() {
    ///if player reaches screen off then we should stop him
    setState(() {
      if (!(playerx + playery >= 0.95)) {
        playerx += 0.07;
      }
    });
  }

  ///for starting the game
  game() {
    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        HasGameStarted = true;
      });

      ///for update the directions
      UpdateDirection();

      ///for movement of the ball
      moveBall();

      ///is player dead
      if (isPlayerDead()) {
        timer.cancel();
        isGameOver = true;
      }

      ///is brick is hited.
      checkBrickBroken();
    });
  }

  ///for check when ball is hited brick
  void checkBrickBroken() {
    for (int i = 0; i < MyBricks.length; i++) {
      if (ballx >= MyBricks[i][0] &&
          ballx <= MyBricks[i][0] + brickWidth &&
          bally <= MyBricks[i][1] + brickHeigth &&
          MyBricks[i][2] == false) {
        setState(() {
          MyBricks[i][2] = true;

          ///to move the ball in all directions.
          double leftSideDist = (MyBricks[i][0] - ballx).abs();
          double rightSideDist = (MyBricks[i][0] + brickWidth - ballx).abs();
          double topSideDist = (MyBricks[i][1] - bally).abs();
          double bottomSideDist = (MyBricks[i][1] + brickHeigth - bally).abs();

          String min =
              findMin(leftSideDist, rightSideDist, topSideDist, bottomSideDist);

          switch (min) {
            case 'left':
              ballXdirection = direction.LEFT;
              break;
            case 'right':
              ballXdirection = direction.RIGHT;
              break;
            case 'up':
              ballYdirection = direction.UP;
              break;
            case 'down':
              ballYdirection = direction.DOWN;
              break;
          }
        });
      }
    }
  }

  String findMin(double a, double b, double c, double d) {
    List<double> myList = [a, b, c, d];

    double currentMin = a;
    for (int i = 0; i < myList.length; i++) {
      if (myList[i] < currentMin) {
        currentMin = myList[i];
      }
    }
    if ((currentMin - a).abs() < 0.01) {
      return 'left';
    } else if ((currentMin - b).abs() < 0.01) {
      return 'right';
    } else if ((currentMin - c).abs() < 0.01) {
      return 'up';
    } else if ((currentMin - d).abs() < 0.01) {
      return 'down';
    }

    return '';
  }

  ///for checking player is dead
  isPlayerDead() {
    if (bally >= 1) {
      return true;
    }

    return false;
  }

  ///for movement of ball..
  moveBall() {
    /// move verticaly.
    setState(() {
      if (ballYdirection == direction.DOWN) {
        bally += ballYincrements;
      } else if (ballYdirection == direction.UP) {
        bally -= ballYincrements;
      }

      ///move horizontly.
      if (ballXdirection == direction.LEFT) {
        ballx -= ballXincrements;
      } else if (ballXdirection == direction.RIGHT) {
        ballx += ballXincrements;
      }
    });
  }

  ///for update direction at every time..
  UpdateDirection() {
    setState(() {
      /// for ball when it hits bottom layer
      if (bally >= 0.9 && ballx >= playerx && ballx <= playerx + playery) {
        ballYdirection = direction.UP;
      }

      /// for ball when it hits upper layer
      else if (bally <= -1) {
        ballYdirection = direction.DOWN;
      }

      /// for ball when it hits right layer
      if (ballx <= -1) {
        ballXdirection = direction.RIGHT;
      }

      ///for ball when it hits left layer
      else if (ballx >= 1) {
        ballXdirection = direction.LEFT;
      }
    });
  }

  //for restart the game..
  restart() {
    setState(() {
      ballx = 0;
      bally = 0;
      playerx = -0.2;
      HasGameStarted = false;
      isGameOver = false;

      MyBricks = [
        //[brickx ,bricky ,hasbroken = either true or false]
        [firstbrickX, firstbrickY, false],
        [firstbrickX + 1 * (brickGap + brickWidth), firstbrickY, false],
        [firstbrickX + 2 * (brickGap + brickWidth), firstbrickY, false]
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKeyEvent: (event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.arrowLeft) {
          moveLeft();
        } else if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.arrowRight) {
          moveRight();
        }
      },
      child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          int sensitivity = 1;
          if (details.delta.dx > sensitivity / 20) {
            moveRight();
          } else if (details.delta.dx < sensitivity / 20) {
            moveLeft();
          }
        },
        onTap: game,
        child: Scaffold(
          backgroundColor: Colors.blue[100],
          /*appBar: AppBar(
            title: Text(widget.title),
          ),*/
          body: Center(
            child: Stack(
              children: <Widget>[
                ///this is used for show "tap to start" ..
                CoverScreen(hasgamestarted: HasGameStarted),

                ///this is used to show the ball..
                Ball(
                  ballx: ballx,
                  bally: bally,
                ),

                ///this is used to show the bottom tab ..
                Player(
                  playerx: playerx,
                  playery: playery,
                ),

                ///this widget is used to show "game over" ..
                GameOver(isGameOver: isGameOver, function: restart),

                ///for bricks

                Bricks(
                  brickX: MyBricks[0][0],
                  brickY: MyBricks[0][1],
                  isBrickBroken: MyBricks[0][2],
                  brickHeight: brickHeigth,
                  brickWidth: brickWidth,
                ),

                Bricks(
                  brickX: MyBricks[1][0],
                  brickY: MyBricks[1][1],
                  isBrickBroken: MyBricks[1][2],
                  brickHeight: brickHeigth,
                  brickWidth: brickWidth,
                ),

                Bricks(
                  brickX: MyBricks[2][0],
                  brickY: MyBricks[2][1],
                  isBrickBroken: MyBricks[2][2],
                  brickHeight: brickHeigth,
                  brickWidth: brickWidth,
                ),
              ],
            ),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        ),
      ),
    );
  }
}
