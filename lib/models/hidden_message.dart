class HiddenMessage {
  final String senderID;
  final String senderEmail;
  final String receiverID;
  final String receiverEmail;
  final String docID;
  final String whoDeleted;

  HiddenMessage({
    required this.senderID,
    required this.senderEmail,
    required this.receiverID,
    required this.receiverEmail,
    required this.docID,
    required this.whoDeleted,
  });

  Map<String, dynamic> toMap() {
    return {
      "senderEmail": senderEmail,
      "senderID": senderID,
      "receiverID": receiverID,
      "receiverEmail": receiverEmail,
      "docID": docID,
      "whoDeleted": whoDeleted,
    };
  }
}
