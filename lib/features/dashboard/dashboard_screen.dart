import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:seedling/core/theme/app_theme.dart';
import 'package:seedling/features/auth/auth_providers.dart';
import 'package:seedling/features/child/child_providers.dart';
import 'package:seedling/features/parent/parent_providers.dart';
import 'package:seedling/features/profiles/profiles_provider.dart';
import 'package:seedling/models/models.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profilesAsync = ref.watch(childProfilesProvider);
    final activeChild = ref.watch(activeChildProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seedling 🌱'),
        actions: [
          IconButton(
            icon: const Icon(Icons.people_outline),
            onPressed: () => context.push('/profiles'),
            tooltip: 'Manage children',
          ),
        ],
      ),
      body: profilesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (profiles) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Child profile selector
                if (profiles.isNotEmpty) ...[
                  Text('Viewing as',
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 13)),
                  const SizedBox(height: 8),
                  _ChildSelector(profiles: profiles),
                  const SizedBox(height: 32),
                ],

                // Quick action: Help me now
                _QuickActionCard(
                  icon: Icons.help_outline,
                  title: 'Help me now',
                  subtitle: 'Get guidance for what\'s happening right now',
                  color: AppColors.seedGreen,
                  onTap: () => context.push('/guidance'),
                ),
                const SizedBox(height: 16),

                // Hand device to child
                _QuickActionCard(
                  icon: Icons.child_care,
                  title: 'Hand to ${activeChild?.name ?? 'child'}',
                  subtitle: 'Start a learning session',
                  color: AppColors.softBrown,
                  onTap: () async {
                    final firestoreService = ref.read(firestoreServiceProvider);
                    final authAsync = ref.read(authStateProvider);
                    final userId = authAsync.valueOrNull?.uid;
                    if (userId == null || activeChild == null) return;

                    try {
                      final sessionId =
                          await firestoreService.startChildSession(userId, activeChild.id);
                      ref.read(childSessionProvider.notifier)
                        ..reset()
                        ..setSessionId(sessionId);

                      if (context.mounted) context.push('/child/home');
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: ${e.toString()}')),
                        );
                      }
                    }
                  },
                ),
                const SizedBox(height: 32),

                // Recent sessions preview
                Text('Recent Sessions',
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 13)),
                const SizedBox(height: 8),
                _RecentSessionPreview(activeChild: activeChild),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChildSelector extends ConsumerWidget {
  const _ChildSelector({required this.profiles});
  final List<ChildProfile> profiles;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(activeChildProfileProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final profile in profiles)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(profile.name),
                selected: active?.id == profile.id,
                onSelected: (_) =>
                    ref.read(activeChildProfileProvider.notifier).select(profile),
                selectedColor: AppColors.seedGreen,
                labelStyle: TextStyle(
                  color: active?.id == profile.id
                      ? Colors.white
                      : AppColors.textPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 13)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentSessionPreview extends ConsumerWidget {
  const _RecentSessionPreview({required this.activeChild});
  final ChildProfile? activeChild;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(childSessionsProvider);

    return sessionsAsync.when(
      loading: () => const SizedBox(
        height: 120,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.05),
          border: Border.all(color: Colors.red.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text('Error loading sessions',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
      ),
      data: (sessions) {
        if (activeChild == null) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.05),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('Select a child to view sessions',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          );
        }

        if (sessions.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.05),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('No sessions yet',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          );
        }

        // Show most recent session that has a completed report
        final sessionWithReport = sessions.firstWhere(
          (s) => s.report != null,
          orElse: () => sessions.first,
        );
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
                      fmt.format(sessionWithReport.startedAt),
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    if (sessionWithReport.durationMinutes > 0)
                      Text(
                        '${sessionWithReport.durationMinutes} min',
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 12),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                if (sessionWithReport.report != null)
                  Text(
                    sessionWithReport.report!.summary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, height: 1.5),
                  )
                else
                  Text(
                    'No reports yet',
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 13),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
