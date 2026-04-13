import 'package:flutter_test/flutter_test.dart';
import 'package:seedling/core/services/story_audio_service.dart';

void main() {
  group('WordTimingData', () {
    test('computes word boundaries from character timestamps', () {
      // "Hello world" = characters: H,e,l,l,o, ,w,o,r,l,d
      final data = WordTimingData.fromCharacterAlignment(
        text: 'Hello world',
        characters: ['H', 'e', 'l', 'l', 'o', ' ', 'w', 'o', 'r', 'l', 'd'],
        charStartTimes: [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0],
        charEndTimes: [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 1.1],
      );

      expect(data.words.length, 2);

      // "Hello" starts at char 0 (time 0.0), ends at char 4 (end time 0.5)
      expect(data.words[0].text, 'Hello');
      expect(data.words[0].startTime, closeTo(0.0, 0.001));
      expect(data.words[0].endTime, closeTo(0.5, 0.001));
      expect(data.words[0].charStart, 0);
      expect(data.words[0].charEnd, 5);

      // "world" starts at char 6 (time 0.6), ends at char 10 (end time 1.1)
      expect(data.words[1].text, 'world');
      expect(data.words[1].startTime, closeTo(0.6, 0.001));
      expect(data.words[1].endTime, closeTo(1.1, 0.001));
      expect(data.words[1].charStart, 6);
      expect(data.words[1].charEnd, 11);
    });

    test('handles leading/trailing spaces from normalized alignment', () {
      // normalized_alignment often has leading/trailing spaces
      final data = WordTimingData.fromCharacterAlignment(
        text: 'Hi there',
        characters: [' ', 'H', 'i', ' ', 't', 'h', 'e', 'r', 'e', ' '],
        charStartTimes: [0.0, 0.05, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8],
        charEndTimes: [0.05, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9],
      );

      expect(data.words.length, 2);
      expect(data.words[0].text, 'Hi');
      expect(data.words[1].text, 'there');
    });

    test('getHighlightedRange returns correct range at given time', () {
      final data = WordTimingData.fromCharacterAlignment(
        text: 'One two three',
        characters: ['O', 'n', 'e', ' ', 't', 'w', 'o', ' ', 't', 'h', 'r', 'e', 'e'],
        charStartTimes: [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 1.1, 1.2],
        charEndTimes: [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 1.1, 1.2, 1.3],
      );

      // At time 0.15, should be highlighting "One" (0.0-0.3)
      final range1 = data.getHighlightedRange(0.15);
      expect(range1, isNotNull);
      expect(range1!.start, 0);
      expect(range1.end, 3);

      // At time 0.55, should be highlighting "two" (0.4-0.7)
      final range2 = data.getHighlightedRange(0.55);
      expect(range2, isNotNull);
      expect(range2!.start, 4);
      expect(range2.end, 7);

      // At time 2.0, past all words — null
      final range3 = data.getHighlightedRange(2.0);
      expect(range3, isNull);
    });
  });
}
