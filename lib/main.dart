// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; 


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MyApp()));
}
/*void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("✅ Firebase initialized successfully");
  } catch (e, s) {
    // En release se puede usar FlutterError.onError para que no se quede en negro
    FlutterError.onError = (details) {
      print('❌ Firebase init error: $details');
    };
    print("❌ Firebase initialization failed: $e\n$s");
  }

  runApp(const ProviderScope(child: MyApp()));
}*/


class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouter); // Usamos el router de Riverpod

    return MaterialApp.router(
      title: 'Insulina App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
