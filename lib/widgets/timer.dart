import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class TimerWidget {
  /// Creates a timer that comes with a display
  TimerWidget(
    this.totalTime,
  ) {
    totalTime *= 60;
    _audioPlayer = AudioPlayer();
    _audioPlayer.setSourceAsset("audio/timer.wav");
  }

  // Variables Initialisation
  int totalTime;
  bool _started = false;
  bool _ended = false;
  Timer? _timer;
  late AudioPlayer _audioPlayer;
  late DateTime _startTime;
  late DateTime _endTime;

  /// Creates a widget to display in other screens
  Widget display() {
    return StatefulBuilder(builder: ((context, setState) {
      if (_started) {
        return Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 2.0,
            vertical: 5.0,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 5.0,
          ),
          decoration: BoxDecoration(
            color: Colors.blue[800],
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Center(
            child: Text(
              "Time left: $totalTime s",
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      } else {
        if (_ended) {
          return const Text("The timer has ended!");
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 2.0,
              vertical: 5.0,
            ),
            child: ElevatedButton(
              // Function that starts and runs the timer. With a callback when
              // the timer ends
              style: ElevatedButton.styleFrom(
                primary: Colors.blue[800],
                padding: const EdgeInsets.symmetric(
                  horizontal: 7.0,
                ),
              ),
              child: Row(
                children: const [
                  Icon(Icons.timer_outlined),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                  ),
                  Text(
                    'Start timer',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              onPressed: () => setState(() {
                _started = true;
                _startTime = DateTime.now();
                _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                  if (totalTime <= 0) {
                    _audioPlayer.resume();
                    setState(() {
                      _ended = true;
                      _endTime = DateTime.now();
                      _timer!.cancel();
                    });
                  } else {
                    setState(() {
                      totalTime--;
                    });
                  }
                });
              }),
            ),
          );
        }
      }
    }));
  }

  /// Check if the timer has ended
  bool checkEnd() {
    return _ended;
  }

  /// Force the timer to stop
  void forceStop() {
    if (_timer != null) {
      _ended = true;
      _endTime = DateTime.now();
      _timer!.cancel();
    }
  }

  /// Retrieve data on the start and end time
  Map<String, dynamic> quizTime() {
    return {
      "StartTime": _startTime,
      "EndTime": _endTime,
    };
  }
}
