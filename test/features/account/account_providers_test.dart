import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seedling/features/account/account_providers.dart';
import 'package:seedling/models/app_user.dart';

void main() {
  group('isPaidProvider', () {
    test('returns false when tier is free', () async {
      final container = ProviderContainer(overrides: [
        appUserProvider.overrideWith(
          (ref) => Stream.value(
            AppUser(id: 'u1', email: 'a@b.com', displayName: 'Test', tier: 'free'),
          ),
        ),
      ]);
      addTearDown(container.dispose);

      final result = await container.read(isPaidProvider.future);
      expect(result, false);
    });

    test('returns true when tier is paid', () async {
      final container = ProviderContainer(overrides: [
        appUserProvider.overrideWith(
          (ref) => Stream.value(
            AppUser(id: 'u1', email: 'a@b.com', displayName: 'Test', tier: 'paid'),
          ),
        ),
      ]);
      addTearDown(container.dispose);

      final result = await container.read(isPaidProvider.future);
      expect(result, true);
    });
  });
}
