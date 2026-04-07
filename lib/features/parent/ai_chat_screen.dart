import 'package:flutter/material.dart';

class AiChatScreen extends StatelessWidget {
  const AiChatScreen({this.initialSituation, super.key});
  final String? initialSituation;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('AI Chat — Task 3'),
      ),
    );
  }
}
