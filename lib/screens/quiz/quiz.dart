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
  late bool _validate;
  late bool _fail;

  @override
  void initState() {
    super.initState();
    codeController = TextEditingController();
    _validate = false;
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
    return Column(
      children: <Widget>[
        const SizedBox(
          height: 30.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Get the module choice
            ModuleList.createListing(_currentMod),
            const SizedBox(
              width: 40.0,
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
        const SizedBox(
          height: 40.0,
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
        Slider(
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
        const SizedBox(
          height: 30.0,
        ),
        // If the user wants a timer, choose how long (10 - 60 min)
        _timerCheck
            ? Column(
                children: [
                  const Text(
                    "Select a time duration",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Slider(
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
                ],
              )
            : const Text(""),
        const Spacer(),
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
        const SizedBox(
          height: 20.0,
        ),
      ],
    );
  }

  /// Push the information needed into the next screen
  void _submit() {
    if (_currentMod.text != null) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              insetPadding: const EdgeInsets.symmetric(),
              scrollable: true,
              content: Column(children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  child: TextField(
                    controller: codeController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Input code (if any)",
                      errorText: _validate
                          ? "Code cannot be empty"
                          : _fail
                              ? "Invalid code"
                              : null,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Row(
                  children: [
                    ElevatedButton(
                      child: const Text("Continue without code"),
                      onPressed: (() => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QuizAttempt(
                                  totalQns: _noOfQns.toInt(),
                                  modName: _currentMod.text!,
                                  timerCheck: _timerCheck,
                                  countdown: _countdown.toInt())))),
                    ),
                    const SizedBox(
                      width: 30.0,
                    ),
                    ElevatedButton(
                      child: const Text("Continue with code"),
                      onPressed: (() {
                        setState(() {
                          _validate = codeController.text.trim().isEmpty;
                        });
                        if (!_validate) {
                          final data = codeController.text.split(":");
                          FirebaseFirestore.instance
                              .collection(data.first)
                              .doc("Quiz Attempts")
                              .get()
                              .then((doc) {
                                return (doc.get("AttemptList")
                                    as List)[int.parse(data.last)];
                              })
                              .then(
                                (attemptData) => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => QuizAttempt(
                                        totalQns:
                                            attemptData["Questions"].length,
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
                      }),
                    ),
                  ],
                )
              ]),
            );
          });
    }
  }
}
