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
    if (widget.timerCheck) {
      _timer = TimerWidget(widget.countdown);
    }
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
    _future = _grabQns();
  }

  @override
  void dispose() {
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
              return const Text(
                  "There is not enough questions in our bank, sorry :C");
            } else {
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
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }

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

  void _submit() {}
}
