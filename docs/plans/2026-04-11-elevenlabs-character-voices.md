# ElevenLabs Character Voices Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the robotic flutter_tts narrator with pre-generated ElevenLabs character voices — Sparks (Jessica), Clover (Lily), Zee (Laura) — with word-by-word highlighting synced to character-level timestamps.

**Architecture:** A Python script pre-generates MP3 audio + timestamp JSON for every story page by calling ElevenLabs' `/with-timestamps` endpoint. The Flutter app loads these assets at runtime via `just_audio` and syncs word highlighting using a position stream. `flutter_tts` is retained as a fallback for any content without pre-generated audio.

**Tech Stack:** ElevenLabs API (eleven_multilingual_v2), Python 3 (generation script), just_audio (Flutter playback), Dart (word timing service)

---

## Voice Mapping

| Character | Voice | Voice ID |
|---|---|---|
| Sparks | Jessica — Playful, Bright, Warm | `cgSgspJ2msm6clMCkdW9` |
| Clover | Lily — Velvety Actress | `pFZP5JQG7iQjIQuC4Bku` |
| Zee | Laura — Enthusiast, Quirky | `FGY2WhTYpPnrIDTdsKH5` |

**Model:** `eleven_multilingual_v2`

**Budget:** 42 pages × ~68 chars avg = ~2,861 characters (28.6% of the 10k free tier)

---

## File Structure

```
scripts/
  generate_story_audio.py          # One-off generation script

assets/audio/stories/
  activity-big-world-little-hands/
    page_0.mp3                     # Audio for page 0
    page_0_timestamps.json         # Character-level timing data
    page_1.mp3
    page_1_timestamps.json
    ...
  activity-clover-counts-the-steps/
    ...
  (7 story directories, 6 pages each = 42 mp3 + 42 json)

lib/core/services/
  story_audio_service.dart         # Loads audio + timestamps, plays, provides highlight stream

lib/features/child/widgets/
  story_reader_widget.dart         # Modified: uses StoryAudioService, falls back to flutter_tts
```

---

## Task 1: Audio Generation Script

**Files:**
- Create: `scripts/generate_story_audio.py`

This script reads the API key from `.env`, iterates through all 7 stories / 42 pages, calls ElevenLabs for each page with the correct character voice, and saves the MP3 + timestamps JSON.

- [ ] **Step 1: Create the generation script**

```python
#!/usr/bin/env python3
"""Generate ElevenLabs audio + timestamps for all seeded Seedling stories."""

import base64
import json
import os
import time
from pathlib import Path
from urllib.request import Request, urlopen

# Load API key from .env
env_path = Path(__file__).parent.parent / ".env"
API_KEY = None
for line in env_path.read_text().splitlines():
    if line.startswith("ELEVENLABS_API_KEY="):
        API_KEY = line.split("=", 1)[1].strip()
        break

if not API_KEY:
    raise SystemExit("ELEVENLABS_API_KEY not found in .env")

VOICE_MAP = {
    "sparks": "cgSgspJ2msm6clMCkdW9",  # Jessica
    "clover": "pFZP5JQG7iQjIQuC4Bku",  # Lily
    "zee": "FGY2WhTYpPnrIDTdsKH5",      # Laura
}

MODEL_ID = "eleven_multilingual_v2"
BASE_URL = "https://api.elevenlabs.io/v1/text-to-speech"
OUTPUT_DIR = Path(__file__).parent.parent / "assets" / "audio" / "stories"

# All 7 seeded stories — character and pages
STORIES = {
    "activity-big-world-little-hands": {
        "character": "sparks",
        "pages": [
            "Once upon a time, Sparks woke up in a BIG house.",
            "The stairs looked so tall! But Sparks was excited to explore.",
            "Then Sparks found a tiny mouse! It was so small compared to Sparks.",
            'The mouse showed Sparks a big cheese. "This is BIG for me!" said the mouse.',
            "Sparks learned that big and small are just different ways to look at the world.",
            "Everything has its own size, and that makes the world interesting!",
        ],
    },
    "activity-clover-counts-the-steps": {
        "character": "clover",
        "pages": [
            "Clover loved patterns and routines. Today was a BIG day!",
            '"I need to climb the stairs," said Clover. "One... two... three..."',
            "Step by step, Clover counted each one. The pattern was soothing.",
            'Sometimes the steps felt hard, but Clover kept counting: "Four... five... six..."',
            'Almost there! "Seven... eight... nine... TEN!"',
            "Clover made it to the top! The pattern was complete, and Clover felt proud.",
        ],
    },
    "activity-clover-s-morning": {
        "character": "clover",
        "pages": [
            "Every morning, Clover follows the same routine. First: wake up!",
            "Second: eat a yummy breakfast. Clover likes knowing what comes next.",
            "Third: wash up and brush fur. Clover feels so clean and fresh!",
            "Fourth: put on clothes. Clover picks the same favorite outfit.",
            "Fifth: look in the mirror and smile. Clover is ready for the day!",
            "Clover loves routines because they feel safe. Every day follows a pattern.",
        ],
    },
    "activity-sparks-and-the-end-of-park-time": {
        "character": "sparks",
        "pages": [
            "Sparks was having SO much fun at the park! The day was perfect!",
            "But then... it was time to leave. Sparks felt a BIG feeling growing inside.",
            '"I don\'t want to go!" Sparks felt frustrated and upset.',
            'Mom said: "I know you\'re sad. Big feelings are okay. Let\'s talk about it."',
            "Sparks took deep breaths. The big feeling got a little smaller.",
            "Sparks learned: it's okay to feel sad sometimes. Feelings come and go.",
        ],
    },
    "activity-the-same-blue-truck": {
        "character": "clover",
        "pages": [
            "Every day, Clover saw the same blue truck drive by. Clover loved patterns!",
            '"There it is! The blue truck! Same as always!" Clover wagged with joy.',
            "One day, the blue truck didn't come. Clover felt worried.",
            "But then... there it was! A little later than usual, but still there!",
            "Clover realized that patterns sometimes change a little, and that's okay!",
            "The blue truck always comes, even if it's at a different time. Clover felt safe.",
        ],
    },
    "activity-zee-finds-all-the-colors": {
        "character": "zee",
        "pages": [
            'Zee the curious octopus was exploring the reef. "What colors are there?"',
            'First, Zee found something RED! A beautiful red coral. "How pretty!"',
            "Next, a bright YELLOW fish swam by. Zee reached out with tentacles.",
            "Then Zee found BLUE rocks and GREEN plants everywhere! So many colors!",
            "Zee also found ORANGE, PURPLE, and so many more! The world was colorful!",
            "Zee learned that colors are all around us. Finding them is an adventure!",
        ],
    },
    "activity-zee-tries-something-new": {
        "character": "zee",
        "pages": [
            'Zee found something new floating in the water. "What is this?" Zee was curious!',
            "It was a seaweed snack! Zee had never tried seaweed before.",
            '"It\'s different..." Zee felt a little nervous. "What if I don\'t like it?"',
            'But Zee was brave! "I can try new things!" Zee tasted the seaweed.',
            '"Mmm! It\'s crunchy! It\'s yummy! I like trying new things!" Zee was so happy!',
            "Zee learned: being brave enough to try something new can lead to wonderful surprises!",
        ],
    },
}


def generate_page(text: str, voice_id: str, output_prefix: Path) -> None:
    """Call ElevenLabs with-timestamps API and save audio + timestamps."""
    url = f"{BASE_URL}/{voice_id}/with-timestamps"
    payload = json.dumps({
        "text": text,
        "model_id": MODEL_ID,
        "voice_settings": {
            "stability": 0.6,
            "similarity_boost": 0.8,
            "style": 0.4,
        },
    }).encode()

    req = Request(url, data=payload, method="POST")
    req.add_header("xi-api-key", API_KEY)
    req.add_header("Content-Type", "application/json")

    with urlopen(req) as resp:
        data = json.loads(resp.read())

    # Save MP3
    audio_bytes = base64.b64decode(data["audio_base64"])
    mp3_path = output_prefix.with_suffix(".mp3")
    mp3_path.write_bytes(audio_bytes)

    # Save timestamps
    timestamps = data.get("normalized_alignment") or data.get("alignment")
    json_path = output_prefix.with_name(output_prefix.name + "_timestamps.json")
    json_path.write_text(json.dumps(timestamps, indent=2))

    print(f"  ✅ {mp3_path.name} ({len(audio_bytes)} bytes)")


def main():
    total_chars = 0
    total_pages = 0

    for story_id, story in STORIES.items():
        character = story["character"]
        voice_id = VOICE_MAP[character]
        story_dir = OUTPUT_DIR / story_id
        story_dir.mkdir(parents=True, exist_ok=True)

        print(f"\n📖 {story_id} (voice: {character})")

        for i, text in enumerate(story["pages"]):
            output_prefix = story_dir / f"page_{i}"

            # Skip if already generated
            if output_prefix.with_suffix(".mp3").exists():
                print(f"  ⏭️  page_{i}.mp3 already exists, skipping")
                continue

            generate_page(text, voice_id, output_prefix)
            total_chars += len(text)
            total_pages += 1

            # Rate limit: small delay between requests
            time.sleep(0.5)

    print(f"\n🎉 Done! Generated {total_pages} pages, {total_chars} characters used.")


if __name__ == "__main__":
    main()
```

- [ ] **Step 2: Run the generation script**

Run: `cd /Users/mohitramchandani/Code/seedling && python3 scripts/generate_story_audio.py`

Expected: 42 MP3 files + 42 timestamp JSON files created in `assets/audio/stories/`, one directory per story. Console shows checkmarks for each page. Total characters used ~2,861.

- [ ] **Step 3: Verify output**

Run: `find assets/audio/stories -type f | wc -l`

Expected: `84` (42 mp3 + 42 json)

Run: `ls assets/audio/stories/activity-big-world-little-hands/`

Expected:
```
page_0.mp3
page_0_timestamps.json
page_1.mp3
page_1_timestamps.json
page_2.mp3
page_2_timestamps.json
page_3.mp3
page_3_timestamps.json
page_4.mp3
page_4_timestamps.json
page_5.mp3
page_5_timestamps.json
```

- [ ] **Step 4: Spot-check a timestamp file**

Run: `python3 -c "import json; d=json.load(open('assets/audio/stories/activity-big-world-little-hands/page_0_timestamps.json')); print(len(d['characters']), 'chars'); print(d['characters'][:20]); print(d['character_start_times_seconds'][:10])"`

Expected: Character list matching "Once upon a time, Sparks woke up in a BIG house." with monotonically increasing timestamps.

- [ ] **Step 5: Commit**

```bash
git add scripts/generate_story_audio.py
git commit -m "feat: add ElevenLabs audio generation script for story narration"
```

---

## Task 2: Declare Audio Assets

**Files:**
- Modify: `pubspec.yaml`

- [ ] **Step 1: Add audio asset directories to pubspec.yaml**

Add all 7 story audio directories under the existing `assets:` section:

```yaml
  assets:
    - assets/characters/sparks/
    - assets/characters/clover/
    - assets/characters/zee/
    - assets/characters/zee/asl/
    - assets/characters/for landing page/
    - assets/audio/stories/activity-big-world-little-hands/
    - assets/audio/stories/activity-clover-counts-the-steps/
    - assets/audio/stories/activity-clover-s-morning/
    - assets/audio/stories/activity-sparks-and-the-end-of-park-time/
    - assets/audio/stories/activity-the-same-blue-truck/
    - assets/audio/stories/activity-zee-finds-all-the-colors/
    - assets/audio/stories/activity-zee-tries-something-new/
```

- [ ] **Step 2: Run flutter pub get**

Run: `cd /Users/mohitramchandani/Code/seedling && flutter pub get`

Expected: No errors. Assets registered successfully.

- [ ] **Step 3: Commit**

```bash
git add pubspec.yaml assets/audio/
git commit -m "feat: add pre-generated ElevenLabs story audio assets"
```

---

## Task 3: Story Audio Service

**Files:**
- Create: `lib/core/services/story_audio_service.dart`
- Test: `test/core/services/story_audio_service_test.dart`

This service handles loading pre-generated audio + timestamps from assets, playing audio with `just_audio`, and providing a word highlight stream synchronized to playback position.

- [ ] **Step 1: Write the word timing computation test**

Create `test/core/services/story_audio_service_test.dart`:

```dart
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
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd /Users/mohitramchandani/Code/seedling && flutter test test/core/services/story_audio_service_test.dart`

Expected: FAIL — `story_audio_service.dart` doesn't exist yet.

- [ ] **Step 3: Implement the word timing model and audio service**

Create `lib/core/services/story_audio_service.dart`:

```dart
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
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `cd /Users/mohitramchandani/Code/seedling && flutter test test/core/services/story_audio_service_test.dart`

Expected: All 3 tests PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/core/services/story_audio_service.dart test/core/services/story_audio_service_test.dart
git commit -m "feat: add StoryAudioService with word timing sync for ElevenLabs audio"
```

---

## Task 4: Update Story Reader Widget

**Files:**
- Modify: `lib/features/child/widgets/story_reader_widget.dart`

Replace `flutter_tts` with `StoryAudioService` for pages that have pre-generated audio. Fall back to `flutter_tts` when no audio file exists.

- [ ] **Step 1: Update imports and state**

At the top of `story_reader_widget.dart`, add the import:

```dart
import 'dart:async';
import 'package:seedling/core/services/story_audio_service.dart';
```

Update the state class fields — add the audio service and subscriptions alongside the existing flutter_tts:

```dart
class _StoryReaderWidgetState extends State<StoryReaderWidget> {
  late PageController _pageController;
  late FlutterTts _flutterTts;
  late StoryAudioService _audioService;
  StreamSubscription<TextRange?>? _highlightSub;
  StreamSubscription<void>? _completionSub;
  bool _useElevenLabs = false; // per-page flag

  int _currentPage = 0;
  bool _isPlaying = false;
  bool _isPaused = false;
  TextRange? _highlightRange;
```

- [ ] **Step 2: Initialize the audio service in initState**

Add to `initState`:

```dart
@override
void initState() {
  super.initState();
  _pageController = PageController();
  _audioService = StoryAudioService();
  _initTts();
}
```

Update dispose:

```dart
@override
void dispose() {
  _pageController.dispose();
  _flutterTts.stop();
  _highlightSub?.cancel();
  _completionSub?.cancel();
  _audioService.dispose();
  super.dispose();
}
```

- [ ] **Step 3: Extract the story ID from widget content**

Add a getter for the story ID (used to locate audio files):

```dart
String? get _storyId {
  // The content map comes from Firestore — the document ID is the story ID.
  // It's passed through as 'id' or we derive from the activity data.
  return widget.content['id'] as String?;
}
```

- [ ] **Step 4: Update _playCurrentPage to try ElevenLabs first**

Replace the existing `_playCurrentPage` method:

```dart
Future<void> _playCurrentPage() async {
  if (!mounted) return;

  final pageText = _pages[_currentPage]['text'] ?? '';
  if (pageText.isEmpty) return;

  setState(() {
    _isPlaying = true;
    _isPaused = false;
    _highlightRange = null;
  });

  // Try ElevenLabs pre-generated audio first
  final storyId = _storyId;
  if (storyId != null) {
    final loaded = await _audioService.loadPage(
      storyId: storyId,
      pageIndex: _currentPage,
      pageText: pageText,
    );

    if (loaded && mounted) {
      _useElevenLabs = true;

      // Set up highlight listener
      _highlightSub?.cancel();
      _highlightSub = _audioService.highlightStream.listen((range) {
        if (mounted) setState(() => _highlightRange = range);
      });

      // Set up completion listener
      _completionSub?.cancel();
      _completionSub = _audioService.completionStream.listen((_) {
        if (mounted) _onPlaybackComplete();
      });

      await _audioService.play();
      return;
    }
  }

  // Fallback: use flutter_tts
  _useElevenLabs = false;
  await _flutterTts.speak(pageText);
}
```

- [ ] **Step 5: Add completion handler and update pause/resume**

Add the shared completion handler:

```dart
void _onPlaybackComplete() {
  if (!mounted || !_isPlaying) return;
  setState(() {
    _isPlaying = false;
    _isPaused = false;
    _highlightRange = null;
  });
  // Auto-advance to next page after 800ms
  Future.delayed(const Duration(milliseconds: 800), () {
    if (mounted && _currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      ).then((_) => _playCurrentPage());
    }
  });
}
```

Update `_pausePlayback`:

```dart
Future<void> _pausePlayback() async {
  if (_useElevenLabs) {
    await _audioService.pause();
  } else {
    await _flutterTts.pause();
  }
  if (mounted) setState(() => _isPaused = true);
}
```

Update `_resumePlayback`:

```dart
Future<void> _resumePlayback() async {
  if (_useElevenLabs) {
    await _audioService.resume();
  } else {
    _flutterTts.setProgressHandler(
      (String text, int startChar, int endChar, String word) {
        if (mounted) {
          setState(() {
            _highlightRange = TextRange(start: startChar, end: endChar);
          });
        }
      },
    );
    await _flutterTts.speak(_pages[_currentPage]['text'] ?? '');
  }
  if (mounted) setState(() => _isPaused = false);
}
```

Update `_onPageChanged` to stop the audio service:

```dart
void _onPageChanged(int newPage) async {
  await _audioService.stop();
  await _flutterTts.stop();
  _highlightSub?.cancel();
  _completionSub?.cancel();
  if (mounted) {
    setState(() {
      _currentPage = newPage;
      _isPlaying = false;
      _isPaused = false;
      _highlightRange = null;
    });
  }
  Future.delayed(const Duration(milliseconds: 300), _playCurrentPage);
}
```

- [ ] **Step 6: Update flutter_tts completion handler to use shared method**

In `_initTts`, replace the inline completion handler:

```dart
_flutterTts.setCompletionHandler(() {
  if (mounted && _isPlaying && !_useElevenLabs) {
    _onPlaybackComplete();
  }
});
```

- [ ] **Step 7: Commit**

```bash
git add lib/features/child/widgets/story_reader_widget.dart
git commit -m "feat: integrate ElevenLabs character voices into story reader with flutter_tts fallback"
```

---

## Task 5: Pass Story ID to Story Reader

**Files:**
- Modify: `lib/features/child/activity_player_screen.dart` (or wherever StoryReaderWidget is instantiated)

The story reader needs the activity document ID to locate audio files. Check how `content` is passed and ensure the `id` field is included.

- [ ] **Step 1: Find where StoryReaderWidget is created**

Search for `StoryReaderWidget(` in the codebase. The `content` map currently contains `pages` but may not include the Firestore document ID. We need to add it.

- [ ] **Step 2: Add the story ID to the content map**

In the screen that instantiates `StoryReaderWidget`, ensure the Firestore document ID is passed in the content map:

```dart
StoryReaderWidget(
  content: {
    'id': activity.id,  // Add this line — the Firestore document ID
    ...activity.content,
  },
  onDone: ...,
)
```

- [ ] **Step 3: Commit**

```bash
git add lib/features/child/activity_player_screen.dart
git commit -m "feat: pass story ID to StoryReaderWidget for audio file lookup"
```

---

## Task 6: On-Device Test

- [ ] **Step 1: Run flutter pub get**

Run: `cd /Users/mohitramchandani/Code/seedling && flutter pub get`

- [ ] **Step 2: Build and run on device/simulator**

Run: `flutter run`

- [ ] **Step 3: Test the golden path**

1. Open any story (e.g., "Big World Little Hands" — Sparks)
2. Audio should auto-play with Jessica's voice (Sparks)
3. Words should highlight as they're spoken
4. Tap to advance — next page should play with the same voice
5. Play/pause button should work

- [ ] **Step 4: Test character voice differentiation**

1. Open a Clover story (e.g., "Clover's Morning") — should use Lily's voice
2. Open a Zee story (e.g., "Zee Finds All the Colors") — should use Laura's voice
3. All three voices should sound distinctly different

- [ ] **Step 5: Test fallback**

1. If any story doesn't have audio files, flutter_tts should still work
2. No crashes or errors for missing audio

- [ ] **Step 6: Final commit**

```bash
git add -A
git commit -m "feat: ElevenLabs character voices complete — 3 voices across 7 stories"
```
