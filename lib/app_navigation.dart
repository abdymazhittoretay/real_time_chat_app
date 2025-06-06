import 'package:flutter/material.dart';
import 'package:real_time_chat_app/pages/home_page.dart';
import 'package:real_time_chat_app/pages/welcome_page.dart';
import 'package:real_time_chat_app/services/auth_service.dart';

class AppNavigation extends StatelessWidget {
  const AppNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AuthService>(
      valueListenable: authService,
      builder: (context, service, child) {
        return StreamBuilder(
          stream: service.authState,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return HomePage();
            } else {
              return WelcomePage();
            }
          },
        );
      },
    );
  }
}
