import 'package:flutter/material.dart';

class ChatMessageBubble extends StatelessWidget {
  final Map<String, dynamic> message;
  final bool isSentByMe;
  final VoidCallback onDeleteForMe;
  final VoidCallback onDeleteForAll;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.isSentByMe,
    required this.onDeleteForMe,
    required this.onDeleteForAll,
  });

  @override
  Widget build(BuildContext context) {
    final timestamp = (message["timestamp"]).toDate();
    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(message["senderEmail"]),
          const SizedBox(height: 4.0),
          GestureDetector(
            onLongPress: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Message'),
                  content: const Text('Are you sure you want to delete this message?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        onDeleteForMe();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Delete for myself', style: TextStyle(color: Colors.red)),
                    ),
                    if (isSentByMe)
                      TextButton(
                        onPressed: () {
                          onDeleteForAll();
                          Navigator.of(context).pop();
                        },
                        child: const Text('Delete for all', style: TextStyle(color: Colors.red)),
                      ),
                  ],
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Card(
                color: Colors.white,
                elevation: 5.0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                        child: Text(message["message"], softWrap: true),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        "${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}",
                        style: TextStyle(fontSize: 10, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
