import 'package:flutter/material.dart';
import 'package:mug_together/widgets/in_app_drawer.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPage();
}

class _QuizPage extends State<QuizPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quiz")),
      drawer: InAppDrawer.gibDrawer(context),
    );
  }
}
