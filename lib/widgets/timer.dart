import 'dart:async';
import 'package:flutter/material.dart';

class TimerWidget {
  TimerWidget(
    this.totalTime,
  ) {
    totalTime *= 60;
  }

  int totalTime;
  bool _started = false;
  bool _ended = false;
  Timer? _timer;
  late DateTime _startTime;
  late DateTime _endTime;

  Widget display() {
    return StatefulBuilder(builder: ((context, setState) {
      if (_started) {
        return Text("$totalTime seconds left");
      } else {
        if (_ended) {
          return const Text("The timer has ended!");
        } else {
          return ElevatedButton(
            onPressed: () => setState(() {
              _started = true;
              _startTime = DateTime.now();
              _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                if (totalTime <= 0) {
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

  bool checkEnd() {
    return _ended;
  }

  void forceStop() {
    if (_timer != null) {
      _ended = true;
      _endTime = DateTime.now();
      _timer!.cancel();
    }
  }

  Map<String, dynamic> quizTime() {
    return {
      "StartTime": _startTime,
      "EndTime": _endTime,
    };
  }
}
