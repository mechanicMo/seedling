import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seedling/features/parent/ai_chat_notifier.dart';
import 'package:seedling/features/account/account_providers.dart';
import 'package:seedling/features/profiles/profiles_provider.dart';
import 'package:seedling/models/child_profile.dart';

ChildProfile _fakeProfile() => ChildProfile(
  id: 'c1',
  name: 'Alice',
  birthDate: DateTime(2022, 1, 1),
  ageRange: '3-7',
  sessionTimerMinutes: 20,
  contentSelection: const ContentSelection(enabledActivityTypes: ['story']),
);

void main() {
  test('sendMessage sets error when canSendAiMessage is false', () async {
    final profile = _fakeProfile();
    final container = ProviderContainer(overrides: [
      childProfilesProvider.overrideWith(
        (ref) => Stream.value([profile]),
      ),
      activeChildProfileProvider.overrideWith(
        (ref) => ActiveChildProfileNotifier(ref)..state = profile,
      ),
      subscriptionStatusProvider.overrideWith((ref) async => SubscriptionStatus(
        isPaid: false,
        canAddChild: true,
        canSendAiMessage: false,
        aiQueriesRemaining: 0,
        sessionReportsRemaining: 5,
        canViewSessionReports: true,
      )),
    ]);
    addTearDown(container.dispose);

    final notifier = container.read(aiChatProvider.notifier);
    await notifier.sendMessage('My child is having a tantrum');

    final state = container.read(aiChatProvider);
    expect(state.error, contains('daily limit'));
  });
}
