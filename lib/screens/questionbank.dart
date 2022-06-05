import 'package:flutter/material.dart';
import 'package:mug_together/widgets/in_app_drawer.dart';

class QuestionBankPage extends StatefulWidget {
  const QuestionBankPage({Key? key}) : super(key: key);

  @override
  State<QuestionBankPage> createState() => _QuestionBankPage();
}

class _QuestionBankPage extends State<QuestionBankPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Question Bank")),
      drawer: InAppDrawer.gibDrawer(context),
    );
  }
}
