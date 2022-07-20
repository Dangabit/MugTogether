import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:mug_together/models/question.dart';

class IndividualAttempt extends StatefulWidget {
  const IndividualAttempt(
      {Key? key,
      required this.attempt,
      required this.attemptNum,
      required this.user})
      : super(key: key);
  final Map<String, dynamic> attempt;
  final int attemptNum;
  final User user;

  @override
  State<IndividualAttempt> createState() => _IndividualAttempt();
}

class _IndividualAttempt extends State<IndividualAttempt> {
  // Variables Initialisation
  int currentIndex = 0;
  late List<bool> added;
  late bool timerInfo;

  @override
  void initState() {
    super.initState();
    added = List.generate(widget.attempt["Questions"].length, (index) => false);
    timerInfo = widget.attempt.containsKey("StartTime");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 222, 255),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        leading: BackButton(onPressed: () => Navigator.pop(context)),
        title: Text("Attempt " +
            widget.attemptNum.toString() +
            "  (" +
            widget.attempt["Module"] +
            ")"),
      ),
      body: LayoutBuilder(builder: (context, constraint) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraint.maxHeight),
            child: IntrinsicHeight(
              child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 15.0,
                    ),
                    const Text(
                      "Question Number:  ",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    _qnNum(),
                  ],
                ),
                const SizedBox(
                  height: 30.0,
                ),
                _questionBody(),
                const Spacer(),
                const SizedBox(
                  height: 40.0,
                ),

                /// Add to MyQuestions
                added[currentIndex]
                    ? const Text(
                        "Qn added!",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          // Pulling of questions into the user collection
                          style: ElevatedButton.styleFrom(
                            primary: Colors.deepPurple,
                          ),
                          onPressed: () {
                            Question(<String, dynamic>{
                              "Question": widget.attempt["Questions"]
                                  [currentIndex],
                              "Notes": widget.attempt["Attempts"][currentIndex],
                              "Module": widget.attempt["Module"],
                              "LastUpdate": widget.attempt["Date"],
                              "Tags": List.empty(),
                              "Importance": 0,
                              "Privacy": true,
                              "Owner": widget.user.uid,
                              "FromCommunity": true,
                            }, widget.user.uid, widget.attempt["Module"])
                                .pullToUser(widget.user.uid)
                                .then((_) => setState(() {
                                      added[currentIndex] = true;
                                    }));
                          },
                          child: const Text(
                            "Add to MyQuestions",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                const SizedBox(
                  height: 30.0,
                ),
                timerInfo ? _timerInfo() : const Text(""),
                const SizedBox(
                  height: 20.0,
                ),
              ]),
            ),
          ),
        );
      }),
    );
  }

  /// Display timer info if the attempt uses a timer
  Widget _timerInfo() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Start: "),
            Text(widget.attempt["StartTime"]
                .toDate()
                .toString()
                .substring(0, 19)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("End: "),
            Text(
                widget.attempt["EndTime"].toDate().toString().substring(0, 19)),
          ],
        )
      ],
    );
  }

  /// Display a dropdrop menu to move between questions
  Widget _qnNum() {
    return Container(
      height: 40.0,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButtonHideUnderline(
          child: DropdownButton2<int>(
              value: currentIndex,
              dropdownOverButton: true,
              dropdownMaxHeight: 300,
              offset: const Offset(0, -40),
              items: List<DropdownMenuItem<int>>.generate(
                widget.attempt["Questions"].length,
                (index) => DropdownMenuItem(
                  child: Text("${index + 1}"),
                  value: index,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  currentIndex = value!;
                });
              }),
        ),
      ),
    );
  }

  /// Show the individual question
  Widget _questionBody() {
    return Column(
      children: <Widget>[
        const Align(
          alignment: Alignment.topCenter,
          child: Text(
            "Question:",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(
          height: 5.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 45.0),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 10.0,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(),
            ),
            child: Center(
              child: Wrap(
                runSpacing: 5.0,
                spacing: 5.0,
                children: [
                  Text(
                    widget.attempt["Questions"][currentIndex],
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 30.0,
        ),
        const Align(
          alignment: Alignment.topCenter,
          child: Text(
            "Your Answer:",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(
          height: 5.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 45.0),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 10.0,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(),
            ),
            child: Center(
              child: Wrap(
                runSpacing: 5.0,
                spacing: 5.0,
                children: [
                  Text(
                    widget.attempt["Attempts"][currentIndex],
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
