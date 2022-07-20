import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mug_together/models/question.dart';

class SharedQuestion extends StatelessWidget {
  final Future<Question> questionFuture;
  final User user;

  SharedQuestion(
      {Key? key, required Map<String, dynamic> data, required this.user})
      : questionFuture =
            Question.getByPath(data["module"], data["uid"], data["qid"]),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: questionFuture,
      builder: (context, AsyncSnapshot<Question> snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
              body: Column(
            children: [
              // TODO: Display question info here, use Markdown pacakge too
              // If needed, u can make a widget to display the question
              // for both here and view_question
              Text(snapshot.data?.data["Question"]),
            ],
          ));
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
