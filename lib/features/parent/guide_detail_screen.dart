import 'package:flutter/material.dart';

class GuideDetailScreen extends StatelessWidget {
  const GuideDetailScreen({required this.guideId, super.key});
  final String guideId;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Guide Detail — Task 5'),
      ),
    );
  }
}
