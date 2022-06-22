import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mug_together/widgets/data.dart';
import 'package:mug_together/widgets/module_list.dart';

class AddQuestion extends StatefulWidget {
  const AddQuestion({Key? key, this.data, required this.user}) : super(key: key);
  final Map? data;
  final User user;

  @override
  State<AddQuestion> createState() => _AddQuestion();
}

class _AddQuestion extends State<AddQuestion> {
  // Variable Initialisation
  final _formKey = GlobalKey<FormState>();
  final db = FirebaseFirestore.instance;
  final questionController = TextEditingController();
  final pointersController = TextEditingController();
  final tagsController = TextEditingController();
  final Data module = Data();
  bool privacy = false;
  int importance = 0;
  bool fromComm = false;

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      module.text = widget.data!["module"];
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
                      child: ModuleList.createListing(module),
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
                        if (_formKey.currentState!.validate() &&
                            module.text != null) {
                          final question = <String, dynamic>{
                            "Question": questionController.text,
                            "Notes": pointersController.text,
                            "Module": module.text,
                            "LastUpdate": DateTime.now().toString(),
                            "Tags": tagsController.text.isEmpty
                                ? List.empty()
                                : tagsController.text
                                    .split(', ')
                                    .toSet()
                                    .toList(),
                            "Importance": importance,
                            "Privacy": privacy,
<<<<<<< HEAD
                            "Owner": widget.user.uid,
=======
                            "Owner": user!.uid,
>>>>>>> c8f4f25ba24a81fb78efe56d861ac5d9c4be6063
                            "FromCommunity": fromComm,
                          };
                          // Storing of the question

                          db
                              .collection(widget.user.uid)
                              .doc(module.text)
                              .collection("questions")
                              .add(question)
                              .then((_) {
                            // Creating subcollection
                            Future addModuleSub = db
                                .collection(widget.user.uid)
                                .doc(module.text)
                                .update({
                              "isEmpty": FieldValue.increment(1)
                            }).onError((error, stackTrace) => db
                                    .collection(widget.user.uid)
                                    .doc(module.text)
                                    .set({"isEmpty": 1}));
                            // Counting tags
                            Future addTags = db
                                .collection(widget.user.uid)
                                .doc("Tags")
                                .update(Map.fromIterable(question["Tags"],
                                    value: (element) =>
                                        FieldValue.increment(1)));
                            // Return to question overview
                            Future.wait([addModuleSub, addTags]).then((_) =>
                                Navigator.pushReplacementNamed(
                                    context, "/questions"));
                          });
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
