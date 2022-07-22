import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mug_together/models/discussion.dart';

class Question {
  late Map<String, dynamic> data;
  late final String _uid;
  late final String _module;
  late final String _docId;

  /// Create a question instance
  ///
  /// For adding of question
  Question(this.data, this._uid, this._module);

  /// Create a question instance
  ///
  /// For reading of question
  Question._fromDatabase(this.data, this._uid, this._module, this._docId);

  /// Factory method to obtain a question from database
  static Question getFromDatabase(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    Map<String, dynamic> data = doc.data();
    return Question._fromDatabase(data, data["Owner"], data["Module"], doc.id);
  }

  /// Add question into database
  Future<void> addToDatabase() {
    final db = FirebaseFirestore.instance;
    return db.runTransaction((transaction) async {
      // Add question
      transaction.set(
          db.collection(_uid).doc(_module).collection("questions").doc(), data);
      // Counting no. of questions for module
      transaction.set(db.collection(_uid).doc(_module),
          {"isEmpty": FieldValue.increment(1)}, SetOptions(merge: true));
      // Counting no. of questions for tag
      transaction.update(
          db.collection(_uid).doc("Tags"),
          Map.fromIterable(data["Tags"] as List,
              value: (element) => FieldValue.increment(1)));
    });
  }

  /// Delete question from database
  Future<void> removeFromDatabase() {
    final db = FirebaseFirestore.instance;
    return db.runTransaction((transaction) async {
      // Updating no. of questions for module
      transaction.update(db.collection(_uid).doc(_module),
          {"isEmpty": FieldValue.increment(-1)});
      // Updating no. of questions for tag
      transaction.update(
          db.collection(_uid).doc("Tags"),
          Map.fromIterable(
            data["Tags"] as List,
            value: (element) => FieldValue.increment(-1),
          ));
      // Delete this question
      transaction.delete(
          db.collection(_uid).doc(_module).collection("questions").doc(_docId));
    });
  }

  /// Update question in database
  Future<void> updateDatabase(Map<String, dynamic> newData) {
    final db = FirebaseFirestore.instance;
    return db.runTransaction((transaction) async {
      // Updating question
      transaction.update(
          db.collection(_uid).doc(_module).collection("questions").doc(_docId),
          newData);
      // Adding new tags
      transaction.update(
          db.collection(_uid).doc("Tags"),
          Map.fromIterable(newData["Tags"],
              value: (element) => FieldValue.increment(1)));
      // Reducing old tags
      transaction.update(
          db.collection(_uid).doc("Tags"),
          Map.fromIterable(
            data["Tags"],
            value: (element) => FieldValue.increment(-1),
          ));
    });
  }

  /// Pull current question into user collection
  Future<void> pullToUser(String newUID) {
    Map<String, dynamic> dupeQn = Map.of(data);
    dupeQn.update("FromCommunity", (value) => true);
    dupeQn.update("Owner", (value) => newUID);
    dupeQn.update("Privacy", (value) => true);
    return Question(dupeQn, newUID, _module).addToDatabase();
  }

  /// Push current question to QnA
  Future<void> pushToQnA(String initMessage) {
    return Discussion.create(
        initMessage, data["Owner"], data["Module"], data["Question"]);
  }
}
