import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:real_time_chat_app/models/hidden_message.dart';
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

  Future<void> addHiddenMessage({
    required String receiverID,
    required String receiverEmail,
    required String docID,
  }) async {
    final String senderID = _authInstance.currentUser!.uid;
    final String senderEmail = _authInstance.currentUser!.email!;

    final HiddenMessage hiddenMessage = HiddenMessage(
      senderID: senderID,
      senderEmail: senderEmail,
      receiverID: receiverID,
      receiverEmail: receiverEmail,
      docID: docID,
      whoDeleted: senderID,
    );

    final List<String> ids = [receiverID, senderID];

    ids.sort();

    await _instance
        .collection("chat_rooms")
        .doc(ids.join("_"))
        .collection("hidden_messages")
        .add(hiddenMessage.toMap());
  }

  Stream<List<Map<String, dynamic>>> getUsersListWithLastMessage() {
    final currentUser = _authInstance.currentUser!;
    final currentUserID = currentUser.uid;

    return _instance.collection("users").snapshots().asyncMap((snapshot) async {
      List<Map<String, dynamic>> userList = [];

      for (var doc in snapshot.docs) {
        final userData = doc.data();
        final userID = userData['uid'];

        if (userID == currentUserID) continue;

        final chatRoomID = [currentUserID, userID]..sort();
        final chatRoomDocID = chatRoomID.join("_");

        final lastMessageSnapshot = await _instance
            .collection("chat_rooms")
            .doc(chatRoomDocID)
            .collection("messages")
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

        if (lastMessageSnapshot.docs.isNotEmpty) {
          final messageData = lastMessageSnapshot.docs.first.data();
          userData['lastMessage'] = messageData['message'] ?? '';
          userData['lastMessageTimestamp'] =
              messageData['timestamp'] ?? Timestamp(0, 0);
        } else {
          userData['lastMessage'] = '';
          userData['lastMessageTimestamp'] = Timestamp(0, 0);
        }

        userList.add(userData);
      }

      userList.sort((a, b) {
        final timeA = a['lastMessageTimestamp'] as Timestamp;
        final timeB = b['lastMessageTimestamp'] as Timestamp;
        return timeB.compareTo(timeA);
      });

      return userList;
    });
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
    final chatRoomID = ids.join("_");

    final messages = _instance
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy('timestamp', descending: false);

    final hiddenMessages = _instance
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("hidden_messages")
        .where('whoDeleted', isEqualTo: senderID);

    return messages.snapshots().asyncMap((messageSnapshot) async {
      final hiddenSnapshot = await hiddenMessages.get();
      final hiddenIDs = hiddenSnapshot.docs
          .map((doc) => doc.data()['docID'] as String)
          .toSet();

      final visibleMessages = messageSnapshot.docs
          .where((doc) {
            return !hiddenIDs.contains(doc.id);
          })
          .map((doc) {
            final data = doc.data();
            data['docID'] = doc.id;
            return data;
          })
          .toList();

      return visibleMessages;
    });
  }
}
