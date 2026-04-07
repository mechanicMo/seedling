import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:seedling/core/theme/app_theme.dart';
import 'package:seedling/features/child/child_providers.dart';
import 'package:seedling/features/child/widgets/session_timer_bar.dart';
import 'package:seedling/features/profiles/profiles_provider.dart';
import 'package:seedling/models/models.dart';

class ActivityPlayerScreen extends ConsumerStatefulWidget {
  const ActivityPlayerScreen({required this.activity, super.key});
  final ChildActivity activity;

  @override
  ConsumerState<ActivityPlayerScreen> createState() => _ActivityPlayerScreenState();
}

class _ActivityPlayerScreenState extends ConsumerState<ActivityPlayerScreen> {
  final _stopwatch = Stopwatch();

  @override
  void initState() {
    super.initState();
    _stopwatch.start();
  }

  @override
  void dispose() {
    _stopwatch.stop();
    super.dispose();
  }

  void _markDone() {
    _stopwatch.stop();
    ref.read(childSessionProvider.notifier).markActivityComplete(
      widget.activity,
      _stopwatch.elapsed.inSeconds,
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final activeChild = ref.watch(activeChildProfileProvider);
    final activity = widget.activity;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F4EF),
        body: SafeArea(
          child: Column(
            children: [
              SessionTimerBar(timerMinutes: activeChild?.sessionTimerMinutes ?? 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _ActivityIcon(type: activity.type),
                      const SizedBox(height: 24),
                      Text(
                        activity.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (activity.learningObjectives.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(
                          activity.learningObjectives.first,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                      const SizedBox(height: 48),
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
                          onPressed: _markDone,
                          child: const Text(
                            'All done!',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityIcon extends StatelessWidget {
  const _ActivityIcon({required this.type});
  final String type;

  @override
  Widget build(BuildContext context) {
    const icons = {
      'story': Icons.auto_stories,
      'game': Icons.sports_esports,
      'music': Icons.music_note,
      'movement': Icons.directions_walk,
      'video': Icons.play_circle,
      'creative': Icons.brush,
    };
    const colors = {
      'story': Color(0xFF7BB8D4),
      'game': Color(0xFF8DC48A),
      'music': Color(0xFFD4A96A),
      'movement': Color(0xFFB09FD4),
      'video': Color(0xFFD48A8A),
      'creative': Color(0xFFD4C56A),
    };

    final icon = icons[type] ?? Icons.star;
    final color = colors[type] ?? AppColors.seedGreen;

    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        shape: BoxShape.circle,
        border: Border.all(color: color.withOpacity(0.3), width: 2),
      ),
      child: Icon(icon, size: 60, color: color),
    );
  }
}
