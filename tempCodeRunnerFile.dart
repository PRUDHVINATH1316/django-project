import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Balloon Pop Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BalloonPopGame(),
    );
  }
}

class BalloonPopGame extends StatefulWidget {
  @override
  _BalloonPopGameState createState() => _BalloonPopGameState();
}

class _BalloonPopGameState extends State<BalloonPopGame> {
  int score = 0;
  int missed = 0;
  int timeLeft = 120;
  List<Offset> balloons = [];

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        timeLeft--;
        if (timeLeft <= 0) {
          timer.cancel();
          showGameOverDialog();
        } else {
          spawnBalloon();
        }
      });
    });
  }

  void spawnBalloon() {
    Random random = Random();
    double position = random.nextDouble() * MediaQuery.of(context).size.width;
    balloons.add(Offset(position, MediaQuery.of(context).size.height));
  }

  void popBalloon(int index) {
    setState(() {
      balloons.removeAt(index);
      score += 2;
    });
  }

  void missBalloon(int index) {
    setState(() {
      balloons.removeAt(index);
      missed++;
    });
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Text('Final Score: $score\nBalloons Missed: $missed'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  score = 0;
                  missed = 0;
                  timeLeft = 120;
                  balloons.clear();
                });
                startGame();
              },
              child: Text('Play Again'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Balloon Pop Game'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Time Left: ${(timeLeft / 60).floor().toString().padLeft(2, '0')}:${(timeLeft % 60).toString().padLeft(2, '0')}',
            style: TextStyle(fontSize: 24),
          ),
          Text(
            'Score: $score',
            style: TextStyle(fontSize: 24),
          ),
          Expanded(
            child: Stack(
              children: <Widget>[
                for (int i = 0; i < balloons.length; i++)
                  GestureDetector(
                    onTap: () => popBalloon(i),
                    child: Balloon(balloons[i]),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Balloon extends StatelessWidget {
  final Offset position;

  Balloon(this.position);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx - 25,
      top: position.dy - 50,
      child: Image.asset(
        'assets/images/balloon.png',
        width: 50,
        height: 100,
        fit: BoxFit.fill,
      ),
    );
  }
}
