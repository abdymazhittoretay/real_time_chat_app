import 'package:flutter/material.dart';

class ChatInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const ChatInputField({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: "Type your message here...",
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 10.0),
        Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: IconButton(
            onPressed: onSend,
            icon: const Icon(Icons.send, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
