import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedling/features/auth/auth_providers.dart';

void main() {
  group('authStateProvider', () {
    test('provider can be read with mock auth', () {
      final mockAuth = MockFirebaseAuth();
      final container = ProviderContainer(
        overrides: [firebaseAuthProvider.overrideWithValue(mockAuth)],
      );
      addTearDown(container.dispose);

      final authState = container.read(authStateProvider);
      expect(authState, isNotNull);
    });

    test('provider can be read with signed-in mock auth', () {
      final mockAuth = MockFirebaseAuth(signedIn: true);
      final container = ProviderContainer(
        overrides: [firebaseAuthProvider.overrideWithValue(mockAuth)],
      );
      addTearDown(container.dispose);

      final authState = container.read(authStateProvider);
      expect(authState, isNotNull);
    });
  });

  group('AuthNotifier', () {
    test('authNotifierProvider can be accessed', () {
      final mockAuth = MockFirebaseAuth();
      final container = ProviderContainer(
        overrides: [firebaseAuthProvider.overrideWithValue(mockAuth)],
      );
      addTearDown(container.dispose);

      final notifier = container.read(authNotifierProvider);
      expect(notifier, isNotNull);
    });
  });
}
