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
        return Text("$totalTime seconds left");
      } else {
        if (_ended) {
          return const Text("The timer has ended!");
        } else {
          return ElevatedButton(
            // Function that starts and runs the timer. With a callback when
            // the timer ends
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
            child: const Text("Start the time!"),
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
