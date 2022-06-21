import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddQuestion extends StatefulWidget {
  const AddQuestion({Key? key, this.data}) : super(key: key);
  final Map? data;

  @override
  State<AddQuestion> createState() => _AddQuestion();
}

class _AddQuestion extends State<AddQuestion> {
  User? user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  final db = FirebaseFirestore.instance;
  final questionController = TextEditingController();
  final pointersController = TextEditingController();
  final moduleController = TextEditingController();
  final tagsController = TextEditingController();
  bool privacy = false;
  int importance = 0;
  bool fromComm = false;

  @override
  void initState() {
    super.initState();
    // Force module id to be uppercase
    moduleController.addListener(() {
      final String text = moduleController.text.toUpperCase();
      moduleController.value = moduleController.value.copyWith(
        text: text,
      );
    });
    if (widget.data != null) {
      moduleController.text = widget.data!["module"];
      questionController.text = widget.data!["question"];
      fromComm = true;
      privacy = true;
    }
  }

  // Prevent memory leak
  @override
  void dispose() {
    questionController.dispose();
    pointersController.dispose();
    moduleController.dispose();
    tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Flex(
        direction: Axis.vertical,
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                // Question field
                TextFormField(
                    controller: questionController,
                    decoration: const InputDecoration(hintText: 'Question'),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Question cannot be empty';
                      }
                      return null;
                    }),
                // Pointers field, can be empty
                TextFormField(
                  controller: pointersController,
                  decoration: const InputDecoration(hintText: 'Any notes'),
                ),
                TextFormField(
                  controller: tagsController,
                  decoration: const InputDecoration(
                      hintText: 'Separate multi labels with commas!'),
                ),
                Row(
                  children: <Widget>[
                    // Module id field
                    Flexible(
                      child: TextFormField(
                          controller: moduleController,
                          decoration: const InputDecoration(hintText: 'Module'),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Module cannot be empty';
                            }
                            return null;
                          }),
                    ),
                    fromComm
                        ? const Spacer()
                        : Checkbox(
                            value: privacy,
                            onChanged: (newValue) => setState(() {
                                  privacy = newValue!;
                                })),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        // If inputs are valid, store into database
                        if (_formKey.currentState!.validate()) {
                          final question = <String, dynamic>{
                            "Question": questionController.text,
                            "Notes": pointersController.text,
                            "Module": moduleController.text,
                            "LastUpdate": DateTime.now().toString(),
                            "Tags": tagsController.text
                                .split(', ')
                                .toSet()
                                .toList(),
                            "Importance": importance,
                            "Privacy": privacy,
                            "Owner": user!.uid,
                            "FromCommunity": fromComm,
                          };
                          // Storing of the question
                          Future addQuestion = db
                              .collection(user!.uid)
                              .doc(moduleController.text)
                              .collection("questions")
                              .add(question);
                          // Creating subcollection
                          Future addModuleSub = db
                              .collection(user!.uid)
                              .doc(moduleController.text)
                              .set({"isEmpty": false});
                          // Counting tags
                          Future addTags = db
                              .collection(user!.uid)
                              .doc("Tags")
                              .update(Map.fromIterable(question["Tags"],
                                  value: (element) => FieldValue.increment(1)));
                          // Return to question overview
                          Future.wait([addQuestion, addModuleSub, addTags])
                              .then((_) => Navigator.pop(context));
                        }
                      },
                      child: const Icon(Icons.save),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
