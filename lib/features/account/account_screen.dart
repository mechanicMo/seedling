import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:seedling/core/constants/app_constants.dart';
import 'package:seedling/core/theme/app_theme.dart';
import 'package:seedling/features/account/account_providers.dart';
import 'package:seedling/features/auth/auth_providers.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(appUserProvider);
    final statusAsync = ref.watch(subscriptionStatusProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (user) {
          if (user == null) return const SizedBox.shrink();
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              // Profile header
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.seedGreenLight,
                    child: Text(
                      user.displayName.isNotEmpty ? user.displayName[0].toUpperCase() : '?',
                      style: const TextStyle(
                          fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.displayName,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 2),
                        Text(user.email,
                            style: TextStyle(
                                fontSize: 13, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Tier section
              _SectionLabel(label: 'Plan'),
              const SizedBox(height: 8),
              Row(
                children: [
                  _TierBadge(isPaid: user.tier == 'paid'),
                  const Spacer(),
                  if (user.tier != 'paid')
                    FilledButton(
                      onPressed: () => _openUpgradeUrl(context),
                      style: FilledButton.styleFrom(
                          backgroundColor: AppColors.seedGreen),
                      child: const Text('Upgrade to Premium'),
                    ),
                ],
              ),

              const SizedBox(height: 32),

              // Usage section (free only)
              if (user.tier != 'paid')
                statusAsync.when(
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (status) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionLabel(label: 'Daily Usage'),
                      const SizedBox(height: 8),
                      _UsageRow(
                        label: 'AI guidance queries',
                        remaining: status.aiQueriesRemaining,
                        limit: AppConstants.freeAiQueriesPerDay,
                      ),
                      const SizedBox(height: 8),
                      _SectionLabel(label: 'Monthly Usage'),
                      const SizedBox(height: 8),
                      _UsageRow(
                        label: 'Session reports',
                        remaining: status.sessionReportsRemaining,
                        limit: AppConstants.freeSessionReportsPerMonth,
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),

              // Sign out
              _SectionLabel(label: 'Account'),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.logout, color: AppColors.error),
                title: const Text('Sign out',
                    style: TextStyle(color: AppColors.error)),
                onTap: () =>
                    ref.read(authNotifierProvider.notifier).signOut(),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _openUpgradeUrl(BuildContext context) async {
    final uri = Uri.parse(AppConstants.stripeCheckoutUrl);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open upgrade page.')),
        );
      }
    }
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(label,
        style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
            letterSpacing: 0.8));
  }
}

class _TierBadge extends StatelessWidget {
  const _TierBadge({required this.isPaid});
  final bool isPaid;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isPaid
            ? AppColors.seedGreen.withValues(alpha: 0.12)
            : Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPaid ? AppColors.seedGreen : Colors.grey,
          width: 1,
        ),
      ),
      child: Text(
        isPaid ? 'Premium' : 'Free',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: isPaid ? AppColors.seedGreen : AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _UsageRow extends StatelessWidget {
  const _UsageRow({
    required this.label,
    required this.remaining,
    required this.limit,
  });

  final String label;
  final int remaining;
  final int limit;

  @override
  Widget build(BuildContext context) {
    final used = limit - remaining;
    final fraction = (used / limit).clamp(0.0, 1.0);
    final isNearLimit = fraction >= 0.8;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(fontSize: 13)),
            Text('$remaining remaining',
                style: TextStyle(
                    fontSize: 12,
                    color: isNearLimit ? AppColors.error : AppColors.textSecondary)),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: fraction,
          backgroundColor: Colors.grey.withValues(alpha: 0.15),
          valueColor: AlwaysStoppedAnimation(
            isNearLimit ? AppColors.error : AppColors.seedGreen,
          ),
          minHeight: 6,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}
