import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:seedling/features/profiles/profiles_screen.dart';
import 'package:seedling/features/profiles/profiles_provider.dart';
import 'package:seedling/models/models.dart';

void main() {
  testWidgets('profile tile popup contains Settings option', (tester) async {
    final profile = ChildProfile(
      id: 'child-1',
      name: 'Sherani',
      birthDate: DateTime(2023, 2, 1),
      ageRange: '3-7',
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          childProfilesProvider.overrideWith(
            (ref) => Stream.value([profile]),
          ),
        ],
        child: MaterialApp.router(
          routerConfig: GoRouter(
            routes: [
              GoRoute(
                path: '/',
                builder: (_, __) => const ProfilesScreen(),
              ),
            ],
          ),
        ),
      ),
    );

    await tester.pump();

    // Open the popup menu on the profile tile
    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();

    // Verify "Settings" option exists
    expect(find.text('Settings'), findsOneWidget);
  });
}
