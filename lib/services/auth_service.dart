import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

final ValueNotifier<AuthService> authService = ValueNotifier(AuthService());

class AuthService {
  final _instance = FirebaseAuth.instance;

  User? get currentUser => _instance.currentUser;

  Stream<User?> get authState => _instance.authStateChanges();

  Future<void> registerUserWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
  }) async {
    await _instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await currentUser!.updateDisplayName(username);
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> changeUsername({required String username}) async {
    await currentUser!.updateDisplayName(username);
  }

  Future<void> signOut() async {
    await _instance.signOut();
  }
}
