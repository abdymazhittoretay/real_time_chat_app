import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:real_time_chat_app/services/auth_service.dart';
import 'package:real_time_chat_app/widgets/my_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register Page"), centerTitle: true),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
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
                            controller: _usernameController,
                            hintText: "Your username",
                            validator: (value) =>
                                (value == null || value.isEmpty)
                                ? "Enter your username"
                                : null,
                          ),
                          SizedBox(height: 12.0),
                          MyTextField(
                            controller: _emailController,
                            hintText: "Your email",
                            validator: (value) =>
                                (value == null || value.isEmpty)
                                ? "Enter your email"
                                : null,
                            isEmail: true,
                          ),
                          SizedBox(height: 12.0),
                          MyTextField(
                            controller: _passwordController,
                            hintText: "Your password",
                            validator: (value) =>
                                (value == null || value.isEmpty)
                                ? "Enter your password"
                                : null,
                            obscureText: true,
                          ),
                          SizedBox(height: 12.0),
                          MyTextField(
                            controller: _confirmPasswordController,
                            hintText: "Confirm password",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Confirm your password";
                              }
                              if (value != _passwordController.text) {
                                return "Passwords do not match";
                              }
                              return null;
                            },
                            obscureText: true,
                          ),
                          Spacer(),
                          SizedBox(height: 12.0),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.maxFinite, 50),
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Theme.of(
                                context,
                              ).secondaryHeaderColor,
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await register(
                                  username: _usernameController.text,
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                );
                                _usernameController.clear();
                                _emailController.clear();
                                _passwordController.clear();
                                _confirmPasswordController.clear();
                              }
                            },
                            child: Text("Register"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      await authService.value.registerUserWithEmailAndPassword(
        email: email,
        password: password,
        username: username,
      );
      if (mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message as String;
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
