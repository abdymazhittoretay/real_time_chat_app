import 'package:flutter/material.dart';
import 'package:real_time_chat_app/services/auth_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () async {
            await authService.value.signOut();
          },
          icon: Icon(Icons.exit_to_app),
        ),
      ),
    );
  }
}
