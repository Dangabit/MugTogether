import 'dart:async';
import 'package:flutter/material.dart';

class TimerWidget {
  TimerWidget(
    this.totalTime,
  ) {
    totalTime *= 60;
  }

  int totalTime;
  bool started = false;
  Timer? _timer;

  Widget display() {
    return StatefulBuilder(builder: ((context, setState) {
      if (started) {
        return Text("${totalTime} seconds left");
      } else {
        return ElevatedButton(
          onPressed: () => setState(() {
            started = true;
            _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
              if (totalTime <= 0) {
                setState(() {
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
    }));
  }

  void forceStop() {
    if (_timer != null) {
      _timer!.cancel();
    }
  }
}
