import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:just_audio/just_audio.dart';

/// Timing data for a single word in the story text.
class WordTiming {
  const WordTiming({
    required this.text,
    required this.startTime,
    required this.endTime,
    required this.charStart,
    required this.charEnd,
  });

  final String text;
  final double startTime;
  final double endTime;
  final int charStart;
  final int charEnd;
}

/// Parsed word-level timing data computed from ElevenLabs character alignment.
class WordTimingData {
  WordTimingData({required this.words});

  final List<WordTiming> words;

  /// Build word timings from character-level alignment data.
  /// [text] is the original story text.
  /// [characters] is the list of individual characters from the alignment.
  /// [charStartTimes] and [charEndTimes] are per-character timestamps in seconds.
  factory WordTimingData.fromCharacterAlignment({
    required String text,
    required List<String> characters,
    required List<double> charStartTimes,
    required List<double> charEndTimes,
  }) {
    final words = <WordTiming>[];

    // Walk the original text to find word boundaries
    final wordMatches = RegExp(r'\S+').allMatches(text);

    for (final match in wordMatches) {
      final wordText = match.group(0)!;
      final wordCharStart = match.start;
      final wordCharEnd = match.end;

      // Find the alignment indices that correspond to these character positions.
      // The alignment may have leading spaces, so we need to map text positions
      // to alignment positions by reconstructing the alignment string.
      final alignmentStr = characters.join();

      // Find where this word appears in the alignment string
      // Start searching from after previous words to handle duplicates
      final searchFrom = words.isEmpty
          ? 0
          : _findAlignmentIndex(alignmentStr, words.last.text,
                  _lastAlignmentEnd(words, alignmentStr)) +
              words.last.text.length;

      final alignStart = alignmentStr.indexOf(wordText, searchFrom);
      if (alignStart == -1) continue;

      final alignEnd = alignStart + wordText.length;

      // Get timing from alignment indices
      final startTime = (alignStart < charStartTimes.length)
          ? charStartTimes[alignStart]
          : 0.0;
      final endTime = (alignEnd - 1 < charEndTimes.length)
          ? charEndTimes[alignEnd - 1]
          : startTime;

      words.add(WordTiming(
        text: wordText,
        startTime: startTime,
        endTime: endTime,
        charStart: wordCharStart,
        charEnd: wordCharEnd,
      ));
    }

    return WordTimingData(words: words);
  }

  static int _findAlignmentIndex(String alignmentStr, String word, int from) {
    final idx = alignmentStr.indexOf(word, from);
    return idx == -1 ? 0 : idx;
  }

  static int _lastAlignmentEnd(List<WordTiming> words, String alignmentStr) {
    if (words.isEmpty) return 0;
    final last = words.last;
    // Rough estimate: search for the last word in alignment string
    final idx = alignmentStr.indexOf(last.text);
    return idx == -1 ? 0 : idx;
  }

  /// Returns the TextRange (in the original text) of the word being spoken
  /// at the given [positionSeconds], or null if past the end.
  TextRange? getHighlightedRange(double positionSeconds) {
    for (final word in words) {
      if (positionSeconds >= word.startTime &&
          positionSeconds < word.endTime) {
        return TextRange(start: word.charStart, end: word.charEnd);
      }
    }
    return null;
  }
}

/// Service that plays pre-generated ElevenLabs audio for story pages
/// and provides a word highlight stream synced to playback.
class StoryAudioService {
  StoryAudioService();

  final AudioPlayer _player = AudioPlayer();
  WordTimingData? _currentTimingData;
  StreamSubscription<Duration>? _positionSub;
  final _highlightController = StreamController<TextRange?>.broadcast();
  final _completionController = StreamController<void>.broadcast();
  bool _disposed = false;

  /// Stream of text ranges to highlight during playback.
  Stream<TextRange?> get highlightStream => _highlightController.stream;

  /// Stream that fires when audio playback completes.
  Stream<void> get completionStream => _completionController.stream;

  /// Check if pre-generated audio exists for a story page.
  Future<bool> hasAudio(String storyId, int pageIndex) async {
    try {
      await rootBundle.load('assets/audio/stories/$storyId/page_$pageIndex.mp3');
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Load audio and timestamps for a story page.
  /// Returns true if audio was loaded successfully, false if not available.
  Future<bool> loadPage({
    required String storyId,
    required int pageIndex,
    required String pageText,
  }) async {
    await stop();

    final audioPath = 'assets/audio/stories/$storyId/page_$pageIndex.mp3';
    final timestampPath =
        'assets/audio/stories/$storyId/page_${pageIndex}_timestamps.json';

    try {
      // Load timestamps
      final jsonStr = await rootBundle.loadString(timestampPath);
      final Map<String, dynamic> data = json.decode(jsonStr);

      final characters = (data['characters'] as List).cast<String>();
      final startTimes = (data['character_start_times_seconds'] as List)
          .map((e) => (e as num).toDouble())
          .toList();
      final endTimes = (data['character_end_times_seconds'] as List)
          .map((e) => (e as num).toDouble())
          .toList();

      _currentTimingData = WordTimingData.fromCharacterAlignment(
        text: pageText,
        characters: characters,
        charStartTimes: startTimes,
        charEndTimes: endTimes,
      );

      // Load audio
      await _player.setAsset(audioPath);

      // Listen for completion
      _player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed && !_disposed) {
          _highlightController.add(null);
          _completionController.add(null);
        }
      });

      return true;
    } catch (e) {
      _currentTimingData = null;
      return false;
    }
  }

  /// Start or resume playback. Sets up position tracking for word highlights.
  Future<void> play() async {
    _positionSub?.cancel();

    // Track position for highlighting
    _positionSub = _player.positionStream.listen((position) {
      if (_currentTimingData == null || _disposed) return;
      final seconds = position.inMilliseconds / 1000.0;
      final range = _currentTimingData!.getHighlightedRange(seconds);
      _highlightController.add(range);
    });

    await _player.play();
  }

  /// Pause playback.
  Future<void> pause() async {
    await _player.pause();
  }

  /// Resume playback (alias for play — just_audio resumes from pause).
  Future<void> resume() async {
    await _player.play();
  }

  /// Stop playback and reset.
  Future<void> stop() async {
    _positionSub?.cancel();
    _positionSub = null;
    await _player.stop();
    _highlightController.add(null);
  }

  /// Whether audio is currently playing.
  bool get isPlaying => _player.playing;

  /// Dispose resources.
  void dispose() {
    _disposed = true;
    _positionSub?.cancel();
    _highlightController.close();
    _completionController.close();
    _player.dispose();
  }
}
