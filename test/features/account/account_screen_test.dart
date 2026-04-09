import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seedling/features/account/account_screen.dart';
import 'package:seedling/features/account/account_providers.dart';
import 'package:seedling/models/app_user.dart';

void main() {
  Widget buildScreen({String tier = 'free'}) {
    return ProviderScope(
      overrides: [
        appUserProvider.overrideWith(
          (ref) => Stream.value(
            AppUser(id: 'u1', email: 'test@example.com', displayName: 'Alice', tier: tier),
          ),
        ),
        isPaidProvider.overrideWith((ref) async => tier == 'paid'),
        subscriptionStatusProvider.overrideWith((ref) async => SubscriptionStatus(
          isPaid: tier == 'paid',
          canAddChild: true,
          canSendAiMessage: true,
          aiQueriesRemaining: 15,
          sessionReportsRemaining: 8,
          canViewSessionReports: true,
        )),
      ],
      child: const MaterialApp(home: AccountScreen()),
    );
  }

  testWidgets('shows email and display name', (tester) async {
    await tester.pumpWidget(buildScreen());
    await tester.pumpAndSettle();
    expect(find.text('Alice'), findsOneWidget);
    expect(find.text('test@example.com'), findsOneWidget);
  });

  testWidgets('free user sees Free tier badge and Upgrade button', (tester) async {
    await tester.pumpWidget(buildScreen(tier: 'free'));
    await tester.pumpAndSettle();
    expect(find.text('Free'), findsOneWidget);
    expect(find.text('Upgrade to Premium'), findsOneWidget);
  });

  testWidgets('paid user sees Premium badge, no upgrade button', (tester) async {
    await tester.pumpWidget(buildScreen(tier: 'paid'));
    await tester.pumpAndSettle();
    expect(find.text('Premium'), findsOneWidget);
    expect(find.text('Upgrade to Premium'), findsNothing);
  });

  testWidgets('shows AI queries remaining for free user', (tester) async {
    await tester.pumpWidget(buildScreen(tier: 'free'));
    await tester.pumpAndSettle();
    expect(find.textContaining('15'), findsWidgets);
  });
}
