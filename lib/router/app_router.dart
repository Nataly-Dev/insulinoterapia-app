import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';

import '../screens/home/home_screen.dart';
import '../screens/bid_nph/bid_nph_screen.dart';
import '../screens/combined_tx_insulin/combined_tx_insulin_screen.dart';
import '../screens/combined_tx_intensified/combined_tx_intensified_screen.dart';
import '../screens/single_dose_pm/single_dose_pm_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/treatments/splashScreen.dart';

final appRouter = Provider<GoRouter>((ref) {
  final isLoggedIn = ref.watch(authProvider);
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/bidNph',
        builder: (context, state) => const BidNphScreen(),
      ),
      GoRoute(
        path: '/combinedTx',
        builder: (context, state) => const CombinedTxInsulinScreen(),
      ),
      GoRoute(
        path: '/txIntensified',
        builder: (context, state) => const CombinedTxItensifiedScreen(),
      ),
      GoRoute(
        path: '/singleDosePm',
        builder: (context, state) => const SingleDosePmScreen(),
      ),
    ],
    redirect: (context, state) {
      final location = state.uri.toString();

      // Si estamos en splash, decidir a dónde ir
      if (location == '/splash') {
        return isLoggedIn ? '/' : '/login';
      }

      // Si ya está logueado, no dejar volver a login
      if (isLoggedIn && location == '/login') {
        return '/';
      }

      // Si no está logueado y quiere entrar a cualquier otra ruta, mandarlo a login
      if (!isLoggedIn && location != '/login') {
        return '/login';
      }

      return null;
    },
  );
});
  /*return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final location = state.uri.toString();

      if (!isLoggedIn && location != '/login') {
        return '/login';
      }

      if (isLoggedIn && location == '/login') {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/bidNph',
        builder: (context, state) => const BidNphScreen(),
      ),
      GoRoute(
        path: '/combinedTx',
        builder: (context, state) => const CombinedTxInsulinScreen(),
      ),
      GoRoute(
        path: '/txIntensified',
        builder: (context, state) => const CombinedTxItensifiedScreen(),
      ),
      GoRoute(
        path: '/singleDosePm',
        builder: (context, state) => const SingleDosePmScreen(),
      ),
    ],
  );
});*/
