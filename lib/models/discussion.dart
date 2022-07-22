import 'package:cloud_firestore/cloud_firestore.dart';

class Discussion {
  Map<String, dynamic> data;
  String _id;

  /// Constructor for discussion object
  Discussion(this.data, this._id);

  /// Factory method to retrieve the discussion
  factory Discussion.getFromDatabase(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    return Discussion(doc.data()!, doc.id);
  }

  /// Create a discussion
  static Future<void> create(String initMessage, String name, String uid,
      String module, String question) {
    return FirebaseFirestore.instance
        .collection("QnA")
        .doc("Lounges")
        .collection(module)
        .doc()
        .set({
      "Question": question,
      "Discussion": <String>[initMessage],
      "Users": <String>[name],
      "UserID": <String>[uid],
      "Created": DateTime.now()
    });
  }

  /// Retrieve a stream for realtime updates
  Stream<DocumentSnapshot<Map<String, dynamic>>> dataStream() {
    return FirebaseFirestore.instance
        .collection("QnA")
        .doc("Lounges")
        .collection(data["Module"])
        .doc(_id)
        .snapshots();
  }

  /// Add a message
  Future<void> update(String message, String name, String uid) {
    (data["Users"] as List).add(name);
    (data["Discussion"] as List).add(message);
    (data["UserID"] as List).add(uid);
    return FirebaseFirestore.instance
        .collection("QnA")
        .doc("Lounges")
        .collection(data["Module"])
        .doc(_id)
        .update(data);
  }
}
