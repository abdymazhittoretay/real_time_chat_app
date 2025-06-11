import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

final ValueNotifier<FirestoreService> firestoreService = ValueNotifier(
  FirestoreService(),
);

class FirestoreService {
  final FirebaseFirestore _instance = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getUsersList() {
    return _instance.collection("users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return doc.data();
      }).toList();
    });
  }
}
