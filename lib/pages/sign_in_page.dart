import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:real_time_chat_app/services/auth_service.dart';
import 'package:real_time_chat_app/widgets/my_text_field.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign In Page"), centerTitle: true),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Spacer(),
                  Text(
                    errorMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red),
                  ),
                  SizedBox(height: 6.0),
                  MyTextField(
                    controller: _emailController,
                    hintText: "Your email",
                    validator: (value) => (value == null || value.isEmpty)
                        ? "Enter your email"
                        : null,
                    isEmail: true,
                  ),
                  SizedBox(height: 12.0),
                  MyTextField(
                    controller: _passwordController,
                    hintText: "Your password",
                    validator: (value) => (value == null || value.isEmpty)
                        ? "Enter your password"
                        : null,
                    obscureText: true,
                  ),
                  Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.maxFinite, 50),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await signIn(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                        _emailController.clear();
                        _passwordController.clear();
                      }
                    },
                    child: Text("Sign In"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signIn({required String email, required String password}) async {
    try {
      await authService.value.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if(mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message as String;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
