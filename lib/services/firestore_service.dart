import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:real_time_chat_app/models/message_model.dart';

final ValueNotifier<FirestoreService> firestoreService = ValueNotifier(
  FirestoreService(),
);

class FirestoreService {
  final FirebaseFirestore _instance = FirebaseFirestore.instance;
  final FirebaseAuth _authInstance = FirebaseAuth.instance;

  Stream<List<Map<String, dynamic>>> getUsersList() {
    return _instance.collection("users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  Future<void> sendMessage({
    required String receiverID,
    required String receiverEmail,
    required String message,
  }) async {
    final String senderID = _authInstance.currentUser!.uid;
    final String senderEmail = _authInstance.currentUser!.email!;

    final MessageModel messageModel = MessageModel(
      senderID: senderID,
      senderEmail: senderEmail,
      receiverID: receiverID,
      receiverEmail: receiverEmail,
      message: message,
      timestamp: Timestamp.now(),
    );

    final List<String> ids = [receiverID, senderID];

    ids.sort();

    await _instance
        .collection("chat_rooms")
        .doc(ids.join("_"))
        .collection("messages")
        .add(messageModel.toMap());
  }

  Future<void> deleteMessage({
    required String receiverID,
    required String receiverEmail,
    required String docID,
  }) async {
    final String senderID = _authInstance.currentUser!.uid;

    final List<String> ids = [receiverID, senderID];

    ids.sort();

    await _instance
        .collection("chat_rooms")
        .doc(ids.join("_"))
        .collection("messages")
        .doc(docID)
        .delete();
  }

  Stream<List<Map<String, dynamic>>> getMessages({
    required String senderID,
    required String receiverID,
  }) {
    final List<String> ids = [receiverID, senderID];
    ids.sort();
    return _instance
        .collection("chat_rooms")
        .doc(ids.join("_"))
        .collection("messages")
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return data;
          }).toList();
        });
  }
}
