import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:seedling/core/theme/app_theme.dart';
import 'package:seedling/features/parent/parent_providers.dart';
import 'package:seedling/features/profiles/profiles_provider.dart';
import 'package:seedling/models/models.dart';

class SessionReportsScreen extends ConsumerWidget {
  const SessionReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeChild = ref.watch(activeChildProfileProvider);
    final sessionsAsync = ref.watch(childSessionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(activeChild != null
            ? '${activeChild.name}\'s Sessions'
            : 'Session Reports'),
      ),
      body: sessionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (sessions) {
          if (activeChild == null) {
            return Center(
              child: Text('Select a child profile to view sessions.',
                  style: TextStyle(color: AppColors.textSecondary)),
            );
          }

          if (sessions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bar_chart_outlined,
                      size: 48, color: AppColors.textSecondary),
                  const SizedBox(height: 16),
                  Text('No sessions yet.',
                      style:
                          TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 8),
                  Text(
                    'Session reports appear here after your child\ncompletes a learning session.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 13),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: sessions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) =>
                _SessionCard(session: sessions[index]),
          );
        },
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  const _SessionCard({required this.session});
  final ChildSession session;

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('MMM d, h:mm a');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  fmt.format(session.startedAt),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                if (session.durationMinutes > 0)
                  Text(
                    '${session.durationMinutes} min',
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 13),
                  ),
              ],
            ),

            if (session.report != null) ...[
              const SizedBox(height: 10),
              Text(
                session.report!.summary,
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),

              if (session.report!.skillsPracticed.isNotEmpty) ...[
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    for (final skill in session.report!.skillsPracticed)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.skyBlue.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          skill,
                          style: TextStyle(
                              fontSize: 12, color: AppColors.skyBlue),
                        ),
                      ),
                  ],
                ),
              ],

              if (session.report!.parentFollowUps.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  'Follow-up ideas',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                for (final followUp in session.report!.parentFollowUps)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('• ',
                            style: TextStyle(
                                color: AppColors.seedGreen,
                                fontWeight: FontWeight.bold)),
                        Expanded(
                          child: Text(followUp,
                              style: const TextStyle(
                                  fontSize: 13, height: 1.4)),
                        ),
                      ],
                    ),
                  ),
              ],
            ] else ...[
              const SizedBox(height: 6),
              Text(
                'Session completed — report generating...',
                style: TextStyle(
                    color: AppColors.textSecondary, fontSize: 13),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
