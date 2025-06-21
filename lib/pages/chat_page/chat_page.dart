import 'package:flutter/material.dart';
import 'package:real_time_chat_app/services/auth_service.dart';
import 'package:real_time_chat_app/services/firestore_service.dart';
import 'package:real_time_chat_app/pages/chat_page/chat_input_field.dart';
import 'package:real_time_chat_app/pages/chat_page/chat_message_bubble.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:real_time_chat_app/pages/chat_page/date_header.dart';

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
  final ScrollController _scrollController = ScrollController();
  bool _showScrollDownButton = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (!_scrollController.hasClients) return;
      final isNotAtBottom = _scrollController.offset > 100;
      if (isNotAtBottom != _showScrollDownButton) {
        setState(() => _showScrollDownButton = isNotAtBottom);
      }
    });
  }

  void scrollDown() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

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
                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      final messages = snapshot.data!;
                      return Stack(
                        children: [
                          GroupedListView<Map<String, dynamic>, DateTime>(
                            controller: _scrollController,
                            reverse: true,
                            order: GroupedListOrder.DESC,
                            useStickyGroupSeparators: true,
                            floatingHeader: true,
                            elements: messages,
                            groupBy: (msg) {
                              final ts = (msg["timestamp"] as Timestamp)
                                  .toDate();
                              return DateTime(ts.year, ts.month, ts.day);
                            },
                            groupHeaderBuilder: (msg) => DateHeader(
                              date: (msg["timestamp"] as Timestamp).toDate(),
                            ),
                            itemBuilder: (context, msg) => ChatMessageBubble(
                              message: msg,
                              isSentByMe:
                                  msg["senderID"] ==
                                  authService.value.currentUser!.uid,
                              onDeleteForMe: () {
                                firestoreService.value.addHiddenMessage(
                                  receiverID: widget.receiverID,
                                  receiverEmail: widget.receiverEmail,
                                  docID: msg["docID"],
                                );
                                setState(() {});
                              },
                              onDeleteForAll: () {
                                firestoreService.value.deleteMessage(
                                  receiverID: widget.receiverID,
                                  receiverEmail: widget.receiverEmail,
                                  docID: msg["id"],
                                );
                              },
                            ),
                          ),
                          if (_showScrollDownButton)
                            Positioned(
                              left: 10,
                              bottom: 10,
                              child: FloatingActionButton(
                                mini: true,
                                onPressed: scrollDown,
                                child: const Icon(Icons.arrow_downward),
                              ),
                            ),
                        ],
                      );
                    }
                    return const Center(child: Text("No messages yet."));
                  },
                ),
              ),
              const SizedBox(height: 12.0),
              ChatInputField(
                controller: _controller,
                onSend: () {
                  if (_controller.text.isNotEmpty) {
                    firestoreService.value.sendMessage(
                      receiverID: widget.receiverID,
                      receiverEmail: widget.receiverEmail,
                      message: _controller.text,
                    );
                    _controller.clear();
                    scrollDown();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
