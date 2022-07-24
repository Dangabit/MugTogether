import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mug_together/widgets/data.dart';
import 'package:mug_together/widgets/in_app_drawer.dart';
import 'package:mug_together/widgets/module_list.dart';

class QuestionBankPage extends StatefulWidget {
  const QuestionBankPage({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<QuestionBankPage> createState() => _QuestionBankPage();
}

class _QuestionBankPage extends State<QuestionBankPage> {
  Data currentValue = Data();

  @override
  Widget build(BuildContext context) {
    final currentScreenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 241, 222, 255),
        appBar: AppBar(
          title: const Text("Question Bank"),
          backgroundColor: Colors.deepPurple,
        ),
        drawer: InAppDrawer.gibDrawer(context, widget.user),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: currentScreenHeight * 0.03,
                ),
                Wrap(
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        "Begin by choosing your desired module! 😃",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: currentScreenHeight * 0.03,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 10.0,
                  ),
                  child: ModuleList.createListing(currentValue),
                ),
                Tooltip(
                  message: "Next!",
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepPurple,
                    ),
                    onPressed: _submit,
                    child: const Icon(Icons.arrow_right),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void _submit() {
    if (currentValue.text != null) {
      Navigator.pushNamed(context, "/bank/module",
          arguments: currentValue.text);
    }
  }
}
