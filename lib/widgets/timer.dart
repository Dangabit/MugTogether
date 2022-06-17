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

  Widget display() {
    return StatefulBuilder(builder: ((context, setState) {
      if (_started) {
        return Text("${totalTime} seconds left");
      } else {
        if (_ended) {
          return const Text("The timer has ended!");
        } else {
          return ElevatedButton(
            onPressed: () => setState(() {
              _started = true;
              _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                if (totalTime <= 0) {
                  setState(() {
                    _ended = true;
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

  void forceStop() {
    if (_timer != null) {
      _timer!.cancel();
    }
  }
}
