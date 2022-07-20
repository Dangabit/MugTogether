import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExtendedProfile {
  final String user;
  final Map<String, dynamic> extraData;

  /// Create an extended profile of the user
  ExtendedProfile(this.user, this.extraData);

  /// Factory method to retrieve extended profile from database
  static Future<ExtendedProfile> getInfo(String user) async {
    return FirebaseFirestore.instance
        .collection(user)
        .doc("Extended Info")
        .get()
        .then((doc) => ExtendedProfile(user, doc.data()!));
  }

  /// Initialising a complete user upon sign up
  static Future<void> initUser(User user) async {
    final db = FirebaseFirestore.instance;
    return db.runTransaction((transaction) async {
      // Setting up Tags document
      transaction.set(db.collection(user.uid).doc("Tags"), {});
      // Setting up Quiz Attempts document
      transaction.set(db.collection(user.uid).doc("Quiz Attempts"),
          {"AttemptList": List.empty()});
      // Setting up extended info
      transaction.set(db.collection(user.uid).doc("Extended Info"), {
        "Bio": "",
        "Achievements": List.empty(),
        "Username": user.displayName,
        "PicURL": user.photoURL ?? "",
      });
    });
  }

  /// Update the profile to database
  Future<void> updateProfile(Map<String, dynamic> newData) {
    return FirebaseFirestore.instance
        .collection(user)
        .doc("Extended Info")
        .set(newData);
  }

  /// Reverify and update to database
  Future<void> reverify(
      Map<String, dynamic> cred, Map<String, dynamic> data, User currentUser) {
    return currentUser
        .reauthenticateWithCredential(EmailAuthProvider.credential(
            email: currentUser.email!, password: cred["Password"]))
        .then((credential) async {
      await credential.user!.updateDisplayName(data["Name"]);
      if (cred["NewPassword"].isNotEmpty) {
        await credential.user!.updatePassword(cred["NewPassword"]);
      }
    }).then((_) async {
      await updateProfile(data);
    });
  }
}
