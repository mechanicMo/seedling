import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seedling/features/account/account_providers.dart';
import 'package:seedling/models/app_user.dart';
import 'package:seedling/core/constants/app_constants.dart';

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

  group('subscriptionStatusProvider', () {
    ProviderContainer makeContainer({
      required String tier,
      required int aiQueriesUsed,
      required int reportsUsed,
      required int profileCount,
    }) {
      return ProviderContainer(overrides: [
        appUserProvider.overrideWith(
          (ref) => Stream.value(
            AppUser(id: 'u1', email: 'a@b.com', displayName: 'Test', tier: tier),
          ),
        ),
        aiQueriesUsedTodayProvider.overrideWith((ref) async => aiQueriesUsed),
        sessionReportsUsedThisMonthProvider.overrideWith((ref) async => reportsUsed),
        childProfileCountProvider.overrideWith((ref) async => profileCount),
      ]);
    }

    test('free user under all limits — all green', () async {
      final container = makeContainer(tier: 'free', aiQueriesUsed: 5, reportsUsed: 3, profileCount: 1);
      addTearDown(container.dispose);
      final status = await container.read(subscriptionStatusProvider.future);
      expect(status.isPaid, false);
      expect(status.canAddChild, true);
      expect(status.canSendAiMessage, true);
      expect(status.aiQueriesRemaining, AppConstants.freeAiQueriesPerDay - 5);
      expect(status.sessionReportsRemaining, AppConstants.freeSessionReportsPerMonth - 3);
    });

    test('free user at profile limit — canAddChild is false', () async {
      final container = makeContainer(tier: 'free', aiQueriesUsed: 0, reportsUsed: 0, profileCount: AppConstants.freeChildProfileLimit);
      addTearDown(container.dispose);
      final status = await container.read(subscriptionStatusProvider.future);
      expect(status.canAddChild, false);
    });

    test('free user at AI limit — canSendAiMessage is false', () async {
      final container = makeContainer(tier: 'free', aiQueriesUsed: AppConstants.freeAiQueriesPerDay, reportsUsed: 0, profileCount: 0);
      addTearDown(container.dispose);
      final status = await container.read(subscriptionStatusProvider.future);
      expect(status.canSendAiMessage, false);
      expect(status.aiQueriesRemaining, 0);
    });

    test('paid user at all limits — all green', () async {
      final container = makeContainer(tier: 'paid', aiQueriesUsed: 100, reportsUsed: 100, profileCount: 10);
      addTearDown(container.dispose);
      final status = await container.read(subscriptionStatusProvider.future);
      expect(status.canAddChild, true);
      expect(status.canSendAiMessage, true);
    });
  });
}
