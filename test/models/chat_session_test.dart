import 'package:flutter_test/flutter_test.dart';
import 'package:seedling/models/models.dart';

void main() {
  group('ChatMessage', () {
    test('creates user message', () {
      const msg = ChatMessage(
        role: 'user',
        content: 'My child is having a tantrum',
        guideRefs: [],
      );
      expect(msg.role, 'user');
      expect(msg.isAssistant, false);
    });

    test('identifies assistant message', () {
      const msg = ChatMessage(
        role: 'assistant',
        content: 'Stay calm and get to their level.',
        guideRefs: ['guide-001'],
      );
      expect(msg.isAssistant, true);
      expect(msg.guideRefs, contains('guide-001'));
    });
  });

  group('SessionReport', () {
    test('creates from map', () {
      final report = SessionReport.fromMap({
        'summary': 'Good session',
        'skills_practiced': ['counting', 'colors'],
        'parent_follow_ups': ['Count together at home'],
        'ai_observations': '',
      });
      expect(report.summary, 'Good session');
      expect(report.skillsPracticed, hasLength(2));
    });
  });
}
