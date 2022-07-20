import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';

class Discussion {
  Map<String, dynamic> data;

  /// Constructor for discussion object
  Discussion(this.data);

  /// Factory method to retrieve the discussion
  static Discussion getFromDatabase(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    return Discussion(doc.data());
  }

  /// Organise data into name : message pair
  LinkedHashMap<String, String> getConversation() {
    return LinkedHashMap.fromIterables(data["Users"], data["Discussion"]);
  }
}
