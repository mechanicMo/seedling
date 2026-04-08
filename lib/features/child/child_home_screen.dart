import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:seedling/core/theme/app_theme.dart';
import 'package:seedling/features/child/child_providers.dart';
import 'package:seedling/features/child/widgets/session_timer_bar.dart';
import 'package:seedling/features/profiles/profiles_provider.dart';
import 'package:seedling/models/models.dart';

class ChildHomeScreen extends ConsumerWidget {
  const ChildHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activitiesAsync = ref.watch(childActivitiesProvider);
    final activeChild = ref.watch(activeChildProfileProvider);

    return PopScope(
      canPop: false,   // no back button in child mode
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F4EF),   // warm off-white
        body: SafeArea(
          child: Column(
            children: [
              SessionTimerBar(timerMinutes: activeChild?.sessionTimerMinutes ?? 20),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'What do you want to do?',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Expanded(
                child: activitiesAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('Something went wrong')),
                  data: (activities) {
                    if (activities.isEmpty) {
                      return Center(
                        child: Text(
                          'No activities available.\nAsk your parent to set up content.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      );
                    }
                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.95,
                      ),
                      itemCount: activities.length,
                      itemBuilder: (context, index) =>
                          _ActivityCard(activity: activities[index]),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextButton(
                  onPressed: () => context.push('/child/complete'),
                  child: Text(
                    'All done for today',
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 14),
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

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({required this.activity});
  final ChildActivity activity;

  static const _typeEmojis = {
    'story': '📖',
    'game': '🎮',
    'music': '🎵',
    'movement': '🏃',
    'video': '🎬',
    'creative': '🎨',
  };

  static const _typeLabels = {
    'story': 'Story',
    'game': 'Game',
    'music': 'Music',
    'movement': 'Move',
    'video': 'Video',
    'creative': 'Create',
  };

  static const _typeColors = {
    'story': Color(0xFF7BB8D4),
    'game': Color(0xFF8DC48A),
    'music': Color(0xFFD4A96A),
    'movement': Color(0xFFB09FD4),
    'video': Color(0xFFD48A8A),
    'creative': Color(0xFFD4C56A),
  };

  @override
  Widget build(BuildContext context) {
    final emoji = _typeEmojis[activity.type] ?? '⭐';
    final label = _typeLabels[activity.type] ?? 'Activity';
    final color = _typeColors[activity.type] ?? AppColors.seedGreen;

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => context.push(
        '/child/activity/${activity.id}',
        extra: activity,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 40),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                activity.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${activity.durationMinutes} min · $label',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
