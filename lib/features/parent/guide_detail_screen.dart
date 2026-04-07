import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seedling/core/theme/app_theme.dart';
import 'package:seedling/features/parent/parent_providers.dart';
import 'package:seedling/models/models.dart';

class GuideDetailScreen extends ConsumerWidget {
  const GuideDetailScreen({required this.guideId, super.key});
  final String guideId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guideAsync = ref.watch(guideDetailProvider(guideId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Guide'),
      ),
      body: guideAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (guide) {
          if (guide == null) {
            return const Center(child: Text('Guide not found.'));
          }
          return _GuideContent(guide: guide);
        },
      ),
    );
  }
}

class _GuideContent extends StatelessWidget {
  const _GuideContent({required this.guide});
  final ParentGuideDoc guide;

  String _categoryLabel(String cat) => switch (cat) {
        'behavior' => 'Behavior',
        'sleep' => 'Sleep',
        'emotions' => 'Emotions',
        'development' => 'Development',
        'routines' => 'Routines',
        'feeding' => 'Feeding',
        'transitions' => 'Transitions',
        'relationships' => 'Relationships',
        _ => cat,
      };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.seedGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _categoryLabel(guide.category),
              style: TextStyle(
                color: AppColors.seedGreen,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 12),

          Text(
            guide.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.softAmber.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: AppColors.softAmber.withOpacity(0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Right now',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  guide.quickResponse,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          MarkdownBody(
            data: guide.fullGuide,
            styleSheet: MarkdownStyleSheet(
              h2: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w700),
              p: const TextStyle(fontSize: 15, height: 1.6),
              listBullet: TextStyle(color: AppColors.textPrimary),
            ),
          ),
          const SizedBox(height: 24),

          if (guide.doThis.isNotEmpty || guide.notThat.isNotEmpty) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (guide.doThis.isNotEmpty)
                  Expanded(
                    child: _TakeawayColumn(
                      title: 'Do this',
                      items: guide.doThis,
                      color: AppColors.seedGreen,
                      icon: Icons.check_circle_outline,
                    ),
                  ),
                if (guide.doThis.isNotEmpty && guide.notThat.isNotEmpty)
                  const SizedBox(width: 12),
                if (guide.notThat.isNotEmpty)
                  Expanded(
                    child: _TakeawayColumn(
                      title: 'Not that',
                      items: guide.notThat,
                      color: AppColors.error,
                      icon: Icons.cancel_outlined,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),
          ],

          if (guide.researchBasis.isNotEmpty) ...[
            Text(
              'Research basis',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            for (final citation in guide.researchBasis)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  citation,
                  style: TextStyle(
                      color: AppColors.textSecondary, fontSize: 13),
                ),
              ),
          ],
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _TakeawayColumn extends StatelessWidget {
  const _TakeawayColumn({
    required this.title,
    required this.items,
    required this.color,
    required this.icon,
  });

  final String title;
  final List<String> items;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(item,
                      style: const TextStyle(fontSize: 13, height: 1.4)),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
