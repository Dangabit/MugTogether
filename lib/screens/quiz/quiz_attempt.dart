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
      required this.countdown,
      this.qnsList})
      : super(key: key);

  final int totalQns;
  final String modName;
  final bool timerCheck;
  final int countdown;
  final List? qnsList;

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
  late String _errorText;
  late int bankModSize;

  @override
  void initState() {
    super.initState();
    _errorText = "";
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
        style: ElevatedButton.styleFrom(
          primary: Colors.deepPurple,
          shape: const CircleBorder(),
        ),
        onPressed: (() {
          setState(() {
            currentQn = index;
          });
        }),
        child: Text(
          (index + 1).toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
    // Create a one-time future
    if (widget.qnsList != null) {
      _future = Future(() => widget.qnsList!);
    } else {
      _future = _grabQns();
    }
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
    final currentScreenWidth = MediaQuery.of(context).size.width;
    final currentScreenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 222, 255),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        leading: BackButton(
            onPressed: () => Navigator.popAndPushNamed(context, '/quiz')),
        centerTitle: false,
        titleSpacing: 0,
        title: currentScreenWidth < 400
            ? Text(
                widget.modName,
              )
            : Text(
                "Quiz Attempt (" + widget.modName + ")",
              ),
        actions: [
          widget.timerCheck ? _timer.display() : const Text(""),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _future,
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              // Not enough questions widget
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      bankModSize == 0
                          ? "There are no questions available in our bank for this module."
                          : bankModSize == 1
                              ? "There is only 1 question in our bank for this module."
                              : "There are only " +
                                  bankModSize.toString() +
                                  " questions in our bank for this module.",
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Center(
                    child: Text(
                      bankModSize == 0 || bankModSize == 1
                          ? "Try choosing from another module."
                          : "Try setting fewer questions or choose from another "
                              "module.",
                    ),
                  ),
                ],
              );
            } else {
              // Create a quiz layout
              return LayoutBuilder(builder: (context, constraint) {
                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraint.maxHeight),
                    child: IntrinsicHeight(
                      child: Center(
                        child: SizedBox(
                          width: currentScreenWidth < 500
                              ? currentScreenWidth
                              : currentScreenWidth < 1000
                                  ? currentScreenWidth * 0.8
                                  : currentScreenWidth * 0.6,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              SizedBox(
                                height: currentScreenHeight * 0.03,
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                physics: const ClampingScrollPhysics(),
                                child: Row(
                                  children: _buttonsArray,
                                ),
                              ),
                              SizedBox(
                                height: currentScreenHeight * 0.03,
                              ),
                              _questionBody(snapshot.data!),
                              const Spacer(),
                              ElevatedButton(
                                key: const Key("finishQuizButton"),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.deepPurple,
                                ),
                                onPressed: _submit,
                                child: const Text(
                                  "Finish Quiz",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              });
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
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
            ),
            child: Wrap(
              children: [
                Text(
                  "Question " + (currentQn + 1).toString() + ":  ",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _qnsArray[currentQn],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 8.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 5),
              child: TextFormField(
                controller: _attemptsArray[currentQn],
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 30),
                  border: InputBorder.none,
                  hintText: 'Input your answer (Multiline)',
                  errorText: _errorText,
                  prefixIcon: const Icon(
                    Icons.edit_note_outlined,
                    color: Colors.deepPurple,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
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
        bankModSize = snapshot.size;
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
    for (TextEditingController controller in _attemptsArray) {
      if (controller.text.isEmpty) {
        setState(() {
          _errorText = "Quiz is incomplete";
        });
        return;
      }
    }
    _future.then((qnsList) {
      db.collection(user!.uid).doc("Quiz Attempts").get().then((doc) {
        List attempts = doc.get("AttemptList") as List;
        Map attempt = {
          "Questions": qnsList,
          "Attempts": _attemptsArray.map((e) => e.text).toList(),
          "Module": widget.modName,
          "Date": DateTime.now().toString().substring(0, 19),
        };
        if (widget.timerCheck) {
          if (_timer.checkState() < 2) {
            if (_timer.checkState() == 1) {
              _timer.forceStop();
            }
            attempt.addAll(_timer.quizTime());
          }
        }
        attempts.add(attempt);
        db
            .collection(user!.uid)
            .doc("Quiz Attempts")
            .update({"AttemptList": attempts});
      }).then((_) => Navigator.popAndPushNamed(context, '/quiz'));
    });
  }
}
