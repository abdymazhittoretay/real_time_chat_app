import 'package:flutter/material.dart';
import 'package:real_time_chat_app/widgets/my_text_field.dart';
import 'package:real_time_chat_app/utils/loading_dialog.dart';
import 'register_controller.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String errorMessage = "";

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Spacer(),
                    Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 6.0),
                    MyTextField(
                      controller: _usernameController,
                      hintText: "Your username",
                      validator: (val) => (val == null || val.isEmpty)
                          ? "Enter your username"
                          : null,
                    ),
                    const SizedBox(height: 12.0),
                    MyTextField(
                      controller: _emailController,
                      hintText: "Your email",
                      isEmail: true,
                      validator: (val) => (val == null || val.isEmpty)
                          ? "Enter your email"
                          : null,
                    ),
                    const SizedBox(height: 12.0),
                    MyTextField(
                      controller: _passwordController,
                      hintText: "Your password",
                      obscureText: true,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Enter your password";
                        }
                        if (val != _confirmPasswordController.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12.0),
                    MyTextField(
                      controller: _confirmPasswordController,
                      hintText: "Confirm password",
                      obscureText: true,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Confirm your password";
                        }
                        if (val != _passwordController.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                    ),
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Theme.of(context).secondaryHeaderColor,
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          showLoadingDialog(context);
                          final error = await registerUser(
                            username: _usernameController.text,
                            email: _emailController.text,
                            password: _passwordController.text,
                            context: context,
                          );
                          if (error != null) {
                            setState(() => errorMessage = error);
                          }
                        }
                      },
                      child: const Text("Register"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
