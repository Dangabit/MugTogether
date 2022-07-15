import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mug_together/widgets/data.dart';
import 'package:mug_together/widgets/module_list.dart';

class AddQuestion extends StatefulWidget {
  const AddQuestion({Key? key, this.data, required this.user})
      : super(key: key);
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
      backgroundColor: const Color.fromARGB(255, 241, 222, 255),
      appBar: AppBar(
        title: const Text("Add Question"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Flex(
          direction: Axis.vertical,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 20.0,
                  ),
                  // Question field
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: TextFormField(
                              enabled: questionController.text.isEmpty
                                  ? true
                                  : false,
                              controller: questionController,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: const InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 20),
                                border: InputBorder.none,
                                hintText: 'Input your question',
                                prefixIcon: Icon(
                                  Icons.question_mark_outlined,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Question cannot be empty';
                                }
                                return null;
                              })),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  // Pointers field, can be empty
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: TextFormField(
                          controller: pointersController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 30),
                            border: InputBorder.none,
                            hintText: 'Input any notes (Multiline) (Optional)',
                            prefixIcon: Icon(
                              Icons.notes_outlined,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  // Tags field, can be empty
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: TextFormField(
                          controller: tagsController,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 20),
                            border: InputBorder.none,
                            hintText: 'Tags: <tag1>, <tag2>, <tag3> (Optional)',
                            prefixIcon: Icon(
                              Icons.sell_outlined,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Row(
                    children: <Widget>[
                      const SizedBox(
                        width: 20.0,
                      ),
                      // Module id field
                      Flexible(
                        child: module.text == null
                            ? ModuleList.createListing(module)
                            : DropdownSearch(
                                enabled: false,
                                selectedItem: module.text,
                                dropdownSearchDecoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  constraints: BoxConstraints(
                                    maxWidth: 180.0,
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),

                      const SizedBox(
                        width: 20.0,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 20.0,
                      ),
                      const Text(
                        "Privatise question? ",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      fromComm
                          ? const SizedBox(
                              width: 10.0,
                            )
                          : Checkbox(
                              activeColor: Colors.deepPurple,
                              splashRadius: 20.0,
                              value: privacy,
                              onChanged: (newValue) => setState(() {
                                    privacy = newValue!;
                                  })),
                      const SizedBox(
                        width: 40.0,
                      ),
                      Tooltip(
                        message: "Click to save",
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.deepPurple,
                          ),
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
                                "Owner": widget.user.uid,
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
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
