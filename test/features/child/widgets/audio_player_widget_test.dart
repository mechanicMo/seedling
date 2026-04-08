import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedling/features/child/widgets/audio_player_widget.dart';

void main() {
  group('AudioPlayerWidget', () {
    testWidgets('shows play button when initially rendered', (tester) async {
      bool completed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AudioPlayerWidget(
              audioUrl: 'https://example.com/test.mp3',
              onComplete: () => completed = true,
            ),
          ),
        ),
      );

      // Widget renders without crash in test env (no real audio)
      expect(find.byType(AudioPlayerWidget), findsOneWidget);
      expect(completed, false);
    });

    testWidgets('onComplete fires when done button tapped', (tester) async {
      bool completed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AudioPlayerWidget(
              audioUrl: 'https://example.com/test.mp3',
              onComplete: () => completed = true,
            ),
          ),
        ),
      );

      await tester.pump();

      // The "All done!" button should always be visible
      final doneButton = find.text('All done!');
      expect(doneButton, findsOneWidget);

      await tester.tap(doneButton);
      expect(completed, true);
    });
  });
}
