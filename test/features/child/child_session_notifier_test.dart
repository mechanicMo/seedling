import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedling/features/child/child_providers.dart';
import 'package:seedling/models/models.dart';

void main() {
  group('ChildSessionNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() => container.dispose());

    test('initial state has no session ID and empty activities', () {
      final state = container.read(childSessionProvider);
      expect(state.sessionId, isNull);
      expect(state.completedActivities, isEmpty);
      expect(state.elapsedSeconds, 0);
      expect(state.isComplete, false);
    });

    test('setSessionId stores the session ID', () {
      container.read(childSessionProvider.notifier).setSessionId('test-session-1');
      expect(container.read(childSessionProvider).sessionId, 'test-session-1');
    });

    test('markActivityComplete adds entry to completedActivities', () {
      const activity = ChildActivity(
        id: 'act-1',
        title: 'Colors Game',
        type: 'game',
        skillsTargeted: ['color recognition'],
        parentFollowUp: 'Ask about colors at dinner',
      );
      container.read(childSessionProvider.notifier).markActivityComplete(activity, 180);
      final state = container.read(childSessionProvider);
      expect(state.completedActivities.length, 1);
      expect(state.completedActivities.first.activityId, 'act-1');
      expect(state.completedActivities.first.durationSeconds, 180);
    });

    test('tickSecond increments elapsedSeconds', () {
      container.read(childSessionProvider.notifier).tickSecond();
      container.read(childSessionProvider.notifier).tickSecond();
      expect(container.read(childSessionProvider).elapsedSeconds, 2);
    });

    test('elapsedMinutes rounds down', () {
      for (var i = 0; i < 90; i++) {
        container.read(childSessionProvider.notifier).tickSecond();
      }
      expect(container.read(childSessionProvider).elapsedMinutes, 1);
    });

    test('markComplete sets isComplete to true', () {
      container.read(childSessionProvider.notifier).markComplete();
      expect(container.read(childSessionProvider).isComplete, true);
    });

    test('reset clears all state', () {
      container.read(childSessionProvider.notifier)
        ..setSessionId('s1')
        ..markComplete();
      container.read(childSessionProvider.notifier).reset();
      final state = container.read(childSessionProvider);
      expect(state.sessionId, isNull);
      expect(state.isComplete, false);
    });
  });
}
