import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mug_together/screens/quiz_attempt.dart';
import 'package:mug_together/widgets/data.dart';
import 'package:mug_together/widgets/in_app_drawer.dart';
import 'package:mug_together/widgets/module_list.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<QuizPage> createState() => _QuizPage();
}

class _QuizPage extends State<QuizPage> {
  // Variable initialisation
  final user = FirebaseAuth.instance.currentUser;
  final Data _currentMod = Data();
  double _noOfQns = 1;
  bool _timerCheck = false;
  double _countdown = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quiz")),
      drawer: InAppDrawer.gibDrawer(context, widget.user),
      body: _buildForm(),
    );
  }

  /// Build the required form to receive all the needed info
  Widget _buildForm() {
    return Column(
      children: <Widget>[
        // Get number of questions, 1 - 10
        Slider(
          value: _noOfQns,
          max: 10,
          min: 1,
          divisions: 9,
          label: _noOfQns.round().toString(),
          onChanged: (value) {
            setState(() {
              _noOfQns = value;
            });
          },
        ),
        // Get the module choice
        ModuleList.createListing(_currentMod),
        // Check if the user wants a timer
        Checkbox(
          value: _timerCheck,
          onChanged: (value) {
            setState(() {
              _timerCheck = value!;
            });
          },
        ),
        // If the user wants a timer, choose how long (10 - 60 min)
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
        // Start the quiz
        ElevatedButton(
          onPressed: _submit,
          child: const Text("Start quiz!"),
        ),
        // View past quiz attempts
        ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, "/quiz/past"),
          child: const Text("Past records"),
        ),
      ],
    );
  }

  /// Push the information needed into the next screen
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
