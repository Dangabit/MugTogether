import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mug_together/widgets/timer.dart';

class QuizAttempt extends StatefulWidget {
  const QuizAttempt(
      {Key? key,
      required this.totalQns,
      required this.modName,
      required this.timerCheck,
      required this.countdown})
      : super(key: key);

  final int totalQns;
  final String modName;
  final bool timerCheck;
  final int countdown;

  @override
  State<QuizAttempt> createState() => _QuizAttempt();
}

class _QuizAttempt extends State<QuizAttempt> {
  // Variables Initialisation
  late TimerWidget _timer;
  late List<TextEditingController> _attemptsArray;
  int currentQn = 0;
  FirebaseFirestore db = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  late List<Widget> _buttonsArray;
  late Future<List> _future;

  @override
  void initState() {
    super.initState();
    // Creates a timer if needed
    if (widget.timerCheck) {
      _timer = TimerWidget(widget.countdown);
    }
    // Creates arrays based on the number of qns wanted
    _attemptsArray =
        List.generate(widget.totalQns, (index) => TextEditingController());
    _buttonsArray = List.generate(
        widget.totalQns,
        (index) => ElevatedButton(
            onPressed: (() {
              setState(() {
                currentQn = index;
              });
            }),
            child: Text(index.toString())));
    // Create a one-time future
    _future = _grabQns();
  }

  @override
  void dispose() {
    // Closing everything to prevent memory leaks
    if (widget.timerCheck) {
      _timer.forceStop();
    }
    for (TextEditingController controller in _attemptsArray) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => Navigator.pop(context)),
        title: const Text("Quiz Attempt"),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _future,
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              // Not enough questions widget
              return const Text(
                  "There is not enough questions in our bank, sorry :C");
            } else {
              // Create a quiz layout
              return Center(
                child: Column(
                  children: <Widget>[
                    widget.timerCheck ? _timer.display() : const Text(""),
                    _questionBody(snapshot.data!),
                    Row(children: _buttonsArray),
                    ElevatedButton(
                        onPressed: _submit, child: const Text("Finish Quiz")),
                  ],
                ),
              );
            }
          } else {
            // If future not loaded, put loading screen
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }

  /// Show the particular question
  Widget _questionBody(List<dynamic> _qnsArray) {
    return Column(
      children: <Widget>[
        Text(_qnsArray[currentQn]),
        TextField(
          controller: _attemptsArray[currentQn],
        ),
      ],
    );
  }

  /// Grab a random list of questions from the database
  Future<List<dynamic>> _grabQns() async {
    return db
        .collectionGroup("questions")
        .where("Module", isEqualTo: widget.modName)
        .where("Owner", isNotEqualTo: user!.uid)
        .where("Privacy", isEqualTo: false)
        .get()
        .then((snapshot) {
      if (snapshot.size < widget.totalQns) {
        return List.empty();
      } else {
        List<QueryDocumentSnapshot> docsList = snapshot.docs;
        docsList.shuffle();
        return docsList
            .sublist(0, widget.totalQns)
            .map((e) => e.get("Question"))
            .toList();
      }
    });
  }

  /// Submitting of the attempt
  void _submit() {
    _future.then((qnsList) {
      db.collection(user!.uid).doc("Quiz Attempts").get().then((doc) {
        List attempts = doc.get("AttemptList") as List;
        Map attempt = {
          "Questions": qnsList,
          "Attempts": _attemptsArray.map((e) => e.text).toList(),
          "Module": widget.modName,
          "Date": DateTime.now().toString(),
        };
        if (widget.timerCheck) {
          if (!_timer.checkEnd()) {
            _timer.forceStop();
          }
          attempt.addAll(_timer.quizTime());
        }
        attempts.add(attempt);
        db
            .collection(user!.uid)
            .doc("Quiz Attempts")
            .update({"AttemptList": attempts});
      }).then((_) => Navigator.pop(context));
    });
  }
}
