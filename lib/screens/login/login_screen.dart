import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  bool _error = false;
  bool _isLoading = false;

  Future<void> _verifyCode() async {
    final code = _controllers.map((e) => e.text).join();

    setState(() {
      _isLoading = true;
      _error = false;
    });

    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('login')
              .doc('CIx3FJ37JB09FB5msBji') // <- usa este ID exacto
              .get();

      final correctCode = doc.data()?['code'];

      if (code.trim() == correctCode.trim()) {
        final prefs = await SharedPreferences.getInstance();
        final expiry = DateTime.now().add(const Duration(minutes: 30));
        await prefs.setString("session_expiry", expiry.toIso8601String());

        ref.read(authProvider.notifier).login(); // <- ¡Aquí es donde logueamos!

        if (!mounted) return;
        context.go('/home');
      } else {
        setState(() => _error = true);
      }
    } catch (e) {
      setState(() => _error = true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Autenticación"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Ingrese el código de acceso",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(4, (index) {
                    return SizedBox(
                      width: 50,
                      child: TextField(
                        controller: _controllers[index],
                        autofocus: index == 0,
                        obscureText: true,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        decoration: InputDecoration(
                          counterText: '',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: _error ? Colors.red : colorScheme.primary,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: _error ? Colors.red : colorScheme.primary,
                              width: 2,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() => _error = false);
                          if (value.isNotEmpty && index < 3) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _verifyCode,
                    child: SizedBox(
                      height: 24,
                      child:
                          _isLoading
                              ? const CircularProgressIndicator(strokeWidth: 2)
                              : const Text("Ingresar"),
                    ),
                  ),
                ),
                if (_error)
                  const Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: Text(
                      "Código incorrecto o error de conexión",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
