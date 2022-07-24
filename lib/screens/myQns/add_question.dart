import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mug_together/models/question.dart';
import 'package:mug_together/widgets/data.dart';
import 'package:mug_together/widgets/module_list.dart';

class AddQuestion extends StatefulWidget {
  const AddQuestion({Key? key, required this.user, this.question})
      : super(key: key);
  final User user;
  final Question? question;

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

  // Prevent memory leak
  @override
  void dispose() {
    questionController.dispose();
    pointersController.dispose();
    tagsController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.question != null) {
      questionController.text = widget.question!.data["Question"];
      module.text = widget.question!.data["Module"];
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentScreenWidth = MediaQuery.of(context).size.width;
    final currentScreenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 222, 255),
      appBar: AppBar(
        title: const Text("Add Question"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Form(
          key: _formKey,
          child: Center(
            child: SizedBox(
              width: currentScreenWidth < 500
                  ? currentScreenWidth
                  : currentScreenWidth < 1000
                      ? currentScreenWidth * 0.8
                      : currentScreenWidth * 0.6,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: currentScreenHeight * 0.03,
                  ),
                  // Question field
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: questionController.text.isEmpty
                            ? Colors.grey[100]
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          width: 1,
                          color: const Color.fromARGB(255, 100, 100, 100),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: TextFormField(
                          key: const Key("questionTextField"),
                          enabled: questionController.text.isEmpty,
                          controller: questionController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 20),
                            border: InputBorder.none,
                            hintText: 'Input your question',
                            prefixIcon: Icon(
                              Icons.question_mark_outlined,
                              color: Colors.deepPurple,
                            ),
                          ),
                          validator: (String? value) {
                            if (value!.trim().isEmpty) {
                              return 'Question cannot be empty';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: currentScreenHeight * 0.03,
                  ),
                  // Pointers field, can be empty
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          width: 1,
                          color: const Color.fromARGB(255, 100, 100, 100),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: TextFormField(
                          key: const Key("notesTextField"),
                          controller: pointersController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 30),
                            border: InputBorder.none,
                            hintText:
                                'Input any notes (Multiline) (Markdown supported) (Optional)',
                            prefixIcon: Icon(
                              Icons.notes_outlined,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: currentScreenHeight * 0.03,
                  ),
                  // Tags field, can be empty
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          width: 1,
                          color: const Color.fromARGB(255, 100, 100, 100),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: TextFormField(
                          key: const Key("tagsTextField"),
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
                  SizedBox(
                    height: currentScreenHeight * 0.03,
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
                            : Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                ),
                                child: DropdownSearch(
                                  key: const Key("moduleDropdown"),
                                  popupBackgroundColor: Colors.grey[300],
                                  enabled: false,
                                  selectedItem: module.text,
                                  dropdownSearchDecoration:
                                      const InputDecoration(
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
                      ),
                      const SizedBox(
                        width: 40.0,
                      ),
                      widget.question == null
                          ? Row(
                              children: [
                                const Text(
                                  "Privatise question? ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Checkbox(
                                    activeColor: Colors.deepPurple,
                                    splashRadius: 20.0,
                                    value: privacy,
                                    onChanged: (newValue) => setState(() {
                                          privacy = newValue!;
                                        })),
                              ],
                            )
                          : const Text(""),
                    ],
                  ),
                  SizedBox(
                    height: currentScreenHeight * 0.03,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 20.0,
                      ),
                      Tooltip(
                        message: "Click to save",
                        child: ElevatedButton(
                          key: const Key("saveButton"),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.deepPurple,
                          ),
                          // If inputs are valid, store into database
                          onPressed: () {
                            if (_formKey.currentState!.validate() &&
                                module.text != null) {
                              if (widget.question == null) {
                                Question question = Question(<String, dynamic>{
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
                                  "FromCommunity": false,
                                }, widget.user.uid, module.text!);
                                question.addToDatabase().then((_) =>
                                    Navigator.pushReplacementNamed(
                                        context, "/questions"));
                              } else {
                                widget.question!
                                    .pullToUser(widget.user.uid,
                                        pointersController.text)
                                    .then((_) => Navigator.pushReplacementNamed(
                                        context, "/questions"));
                                ;
                              }
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
          ),
        ),
      ),
    );
  }
}
