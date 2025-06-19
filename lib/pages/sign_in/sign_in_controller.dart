import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:real_time_chat_app/services/auth_service.dart';

Future<String?> signInUser({
  required String email,
  required String password,
  required BuildContext context,
}) async {
  try {
    await authService.value.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (context.mounted) Navigator.pop(context);
    if (context.mounted) Navigator.pop(context);
    return null;
  } on FirebaseAuthException catch (e) {
    await Future.delayed(const Duration(milliseconds: 700));
    if (context.mounted) Navigator.pop(context);
    return e.message ?? "An error occurred";
  }
}
