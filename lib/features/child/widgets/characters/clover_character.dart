import 'package:flutter/material.dart';

class CloverCharacter extends StatelessWidget {
  const CloverCharacter({this.emotion = 'happy', this.size = 280, super.key});
  final String emotion;
  final double size;

  @override
  Widget build(BuildContext context) {
    final assetPath = 'assets/characters/clover/${emotion.toLowerCase()}.png';

    return SizedBox(
      width: size,
      height: size,
      child: Image.asset(
        assetPath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to happy if emotion image not found
          return Image.asset(
            'assets/characters/clover/happy.png',
            fit: BoxFit.contain,
          );
        },
      ),
    );
  }
}
