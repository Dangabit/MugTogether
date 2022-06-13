import 'package:flutter/material.dart';
import 'package:mug_together/widgets/data.dart';
import 'package:mug_together/widgets/in_app_drawer.dart';
import 'package:mug_together/widgets/module_list.dart';

class QuestionBankPage extends StatefulWidget {
  const QuestionBankPage({Key? key}) : super(key: key);

  @override
  State<QuestionBankPage> createState() => _QuestionBankPage();
}

class _QuestionBankPage extends State<QuestionBankPage> {
  Data currentValue = Data();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Question Bank")),
        drawer: InAppDrawer.gibDrawer(context),
        body: Column(
          children: <Widget>[
            ModuleList.createListing(currentValue),
            ElevatedButton(
              onPressed: _submit,
              child: const Icon(Icons.arrow_right),
            )
          ],
        ));
  }

  void _submit() {
    if (currentValue.text != null) {
      Navigator.pushNamed(context, "/bank/module",
          arguments: currentValue.text);
    }
  }
}
