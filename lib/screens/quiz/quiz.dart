import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mug_together/screens/quiz/quiz_attempt.dart';
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
  late final TextEditingController codeController;
  late bool _fail;

  @override
  void initState() {
    super.initState();
    codeController = TextEditingController();
    _fail = false;
  }

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 222, 255),
      appBar: AppBar(
        title: const Text("Quiz"),
        backgroundColor: Colors.deepPurple,
      ),
      drawer: InAppDrawer.gibDrawer(context, widget.user),
      body: _buildForm(),
    );
  }

  /// Build the required form to receive all the needed info
  Widget _buildForm() {
    final currentScreenWidth = MediaQuery.of(context).size.width;
    final currentScreenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: currentScreenHeight * 0.03,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Get the module choice
              ModuleList.createListing(_currentMod),
              SizedBox(
                width: currentScreenWidth * 0.03,
              ),
              // Check if the user wants a timer
              const Text(
                "Enable timer? ",
                style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Checkbox(
                value: _timerCheck,
                activeColor: Colors.deepPurple,
                splashRadius: 20.0,
                onChanged: (value) {
                  setState(() {
                    _timerCheck = value!;
                  });
                },
              ),
            ],
          ),
          SizedBox(
            height: currentScreenHeight * 0.05,
          ),
          Wrap(
            children: const [
              Text(
                "Choose a number of questions (1 - 10)",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          // Get number of questions, 1 - 10
          SizedBox(
            width: currentScreenWidth < 500
                ? currentScreenWidth
                : currentScreenWidth < 1000
                    ? currentScreenWidth * 0.8
                    : currentScreenWidth * 0.6,
            child: Slider(
              activeColor: Colors.deepPurple,
              inactiveColor: Colors.purple[100],
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
          ),
          SizedBox(
            height: currentScreenHeight * 0.03,
          ),
          // If the user wants a timer, choose how long (10 - 60 min)
          _timerCheck
              ? Column(
                  children: [
                    const Text(
                      "Select a time duration",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: currentScreenWidth < 500
                          ? currentScreenWidth
                          : currentScreenWidth < 1000
                              ? currentScreenWidth * 0.8
                              : currentScreenWidth * 0.6,
                      child: Slider(
                          activeColor: Colors.deepPurple,
                          inactiveColor: Colors.purple[100],
                          value: _countdown,
                          min: 10,
                          max: 60,
                          divisions: 10,
                          label: _countdown.round().toString() + " min",
                          onChanged: (value) {
                            setState(() {
                              _countdown = value;
                            });
                          }),
                    ),
                  ],
                )
              : const Text(""),
          SizedBox(
            height: currentScreenHeight * 0.3,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // View past quiz attempts
              ElevatedButton(
                key: const Key("pastquizButton"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurple,
                ),
                onPressed: () => Navigator.pushNamed(context, "/quiz/past"),
                child: const Text(
                  "Past records",
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                width: 100.0,
              ),
              // Start the quiz
              ElevatedButton(
                key: const Key("startQuizButton"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurple,
                ),
                onPressed: _submit,
                child: const Text(
                  "Start quiz!",
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 50,
            width: 140,
            margin: const EdgeInsets.only(left: 255.0),
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: TextField(
              controller: codeController,
              decoration: InputDecoration(
                hintText: "Input code (if any)",
                errorText: _fail ? "Invalid code" : null,
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }

  /// Push the information needed into the next screen
  void _submit() {
    if (_currentMod.text != null) {
      if (codeController.text.trim().isEmpty) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => QuizAttempt(
                    totalQns: _noOfQns.toInt(),
                    modName: _currentMod.text!,
                    timerCheck: _timerCheck,
                    countdown: _countdown.toInt())));
      } else {
        final data = codeController.text.split(":");
        FirebaseFirestore.instance
            .collection(data.first)
            .doc("Quiz Attempts")
            .get()
            .then((doc) {
              return (doc.get("AttemptList") as List)[int.parse(data.last)];
            })
            .then(
              (attemptData) => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizAttempt(
                      totalQns: attemptData["Questions"].length,
                      modName: attemptData["Module"],
                      timerCheck: _timerCheck,
                      countdown: _countdown.toInt(),
                      qnsList: attemptData["Questions"]),
                ),
              ),
            )
            .onError((error, stackTrace) {
              setState(() {
                _fail = true;
              });
            });
      }
    }
  }
}
