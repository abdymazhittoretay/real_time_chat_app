import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String senderID;
  final String senderEmail;
  final String receiverID;
  final String receiverEmail;
  final String message;
  final Timestamp timestamp;

  MessageModel({
    required this.senderID,
    required this.senderEmail,
    required this.receiverID,
    required this.receiverEmail,
    required this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      "senderEmail": senderEmail,
      "senderID": senderID,
      "receiverID": receiverID,
      "receiverEmail": receiverEmail,
      "message": message,
      "timestamp": timestamp,
    };
  }
}
