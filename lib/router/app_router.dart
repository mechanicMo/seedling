import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:seedling/features/auth/auth_providers.dart';
// Screen imports will be added in Tasks 8-12
// import 'package:seedling/features/auth/login_screen.dart';
// import 'package:seedling/features/auth/signup_screen.dart';
// import 'package:seedling/features/dashboard/dashboard_screen.dart';
// import 'package:seedling/features/onboarding/onboarding_screen.dart';
// import 'package:seedling/features/profiles/add_edit_profile_screen.dart';
// import 'package:seedling/features/profiles/profiles_screen.dart';
import 'package:seedling/services/firestore_service.dart';

/// Bridges a Stream into a ChangeNotifier so go_router re-runs redirect
/// logic whenever auth state changes.
class _GoRouterRefreshStream extends ChangeNotifier {
  _GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

/// Provides the app router with auth-based redirect logic and route structure.
/// Requires screens to be implemented in Tasks 8-12.
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final firestoreService = FirestoreService();

  return GoRouter(
    debugLogDiagnostics: true,
    refreshListenable: _GoRouterRefreshStream(
      ref.watch(authStateProvider.stream),
    ),
    redirect: (context, state) async {
      final user = authState.valueOrNull;
      final isLoggedIn = user != null;
      final isOnAuthPath = state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup';
      final isOnOnboarding = state.matchedLocation == '/onboarding';

      // Not logged in — send to login
      if (!isLoggedIn && !isOnAuthPath) return '/login';

      // Logged in, on auth screen — check if needs onboarding
      if (isLoggedIn && isOnAuthPath) {
        final hasProfiles = await firestoreService.hasChildProfiles(user.uid);
        return hasProfiles ? '/' : '/onboarding';
      }

      // Logged in, just finished onboarding — allow navigation
      if (isLoggedIn && isOnOnboarding) return null;

      return null;
    },
    routes: [
      // TODO: Uncomment when LoginScreen is implemented (Task 8)
      // GoRoute(
      //   path: '/login',
      //   builder: (_, __) => const LoginScreen(),
      // ),
      // TODO: Uncomment when SignupScreen is implemented (Task 8)
      // GoRoute(
      //   path: '/signup',
      //   builder: (_, __) => const SignupScreen(),
      // ),
      // TODO: Uncomment when OnboardingScreen is implemented (Task 9)
      // GoRoute(
      //   path: '/onboarding',
      //   builder: (_, __) => const OnboardingScreen(),
      // ),
      // TODO: Uncomment when DashboardScreen is implemented (Task 10)
      // GoRoute(
      //   path: '/',
      //   builder: (_, __) => const DashboardScreen(),
      //   routes: [
      //     // TODO: Uncomment when ProfilesScreen is implemented (Task 11)
      //     // GoRoute(
      //     //   path: 'profiles',
      //     //   builder: (_, __) => const ProfilesScreen(),
      //     // ),
      //     // TODO: Uncomment when AddEditProfileScreen is implemented (Task 12)
      //     // GoRoute(
      //     //   path: 'profiles/add',
      //     //   builder: (_, __) => const AddEditProfileScreen(),
      //     // ),
      //     // GoRoute(
      //     //   path: 'profiles/edit/:childId',
      //     //   builder: (context, state) => AddEditProfileScreen(
      //     //     childId: state.pathParameters['childId'],
      //     //   ),
      //     // ),
      //   ],
      // ),
    ],
  );
});
