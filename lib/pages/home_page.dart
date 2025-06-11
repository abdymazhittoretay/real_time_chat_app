import 'package:flutter/material.dart';
import 'package:real_time_chat_app/services/auth_service.dart';
import 'package:real_time_chat_app/services/firestore_service.dart';

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
      body: StreamBuilder(
        stream: firestoreService.value.getUsersList(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "There are some error: ${snapshot.error}",
                textAlign: TextAlign.center,
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final List<Map<String, dynamic>> users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final Map<String, dynamic> user = users[index];
                if (user["email"] != authService.value.currentUser!.email) {
                  return ListTile(title: Text(user["email"]));
                } else {
                  return const SizedBox.shrink();
                }
              },
            );
          } else {
            return Center(child: Text("No contacts yet."));
          }
        },
      ),
    );
  }
}
