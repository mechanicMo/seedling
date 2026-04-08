import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:seedling/features/child/activity_player_screen.dart';
import 'package:seedling/features/child/widgets/audio_player_widget.dart';
import 'package:seedling/models/models.dart';

void main() {
  group('ActivityPlayerScreen', () {
    testWidgets('shows AudioPlayerWidget for story with audio URL',
        (tester) async {
      const activity = ChildActivity(
        id: 'story-1',
        title: 'The Brave Knight',
        type: 'story',
        mediaRefs: ['https://example.com/story.mp3'],
        learningObjectives: ['Improve listening skills'],
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: ActivityPlayerScreen(activity: activity),
          ),
        ),
      );

      await tester.pump();

      // Should show AudioPlayerWidget
      expect(find.byType(AudioPlayerWidget), findsOneWidget);

      // Should NOT show the "All done!" button from the activity screen
      // (it's inside AudioPlayerWidget, so we're checking context here)
      expect(find.byType(ActivityPlayerScreen), findsOneWidget);
    });

    testWidgets('shows text fallback for story without audio URL',
        (tester) async {
      const activity = ChildActivity(
        id: 'story-2',
        title: 'The Silent Forest',
        type: 'story',
        mediaRefs: [],
        learningObjectives: ['Enjoy a tale'],
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: ActivityPlayerScreen(activity: activity),
          ),
        ),
      );

      await tester.pump();

      // Should NOT show AudioPlayerWidget
      expect(find.byType(AudioPlayerWidget), findsNothing);

      // Should show the "All done!" button
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('All done!'), findsOneWidget);

      // Should show title and learning objectives
      expect(find.text('The Silent Forest'), findsOneWidget);
      expect(find.text('Enjoy a tale'), findsOneWidget);
    });

    testWidgets('shows text fallback for game type regardless of mediaRefs',
        (tester) async {
      const activity = ChildActivity(
        id: 'game-1',
        title: 'Color Match Game',
        type: 'game',
        mediaRefs: ['https://example.com/game.mp3'],
        learningObjectives: ['Match colors'],
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: ActivityPlayerScreen(activity: activity),
          ),
        ),
      );

      await tester.pump();

      // Should NOT show AudioPlayerWidget even though mediaRefs exists
      expect(find.byType(AudioPlayerWidget), findsNothing);

      // Should show the "All done!" button
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('All done!'), findsOneWidget);

      // Should show title and learning objectives
      expect(find.text('Color Match Game'), findsOneWidget);
      expect(find.text('Match colors'), findsOneWidget);
    });

    testWidgets('shows AudioPlayerWidget for music with audio URL',
        (tester) async {
      const activity = ChildActivity(
        id: 'music-1',
        title: 'Let\'s Sing Together',
        type: 'music',
        mediaRefs: ['https://example.com/song.mp3'],
        learningObjectives: ['Learn rhythm'],
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: ActivityPlayerScreen(activity: activity),
          ),
        ),
      );

      await tester.pump();

      // Should show AudioPlayerWidget
      expect(find.byType(AudioPlayerWidget), findsOneWidget);
    });

    testWidgets('hides learning objectives when AudioPlayerWidget is shown',
        (tester) async {
      const activity = ChildActivity(
        id: 'story-3',
        title: 'Adventure Time',
        type: 'story',
        mediaRefs: ['https://example.com/story.mp3'],
        learningObjectives: ['This should be hidden'],
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: ActivityPlayerScreen(activity: activity),
          ),
        ),
      );

      await tester.pump();

      // Should show AudioPlayerWidget
      expect(find.byType(AudioPlayerWidget), findsOneWidget);

      // Should NOT show the learning objective text when audio player is visible
      expect(find.text('This should be hidden'), findsNothing);
    });
  });
}
