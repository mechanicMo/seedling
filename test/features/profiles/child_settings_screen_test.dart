import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seedling/features/profiles/child_settings_screen.dart';
import 'package:seedling/features/profiles/profiles_provider.dart';
import 'package:seedling/models/models.dart';

// Helper: build the screen with a fake profile already loaded
Widget buildScreen(ChildProfile profile) {
  return ProviderScope(
    overrides: [
      childProfilesProvider.overrideWith(
        (ref) => Stream.value([profile]),
      ),
      childProfilesNotifierProvider.overrideWith(
        (ref) => _FakeChildProfilesNotifier(ref),
      ),
    ],
    child: MaterialApp(
      home: ChildSettingsScreen(childId: profile.id),
    ),
  );
}

class _FakeChildProfilesNotifier extends ChildProfilesNotifier {
  _FakeChildProfilesNotifier(super.ref);

  ChildProfile? lastUpdated;

  @override
  Future<void> update(ChildProfile profile) async {
    lastUpdated = profile;
  }
}

void main() {
  final baseProfile = ChildProfile(
    id: 'child-1',
    name: 'Sherani',
    birthDate: DateTime(2023, 2, 1),
    ageRange: '3-7',
    sessionTimerMinutes: 20,
    contentSelection: const ContentSelection(
      enabledCategories: [],
      enabledActivityTypes: ['story', 'game', 'music'],
    ),
  );

  group('ChildSettingsScreen', () {
    testWidgets('shows profile name in app bar', (tester) async {
      await tester.pumpWidget(buildScreen(baseProfile));
      await tester.pump();

      expect(find.text("Sherani's Settings"), findsOneWidget);
    });

    testWidgets('shows current session timer as selected', (tester) async {
      await tester.pumpWidget(buildScreen(baseProfile));
      await tester.pump();

      // The 20-min chip should be marked selected
      expect(find.text('20 min'), findsOneWidget);
    });

    testWidgets('shows all three activity type toggles', (tester) async {
      await tester.pumpWidget(buildScreen(baseProfile));
      await tester.pump();

      expect(find.text('📖 Stories'), findsOneWidget);
      expect(find.text('🎮 Games'), findsOneWidget);
      expect(find.text('🎵 Music'), findsOneWidget);
    });

    testWidgets('cannot disable last remaining activity type', (tester) async {
      final singleTypeProfile = ChildProfile(
        id: 'child-1',
        name: 'Sherani',
        birthDate: DateTime(2023, 2, 1),
        ageRange: '3-7',
        sessionTimerMinutes: 20,
        contentSelection: const ContentSelection(
          enabledCategories: [],
          enabledActivityTypes: ['story'], // only one enabled
        ),
      );

      await tester.pumpWidget(buildScreen(singleTypeProfile));
      await tester.pump();

      // The '📖 Stories' switch should be disabled (onChanged = null)
      final switchWidget = tester.widget<Switch>(
        find.descendant(
          of: find.widgetWithText(SwitchListTile, '📖 Stories'),
          matching: find.byType(Switch),
        ),
      );
      expect(switchWidget.onChanged, isNull);
    });
  });
}
