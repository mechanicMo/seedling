import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:seedling/core/theme/app_theme.dart';
import 'package:seedling/features/child/widgets/characters/sparks_character.dart';
import 'package:seedling/features/child/widgets/characters/clover_character.dart';
import 'package:seedling/features/child/widgets/characters/zee_character.dart';

class StoryReaderWidget extends StatefulWidget {
  const StoryReaderWidget({
    required this.content,
    required this.onDone,
    super.key,
  });

  final Map<String, dynamic> content;
  final VoidCallback onDone;

  @override
  State<StoryReaderWidget> createState() => _StoryReaderWidgetState();
}

class _StoryReaderWidgetState extends State<StoryReaderWidget> {
  late PageController _pageController;
  late FlutterTts _flutterTts;

  int _currentPage = 0;
  bool _isPlaying = false;
  bool _isPaused = false;
  TextRange? _highlightRange;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _initTts();
  }

  Future<void> _initTts() async {
    _flutterTts = FlutterTts();

    // Configure TTS
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(0.4);
    await _flutterTts.setPitch(1.1);

    // Set up progress handler for word highlighting
    _flutterTts.setProgressHandler(
      (String text, int startChar, int endChar, String word) {
        if (mounted) {
          setState(() {
            _highlightRange = TextRange(start: startChar, end: endChar);
          });
        }
      },
    );

    // Handle completion
    _flutterTts.setCompletionHandler(() {
      if (mounted && _isPlaying) {
        setState(() {
          _isPlaying = false;
          _isPaused = false;
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
    });

    // Handle errors
    _flutterTts.setErrorHandler((message) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Speech error: $message')),
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  List<Map<String, dynamic>> get _pages {
    final pages = widget.content['pages'] as List?;
    return pages?.map((p) {
      if (p is String) {
        return {'text': p, 'character': null, 'emotion': 'happy'};
      } else if (p is Map) {
        return {
          'text': p['text']?.toString() ?? '',
          'character': p['character'],
          'emotion': p['emotion'] ?? 'happy',
        };
      }
      return {'text': '', 'character': null, 'emotion': 'happy'};
    }).toList() ?? [];
  }

  bool get _isLastPage => _currentPage == _pages.length - 1;

  Widget _buildCharacter(String? character, String emotion) {
    switch (character?.toLowerCase()) {
      case 'sparks':
        return SparksCharacter(emotion: emotion, size: 140);
      case 'clover':
        return CloverCharacter(emotion: emotion, size: 140);
      case 'zee':
        return ZeeCharacter(emotion: emotion, size: 140);
      default:
        return const SizedBox.shrink();
    }
  }

  Future<void> _playCurrentPage() async {
    if (!mounted) return;

    final pageText = _pages[_currentPage]['text'] ?? '';
    if (pageText.isEmpty) return;

    setState(() {
      _isPlaying = true;
      _isPaused = false;
      _highlightRange = null;
    });

    await _flutterTts.speak(pageText);
  }

  Future<void> _pausePlayback() async {
    await _flutterTts.pause();
    if (mounted) {
      setState(() => _isPaused = true);
    }
  }

  Future<void> _resumePlayback() async {
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
    if (mounted) {
      setState(() => _isPaused = false);
    }
  }

  void _onPageChanged(int newPage) async {
    await _flutterTts.stop();
    if (mounted) {
      setState(() {
        _currentPage = newPage;
        _isPlaying = false;
        _isPaused = false;
        _highlightRange = null;
      });
    }
    // Auto-start reading new page
    Future.delayed(const Duration(milliseconds: 300), _playCurrentPage);
  }

  Widget _buildStoryText(String text) {
    if (text.isEmpty) return const SizedBox.shrink();

    final wordMatches = RegExp(r'\S+').allMatches(text).toList();
    if (wordMatches.isEmpty) return const SizedBox.shrink();

    final textSpans = <InlineSpan>[];

    for (int i = 0; i < wordMatches.length; i++) {
      final match = wordMatches[i];
      final word = match.group(0)!;
      final wordStart = match.start;
      final wordEnd = match.end;

      final isHighlighted = _highlightRange != null &&
          wordStart < _highlightRange!.end &&
          wordEnd > _highlightRange!.start;

      final isAfterHighlight = _highlightRange != null &&
          wordStart >= _highlightRange!.end;

      final trailingSpace = i < wordMatches.length - 1 ? ' ' : '';

      // All words stay as TextSpan — no WidgetSpan — so layout never shifts
      if (isHighlighted) {
        textSpans.add(TextSpan(
          text: '$word$trailingSpace',
          style: TextStyle(
            fontSize: 26,
            height: 2.0,
            fontWeight: FontWeight.w700,
            color: const Color(0xFFF2C94C),
            backgroundColor: AppColors.softAmber.withValues(alpha: 0.35),
          ),
        ));
      } else if (isAfterHighlight) {
        textSpans.add(TextSpan(
          text: '$word$trailingSpace',
          style: TextStyle(
            fontSize: 26,
            height: 2.0,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary.withValues(alpha: 0.5),
          ),
        ));
      } else {
        textSpans.add(TextSpan(
          text: '$word$trailingSpace',
          style: const TextStyle(
            fontSize: 26,
            height: 2.0,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ));
      }
    }

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(children: textSpans),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = _pages;

    if (pages.isEmpty) {
      return Center(
        child: Text('No story content',
            style: TextStyle(color: AppColors.textSecondary)),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Page indicator
          if (pages.length > 1) ...[
            Text(
              'Page ${_currentPage + 1} of ${pages.length}',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
          ],
          // Story content
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: pages
                  .map(
                    (page) => GestureDetector(
                      onTapDown: (details) {
                        final width = MediaQuery.of(context).size.width;
                        if (details.globalPosition.dx < width / 2) {
                          if (_currentPage > 0) {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        } else {
                          if (_currentPage < pages.length - 1) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        }
                      },
                      child: LayoutBuilder(
                        builder: (context, constraints) => SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minHeight: constraints.maxHeight),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (page['character'] != null) ...[
                                  _buildCharacter(page['character'], page['emotion']),
                                  const SizedBox(height: 24),
                                ],
                                _buildStoryText(page['text']),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 24),
          // Play / Pause button
          SizedBox(
            width: 64,
            height: 64,
            child: Material(
              color: _isPlaying ? AppColors.seedGreen : AppColors.seedGreenLight,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: () {
                  if (!_isPlaying) {
                    _playCurrentPage();
                  } else if (_isPaused) {
                    _resumePlayback();
                  } else {
                    _pausePlayback();
                  }
                },
                child: Center(
                  child: Icon(
                    _isPlaying && !_isPaused ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Page dots
          if (pages.length > 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? AppColors.seedGreen
                        : AppColors.seedGreen.withValues(alpha: 0.3),
                  ),
                ),
              ),
            ),
          if (pages.length > 1) const SizedBox(height: 24),
          // Done button (only on last page)
          if (_isLastPage)
            SizedBox(
              width: double.infinity,
              height: 64,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.seedGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: widget.onDone,
                child: const Text(
                  'All done! 🌱',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
