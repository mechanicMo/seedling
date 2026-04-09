import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:seedling/features/profiles/profiles_screen.dart';
import 'package:seedling/features/profiles/profiles_provider.dart';
import 'package:seedling/features/account/account_providers.dart';
import 'package:seedling/models/child_profile.dart';

ChildProfile _fakeProfile(String id, String name) => ChildProfile(
  id: id,
  name: name,
  birthDate: DateTime(2022, 1, 1),
  ageRange: '3-7',
  sessionTimerMinutes: 20,
  contentSelection: const ContentSelection(enabledActivityTypes: ['story']),
);

SubscriptionStatus _freeStatus({required bool canAdd}) => SubscriptionStatus(
  isPaid: false,
  canAddChild: canAdd,
  canSendAiMessage: true,
  aiQueriesRemaining: 15,
  sessionReportsRemaining: 8,
  canViewSessionReports: true,
);

Widget buildProfilesScreen(List<ChildProfile> profiles, SubscriptionStatus status) {
  final router = GoRouter(routes: [
    GoRoute(path: '/', builder: (_, __) => const ProfilesScreen()),
    GoRoute(path: '/profiles/add', builder: (_, __) => const Scaffold()),
  ]);
  return ProviderScope(
    overrides: [
      childProfilesProvider.overrideWith((ref) => Stream.value(profiles)),
      subscriptionStatusProvider.overrideWith((ref) async => status),
    ],
    child: MaterialApp.router(routerConfig: router),
  );
}

void main() {
  testWidgets('add button works normally when under limit', (tester) async {
    final profiles = [_fakeProfile('1', 'Alice')];
    await tester.pumpWidget(buildProfilesScreen(profiles, _freeStatus(canAdd: true)));
    await tester.pumpAndSettle();
    expect(find.byType(FloatingActionButton), findsOneWidget);
    final fab = tester.widget<FloatingActionButton>(find.byType(FloatingActionButton));
    expect(fab.onPressed, isNotNull);
  });

  testWidgets('shows paywall dialog when add attempted at limit', (tester) async {
    final profiles = List.generate(3, (i) => _fakeProfile('$i', 'Child $i'));
    await tester.pumpWidget(buildProfilesScreen(profiles, _freeStatus(canAdd: false)));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    expect(find.textContaining('profile limit'), findsOneWidget);
  });
}
