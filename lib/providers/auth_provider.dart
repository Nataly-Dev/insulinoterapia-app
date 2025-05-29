// en auth_provider.dart
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
final authProvider = StateNotifierProvider<AuthNotifier, bool>(
  (ref) => AuthNotifier(),
);
class AuthNotifier extends StateNotifier<bool> {
  AuthNotifier() : super(false);

  Timer? _logoutTimer;

  void login() {
    state = true;
    _logoutTimer?.cancel(); // cancelamos si ya había uno
    _logoutTimer = Timer(const Duration(minutes: 30), () {
      state = false; // cerrar sesión después de 30 min
    });
  }

  void logout() {
    _logoutTimer?.cancel();
    state = false;
  }

  @override
  void dispose() {
    _logoutTimer?.cancel();
    super.dispose();
  }
}
