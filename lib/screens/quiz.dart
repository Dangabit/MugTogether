import 'package:flutter/material.dart';
import 'package:mug_together/screens/quiz_attempt.dart';
import 'package:mug_together/widgets/data.dart';
import 'package:mug_together/widgets/in_app_drawer.dart';
import 'package:mug_together/widgets/module_list.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPage();
}

class _QuizPage extends State<QuizPage> {
  final Data _currentMod = Data();
  double _noOfQns = 0;
  bool _timerCheck = false;
  double _countdown = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quiz")),
      drawer: InAppDrawer.gibDrawer(context),
      body: _buildForm(),
    );
  }

  Widget _buildForm() {
    return Column(
      children: <Widget>[
        Slider(
          value: _noOfQns,
          max: 10,
          divisions: 10,
          label: _noOfQns.round().toString(),
          onChanged: (value) {
            setState(() {
              _noOfQns = value;
            });
          },
        ),
        ModuleList.createListing(_currentMod),
        Checkbox(
          value: _timerCheck,
          onChanged: (value) {
            setState(() {
              _timerCheck = value!;
            });
          },
        ),
        _timerCheck
            ? Slider(
                value: _countdown,
                min: 10,
                max: 60,
                divisions: 10,
                label: _countdown.round().toString() + " min",
                onChanged: (value) {
                  setState(() {
                    _countdown = value;
                  });
                })
            : const Text(""),
        ElevatedButton(
          onPressed: _submit,
          child: const Text("Start quiz!"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, "/quiz/past"),
          child: const Text("Past records"),
        ),
      ],
    );
  }

  void _submit() {
    if (_currentMod.text != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => QuizAttempt(
                  totalQns: _noOfQns.toInt(),
                  modName: _currentMod.text!,
                  timerCheck: _timerCheck,
                  countdown: _countdown.toInt())));
    }
  }
}
