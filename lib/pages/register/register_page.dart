import 'package:flutter/material.dart';
import 'register_form.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register Page"), centerTitle: true),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: RegisterForm(),
        ),
      ),
    );
  }
}
