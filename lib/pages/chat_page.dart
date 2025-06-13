import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:real_time_chat_app/services/auth_service.dart';
import 'package:real_time_chat_app/services/firestore_service.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  const ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.receiverEmail), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: firestoreService.value.getMessages(
                    senderID: authService.value.currentUser!.uid,
                    receiverID: widget.receiverID,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      final List<Map<String, dynamic>> messages =
                          snapshot.data!;
                      return GroupedListView<Map<String, dynamic>, DateTime>(
                        reverse: true,
                        order: GroupedListOrder.DESC,
                        useStickyGroupSeparators: true,
                        floatingHeader: true,
                        elements: messages,
                        groupBy: (message) {
                          final timestamp = (message["timestamp"] as Timestamp)
                              .toDate();
                          return DateTime(
                            timestamp.year,
                            timestamp.month,
                            timestamp.day,
                          );
                        },
                        groupHeaderBuilder: (Map<String, dynamic> message) {
                          final DateTime timestamp =
                              (message["timestamp"] as Timestamp).toDate();
                          return SizedBox(
                            height: 50.0,
                            child: Center(
                              child: Card(
                                color: Colors.blue,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "${timestamp.day.toString().padLeft(2, "0")} ${timestamp.month.toString().padLeft(2, "0")} ${timestamp.year}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        itemBuilder: (context, Map<String, dynamic> message) {
                          final isSentByMe =
                              message["senderID"] ==
                              authService.value.currentUser!.uid;
                          return Align(
                            alignment: isSentByMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Card(
                              color: Colors.white,
                              elevation: 5.0,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: isSentByMe
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.person),
                                        Text(message["senderEmail"]),
                                      ],
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(message["message"]),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                ),
              ),
              SizedBox(height: 12.0),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    child: IconButton(
                      onPressed: () {
                        if (_controller.text.isNotEmpty) {
                          firestoreService.value.sendMessage(
                            receiverID: widget.receiverID,
                            receiverEmail: widget.receiverEmail,
                            message: _controller.text,
                          );
                          _controller.clear();
                          FocusScope.of(context).unfocus();
                        }
                      },
                      icon: Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
