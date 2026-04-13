import 'package:flutter/material.dart';
import 'package:seedling/core/theme/app_theme.dart';

class SequenceGameWidget extends StatefulWidget {
  const SequenceGameWidget({
    required this.content,
    required this.onDone,
    super.key,
  });

  final Map<String, dynamic> content;
  final VoidCallback onDone;

  @override
  State<SequenceGameWidget> createState() => _SequenceGameWidgetState();
}

class _SequenceGameWidgetState extends State<SequenceGameWidget> {
  int _currentRound = 0;
  int _correctCount = 0;
  int? _selectedIndex;
  bool _showFeedback = false;
  bool _isCorrect = false;
  bool _showingHint = false;
  String _hintText = '';

  List<Map<String, dynamic>> get _rounds {
    final rounds = widget.content['rounds'] as List?;
    return rounds?.map((r) => r as Map<String, dynamic>).toList() ?? [];
  }

  int get _roundsToWin =>
      (widget.content['rounds_to_win'] as num?)?.toInt() ?? 5;

  bool get _isGameComplete => _correctCount >= _roundsToWin;

  void _showHint() {
    if (_showFeedback || _showingHint) return;
    final round = _rounds[_currentRound % _rounds.length];
    final hint = round['hint']?.toString();
    if (hint == null) return;

    setState(() {
      _showingHint = true;
      _hintText = hint;
    });
  }

  void _handleAnswer(int index) {
    if (_showFeedback) return;

    final round = _rounds[_currentRound % _rounds.length];
    final correctIndex = round['correct_index'] as int?;
    final isCorrect = index == correctIndex;

    setState(() {
      _selectedIndex = index;
      _showFeedback = true;
      _isCorrect = isCorrect;
    });

    if (isCorrect) {
      setState(() => _correctCount++);
      Future.delayed(const Duration(milliseconds: 2500), () {
        if (mounted && _isGameComplete) {
          _showCelebration();
        } else if (mounted) {
          setState(() {
            _currentRound++;
            _selectedIndex = null;
            _showFeedback = false;
            _showingHint = false;
          });
        }
      });
    } else {
      Future.delayed(const Duration(milliseconds: 2500), () {
        if (mounted) {
          setState(() {
            _selectedIndex = null;
            _showFeedback = false;
          });
        }
      });
    }
  }

  void _showCelebration() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 16),
            const Text(
              'You completed it!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.seedGreen,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
                widget.onDone();
              },
              child: const Text('All done!'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_rounds.isEmpty) {
      return Center(
        child: Text('No game content',
            style: TextStyle(color: AppColors.textSecondary)),
      );
    }

    final round = _rounds[_currentRound % _rounds.length];
    final prompt = round['prompt']?.toString() ?? '';
    final options =
        (round['options'] as List?)?.map((o) => o.toString()).toList() ?? [];
    final feedback = _isCorrect
        ? 'Great! That\'s correct! 🎉'
        : 'Not quite. Try again!';

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Progress bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Score: $_correctCount / $_roundsToWin',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: _correctCount / _roundsToWin,
                  minHeight: 12,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.seedGreen,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Prompt
          Text(
            prompt,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          // Options
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  options.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: () => _handleAnswer(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _selectedIndex == index
                              ? (_isCorrect
                                  ? Colors.green.withOpacity(0.2)
                                  : Colors.red.withOpacity(0.2))
                              : Colors.grey.withOpacity(0.1),
                          border: Border.all(
                            color: _selectedIndex == index
                                ? (_isCorrect ? Colors.green : Colors.red)
                                : Colors.grey[300]!,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          options[index],
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 32),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Hint button
          if (!_showingHint)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ElevatedButton.icon(
                onPressed: _showFeedback ? null : _showHint,
                icon: const Icon(Icons.lightbulb_outline, size: 20),
                label: const Text('Need a hint?'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.softAmber,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ),
          // Hint display
          if (_showingHint) ...[
            const SizedBox(height: 16),
            AnimatedOpacity(
              opacity: _showingHint ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.softAmber.withOpacity(0.2),
                  border: Border.all(
                    color: AppColors.softAmber,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _hintText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ],
          // Feedback
          if (_showFeedback) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (_isCorrect ? Colors.green : Colors.orange)
                    .withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                feedback,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: _isCorrect ? Colors.green[700] : Colors.orange[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// _SequenceCard removed — prompt text is sufficient
}
