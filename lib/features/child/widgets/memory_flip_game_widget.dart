import 'package:flutter/material.dart';
import 'package:seedling/core/theme/app_theme.dart';

class MemoryFlipGameWidget extends StatefulWidget {
  const MemoryFlipGameWidget({
    required this.content,
    required this.onDone,
    super.key,
  });

  final Map<String, dynamic> content;
  final VoidCallback onDone;

  @override
  State<MemoryFlipGameWidget> createState() => _MemoryFlipGameWidgetState();
}

class _MemoryFlipGameWidgetState extends State<MemoryFlipGameWidget> {
  late List<_CardState> _cards;
  int? _firstFlippedIndex;
  int _matchedCount = 0;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    final pairs = widget.content['pairs'] as List?;
    if (pairs == null) return;

    _cards = [];
    for (final pair in pairs) {
      _cards.add(_CardState(
        a: pair['a']?.toString() ?? '',
        b: pair['b']?.toString() ?? '',
        isFront: true,
      ));
      _cards.add(_CardState(
        a: pair['a']?.toString() ?? '',
        b: pair['b']?.toString() ?? '',
        isFront: true,
      ));
    }
    _cards.shuffle();
  }

  Future<void> _onCardTap(int index) async {
    if (_isProcessing || _cards[index].isMatched || !_cards[index].isFront) {
      return;
    }

    setState(() {
      _cards[index].isFront = false;
    });

    if (_firstFlippedIndex == null) {
      setState(() => _firstFlippedIndex = index);
    } else {
      setState(() => _isProcessing = true);

      await Future.delayed(const Duration(milliseconds: 800));

      final firstCard = _cards[_firstFlippedIndex!];
      final secondCard = _cards[index];

      if (firstCard.a == secondCard.a && firstCard.b == secondCard.b) {
        setState(() {
          _cards[_firstFlippedIndex!].isMatched = true;
          _cards[index].isMatched = true;
          _matchedCount++;
        });
      } else {
        setState(() {
          _cards[_firstFlippedIndex!].isFront = true;
          _cards[index].isFront = true;
        });
      }

      setState(() {
        _firstFlippedIndex = null;
        _isProcessing = false;
      });

      if (_matchedCount == (_cards.length ~/ 2)) {
        _showWinDialog();
      }
    }
  }

  void _showWinDialog() {
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
              'You matched them all!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Matched: ${_matchedCount} / ${_cards.length ~/ 2}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _cards.length,
              itemBuilder: (context, index) => _MemoryCard(
                card: _cards[index],
                isFlipped: !_cards[index].isFront,
                onTap: () => _onCardTap(index),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardState {
  final String a;
  final String b;
  bool isFront;
  bool isMatched;

  _CardState({
    required this.a,
    required this.b,
    this.isFront = true,
    this.isMatched = false,
  });
}

class _MemoryCard extends StatefulWidget {
  const _MemoryCard({required this.card, required this.isFlipped, required this.onTap});

  final _CardState card;
  final bool isFlipped;
  final VoidCallback onTap;

  @override
  State<_MemoryCard> createState() => _MemoryCardState();
}

class _MemoryCardState extends State<_MemoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(_MemoryCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFlipped != oldWidget.isFlipped) {
      if (widget.isFlipped) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.card.isMatched ? null : widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final angle = _controller.value * 3.14159;
          final transform = Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle);
          final isFront = angle < 1.5708;

          return Transform(
            alignment: Alignment.center,
            transform: transform,
            child: Container(
              decoration: BoxDecoration(
                color: widget.card.isMatched
                    ? Colors.green.withOpacity(0.2)
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: widget.card.isMatched
                      ? Colors.green
                      : Colors.grey[400]!,
                  width: 2,
                ),
              ),
              child: Center(
                child: isFront
                    ? const Text(
                        '?',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    : Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()..rotateY(3.14159),
                        child: Text(
                          widget.card.b,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
