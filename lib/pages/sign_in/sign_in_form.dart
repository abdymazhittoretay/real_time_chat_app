import 'package:flutter/material.dart';
import 'package:real_time_chat_app/widgets/my_text_field.dart';
import 'package:real_time_chat_app/utils/loading_dialog.dart';
import 'sign_in_controller.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String errorMessage = "";

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Text(errorMessage, style: const TextStyle(color: Colors.red)),
          const SizedBox(height: 6.0),
          MyTextField(
            controller: _emailController,
            hintText: "Your email",
            isEmail: true,
            validator: (value) =>
                (value == null || value.isEmpty) ? "Enter your email" : null,
          ),
          const SizedBox(height: 12.0),
          MyTextField(
            controller: _passwordController,
            hintText: "Your password",
            obscureText: true,
            validator: (value) =>
                (value == null || value.isEmpty) ? "Enter your password" : null,
          ),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.maxFinite, 50),
            ),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                showLoadingDialog(context);
                final error = await signInUser(
                  email: _emailController.text,
                  password: _passwordController.text,
                  context: context,
                );
                if (error != null) {
                  setState(() => errorMessage = error);
                }
              }
            },
            child: const Text("Sign In"),
          ),
        ],
      ),
    );
  }
}
