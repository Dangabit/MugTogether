import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mug_together/models/question.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:confirm_dialog/confirm_dialog.dart';

class BankModulePage extends StatefulWidget {
  const BankModulePage({Key? key, required this.module, required this.user})
      : super(key: key);
  final String module;
  final User user;

  @override
  State<BankModulePage> createState() => _BankModulePage();
}

class _BankModulePage extends State<BankModulePage> {
  late Future<QuerySnapshot<Map>> allQuestions;
  late bool _flagged;
  late bool _rated;

  @override
  void initState() {
    super.initState();
    allQuestions = FirebaseFirestore.instance
        .collectionGroup("questions")
        .where("Module", isEqualTo: widget.module)
        .where("Owner", isNotEqualTo: widget.user.uid)
        .where("Privacy", isEqualTo: false)
        .get();
    _flagged = false;
    _rated = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 222, 255),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(widget.module),
        leading: BackButton(onPressed: () {
          Navigator.pop(context);
        }),
      ),
      body: FutureBuilder(
          future: allQuestions,
          builder: (content, AsyncSnapshot<QuerySnapshot<Map>> snapshot) {
            if (snapshot.hasData) {
              return _generateListView(snapshot.data!.docs, context);
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }

  Widget _generateListView(
      List<QueryDocumentSnapshot<Map>> docslist, BuildContext context) {
    final currentScreenWidth = MediaQuery.of(context).size.width;
    final currentScreenHeight = MediaQuery.of(context).size.height;

    return docslist.isNotEmpty
        ? SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Center(
              child: SizedBox(
                width: currentScreenWidth < 1000
                    ? currentScreenWidth
                    : currentScreenWidth * 0.8,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 15.0,
                        ),
                        Text(
                          widget.module + " Questions",
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: docslist.length,
                      itemBuilder: (context, index) {
                        Question question = Question.getFromDatabase(
                            docslist[index]
                                as QueryDocumentSnapshot<Map<String, dynamic>>);
                        final _dialog = RatingDialog(
                          title: const Text(
                            "Difficulty Rating",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          message: const Text(
                            "Select a number of stars as your difficulty rating of the question.\n(You can only submit once)",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          enableComment: false,
                          submitButtonText: "Submit",
                          onSubmitted: (response) {
                            question.rateQuestion(response.rating);
                            setState(() {
                              _rated = true;
                            });
                          },
                        );

                        return Column(
                          children: [
                            SizedBox(
                              height: currentScreenHeight * 0.005,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 10.0,
                              ),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 10.0,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(),
                              ),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: IntrinsicHeight(
                                  child: Row(
                                    children: <Widget>[
                                      SizedBox(
                                        width: currentScreenWidth * 0.01,
                                      ),
                                      Text(
                                        "Q" + (index + 1).toString(),
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                        width: currentScreenWidth * 0.01,
                                      ),
                                      const VerticalDivider(
                                        thickness: 1,
                                        color: Colors.black,
                                      ),
                                      SizedBox(
                                        width: currentScreenWidth * 0.01,
                                      ),
                                      Flexible(
                                        child: Center(
                                          child: Text(
                                            question.data["Question"],
                                            style: const TextStyle(
                                              fontSize: 17,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: currentScreenWidth * 0.01,
                                      ),
                                      const VerticalDivider(
                                        thickness: 1,
                                        color: Colors.black,
                                      ),
                                      SizedBox(
                                        width: currentScreenWidth * 0.01,
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                height: 30.0,
                                                width: 40.0,
                                                child: Tooltip(
                                                  message:
                                                      "View & add question",
                                                  child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary:
                                                            Colors.deepPurple,
                                                        padding:
                                                            EdgeInsets.zero,
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pushNamed(
                                                            context,
                                                            "/questions/add",
                                                            arguments: <String,
                                                                dynamic>{
                                                              "Question":
                                                                  question
                                                            });
                                                      },
                                                      child: const Icon(
                                                          Icons.download)),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10.0,
                                              ),
                                              SizedBox(
                                                height: 30.0,
                                                width: 40.0,
                                                child: Tooltip(
                                                  message: !_flagged
                                                      ? "Flag question"
                                                      : "Already flagged",
                                                  child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary:
                                                            Colors.deepPurple,
                                                        padding:
                                                            EdgeInsets.zero,
                                                      ),
                                                      onPressed: () async {
                                                        if (_flagged) {
                                                          return;
                                                        }
                                                        if (await confirm(
                                                          context,
                                                          title: const Text(
                                                              "Confirm"),
                                                          content: const Text(
                                                              "Would you like to flag this question?"),
                                                          textOK:
                                                              const Text("Yes"),
                                                          textCancel:
                                                              const Text("No"),
                                                        )) {
                                                          question
                                                              .flagQuestion();
                                                          setState(() {
                                                            _flagged = true;
                                                          });
                                                        }
                                                      },
                                                      child: const Icon(
                                                          Icons.flag)),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10.0,
                                              ),
                                              SizedBox(
                                                height: 30.0,
                                                width: 40.0,
                                                child: Tooltip(
                                                  message: !_rated
                                                      ? "Rate difficulty"
                                                      : "Already rated",
                                                  child: ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary:
                                                            Colors.deepPurple,
                                                        padding:
                                                            EdgeInsets.zero,
                                                      ),
                                                      onPressed: () {
                                                        _rated
                                                            ? null
                                                            : showDialog(
                                                                context:
                                                                    context,
                                                                barrierDismissible:
                                                                    true,
                                                                builder:
                                                                    (context) =>
                                                                        _dialog,
                                                              );
                                                      },
                                                      child: const Icon(
                                                          Icons.star)),
                                                ),
                                              ),
                                              SizedBox(
                                                width:
                                                    currentScreenWidth * 0.01,
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: 5.0,
                                              right: currentScreenWidth * 0.01,
                                            ),
                                            child: question.data[
                                                            "Difficulty"] ==
                                                        null ||
                                                    question.data[
                                                            "No of Ratings"] ==
                                                        null
                                                ? const Text(
                                                    "No difficulty rating yet")
                                                : Text("Difficulty rating: " +
                                                    (question.data[
                                                                "Difficulty"] /
                                                            question.data[
                                                                "No of Ratings"])
                                                        .toString() +
                                                    " / 5"),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: currentScreenHeight * 0.005,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          )
        : const Center(
            child: Text(
              "There are no questions publicly available for this module :(",
            ),
          );
  }
}
