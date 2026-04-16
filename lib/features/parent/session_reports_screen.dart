import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:seedling/core/constants/app_constants.dart';
import 'package:seedling/core/theme/app_theme.dart';
import 'package:seedling/features/account/account_providers.dart';
import 'package:seedling/features/auth/auth_providers.dart';
import 'package:seedling/features/parent/parent_providers.dart';
import 'package:seedling/features/profiles/child_switcher_modal.dart';
import 'package:seedling/features/profiles/profiles_provider.dart';
import 'package:seedling/models/models.dart';
import 'package:seedling/services/ai_service.dart';

class SessionReportsScreen extends ConsumerWidget {
  const SessionReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeChild = ref.watch(activeChildProfileProvider);
    final sessionsAsync = ref.watch(childSessionsProvider);
    final statusAsync = ref.watch(subscriptionStatusProvider);

    return Scaffold(
      appBar: AppBar(
        title: activeChild != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Sessions for: ',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 4),
                  const ChildSwitcherButton(chipStyle: true),
                ],
              )
            : const Text('Session Reports'),
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

          final status = statusAsync.valueOrNull;
          final isLocked = status != null &&
              !status.isPaid &&
              !status.canViewSessionReports;

          return Column(
            children: [
              if (isLocked)
                _UpgradeBanner(
                  message:
                      'You\'ve viewed ${AppConstants.freeSessionReportsPerMonth} reports this month. '
                      'Upgrade for unlimited access.',
                  onUpgrade: () => context.push('/account'),
                ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: sessions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) =>
                      _SessionCard(session: sessions[index]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _UpgradeBanner extends StatelessWidget {
  const _UpgradeBanner({required this.message, required this.onUpgrade});
  final String message;
  final VoidCallback onUpgrade;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppColors.softAmber.withValues(alpha: 0.3),
      child: Row(
        children: [
          const Icon(Icons.lock_outline, size: 18, color: AppColors.textPrimary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message,
                style: const TextStyle(fontSize: 12, height: 1.4)),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: onUpgrade,
            child: const Text('Upgrade'),
          ),
        ],
      ),
    );
  }
}

String _formatSkill(String raw) {
  return raw
      .replaceAll('_', ' ')
      .split(' ')
      .map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}')
      .join(' ');
}

class _SessionCard extends ConsumerStatefulWidget {
  const _SessionCard({required this.session});
  final ChildSession session;

  @override
  ConsumerState<_SessionCard> createState() => _SessionCardState();
}

class _SessionCardState extends ConsumerState<_SessionCard> {
  bool _retrying = false;

  Future<void> _retry() async {
    final session = widget.session;
    final activeChild = ref.read(activeChildProfileProvider);
    final userId = ref.read(authStateProvider).valueOrNull?.uid;
    if (activeChild == null || userId == null) return;

    setState(() => _retrying = true);
    final firestoreService = ref.read(firestoreServiceProvider);
    final aiService = AiService();

    try {
      await firestoreService.clearReportStatus(
        userId: userId,
        childId: activeChild.id,
        sessionId: session.id,
      );
      await firestoreService
          .getSessionActivities(
        userId: userId,
        childId: activeChild.id,
        sessionId: session.id,
      )
          .then((activities) {
        return aiService.generateSessionReport(
          childId: activeChild.id,
          sessionId: session.id,
          activities: activities,
          durationMinutes: session.durationMinutes,
        );
      });
    } catch (e) {
      await firestoreService.markReportFailed(
        userId: userId,
        childId: activeChild.id,
        sessionId: session.id,
        error: e.toString(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Report retry failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _retrying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = widget.session;
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
                          _formatSkill(skill),
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
              Builder(builder: (_) {
                if (session.activityIds.isEmpty) {
                  return Text(
                    'No activities completed this session.',
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 13),
                  );
                }

                final endedAt = session.endedAt;
                final stuck = endedAt != null &&
                    DateTime.now().difference(endedAt).inSeconds > 30;
                final failed = session.reportStatus == 'failed' ||
                    (stuck && session.reportStatus != 'generating');

                if (!failed) {
                  return Text(
                    'Report generating...',
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 13),
                  );
                }

                return Row(
                  children: [
                    Icon(Icons.error_outline,
                        size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "Couldn't generate report.",
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 13),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _retrying ? null : _retry,
                      icon: _retrying
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.refresh, size: 16),
                      label: Text(_retrying ? 'Retrying' : 'Retry'),
                    ),
                  ],
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}
