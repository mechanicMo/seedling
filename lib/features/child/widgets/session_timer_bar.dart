import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:seedling/core/constants/app_constants.dart';
import 'package:seedling/core/theme/app_theme.dart';
import 'package:seedling/features/child/child_providers.dart';

class SessionTimerBar extends ConsumerStatefulWidget {
  const SessionTimerBar({required this.timerMinutes, super.key});
  final int timerMinutes;

  @override
  ConsumerState<SessionTimerBar> createState() => _SessionTimerBarState();
}

class _SessionTimerBarState extends ConsumerState<SessionTimerBar> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      ref.read(childSessionProvider.notifier).tickSecond();
      _checkExpiry();
    });
  }

  void _checkExpiry() {
    final elapsed = ref.read(childSessionProvider).elapsedSeconds;
    final limitSeconds = widget.timerMinutes * 60;
    if (elapsed >= limitSeconds && context.mounted) {
      _timer?.cancel();
      ref.read(childSessionProvider.notifier).markComplete();
      context.go('/child/complete');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final elapsed = ref.watch(childSessionProvider).elapsedSeconds;
    final limitSeconds = widget.timerMinutes * 60;
    final remaining = (limitSeconds - elapsed).clamp(0, limitSeconds);
    final remainingMinutes = remaining ~/ 60;
    final remainingSeconds = remaining % 60;
    final isWarning = remaining <= AppConstants.sessionTimerWarningMinutes * 60;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: isWarning
          ? Colors.orange.withOpacity(0.12)
          : Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(
            Icons.timer_outlined,
            size: 16,
            color: isWarning ? Colors.orange : AppColors.textSecondary,
          ),
          const SizedBox(width: 4),
          Text(
            '$remainingMinutes:${remainingSeconds.toString().padLeft(2, '0')}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: isWarning ? FontWeight.w700 : FontWeight.normal,
              color: isWarning ? Colors.orange : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
