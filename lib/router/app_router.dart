import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:seedling/features/auth/auth_providers.dart';
import 'package:seedling/features/auth/login_screen.dart';
import 'package:seedling/features/auth/signup_screen.dart';
import 'package:seedling/features/dashboard/dashboard_screen.dart';
import 'package:seedling/features/nav/main_shell.dart';
import 'package:seedling/features/onboarding/onboarding_screen.dart';
import 'package:seedling/features/parent/ai_chat_screen.dart';
import 'package:seedling/features/parent/content_library_screen.dart';
import 'package:seedling/features/parent/guide_detail_screen.dart';
import 'package:seedling/features/parent/session_reports_screen.dart';
import 'package:seedling/features/parent/situation_guide_screen.dart';
import 'package:seedling/features/profiles/add_edit_profile_screen.dart';
import 'package:seedling/features/profiles/profiles_screen.dart';
import 'package:seedling/services/firestore_service.dart';

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

      if (!isLoggedIn && !isOnAuthPath) return '/login';

      if (isLoggedIn && isOnAuthPath) {
        final hasProfiles = await firestoreService.hasChildProfiles(user.uid);
        return hasProfiles ? '/' : '/onboarding';
      }

      if (isLoggedIn && isOnOnboarding) return null;

      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/signup', builder: (_, __) => const SignupScreen()),
      GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),

      // Parent shell with bottom nav
      StatefulShellRoute.indexedStack(
        builder: (_, __, shell) => MainShell(navigationShell: shell),
        branches: [
          // Tab 0: Home / Dashboard
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/',
              builder: (_, __) => const DashboardScreen(),
              routes: [
                GoRoute(
                  path: 'profiles',
                  builder: (_, __) => const ProfilesScreen(),
                ),
                GoRoute(
                  path: 'profiles/add',
                  builder: (_, __) => const AddEditProfileScreen(),
                ),
                GoRoute(
                  path: 'profiles/edit/:childId',
                  builder: (context, state) => AddEditProfileScreen(
                    childId: state.pathParameters['childId'],
                  ),
                ),
              ],
            ),
          ]),

          // Tab 1: Situation Guide
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/guidance',
              builder: (_, __) => const SituationGuideScreen(),
              routes: [
                GoRoute(
                  path: 'chat',
                  builder: (context, state) => AiChatScreen(
                    initialSituation: state.extra as String?,
                  ),
                ),
                GoRoute(
                  path: 'guide/:guideId',
                  builder: (context, state) => GuideDetailScreen(
                    guideId: state.pathParameters['guideId']!,
                  ),
                ),
              ],
            ),
          ]),

          // Tab 2: Content Library
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/library',
              builder: (_, __) => const ContentLibraryScreen(),
              routes: [
                GoRoute(
                  path: 'guide/:guideId',
                  builder: (context, state) => GuideDetailScreen(
                    guideId: state.pathParameters['guideId']!,
                  ),
                ),
              ],
            ),
          ]),

          // Tab 3: Session Reports
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/reports',
              builder: (_, __) => const SessionReportsScreen(),
            ),
          ]),
        ],
      ),
    ],
  );
});
