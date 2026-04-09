import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:seedling/core/constants/app_constants.dart';
import 'package:seedling/core/theme/app_theme.dart';
import 'package:seedling/features/account/account_providers.dart';
import 'package:seedling/features/profiles/profiles_provider.dart';
import 'package:seedling/models/child_profile.dart';

class ProfilesScreen extends ConsumerWidget {
  const ProfilesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profilesAsync = ref.watch(childProfilesProvider);
    final statusAsync = ref.watch(subscriptionStatusProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Children'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              final status = statusAsync.valueOrNull;
              if (status != null && !status.canAddChild) {
                _showProfileLimitDialog(context);
              } else {
                context.push('/profiles/add');
              }
            },
          ),
        ],
      ),
      body: profilesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (profiles) {
          if (profiles.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No children yet.',
                      style: TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.push('/profiles/add'),
                    child: const Text('Add a child'),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: profiles.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final profile = profiles[index];
              return _ProfileTile(profile: profile);
            },
          );
        },
      ),
      floatingActionButton: profilesAsync.valueOrNull?.isNotEmpty == true
          ? FloatingActionButton(
              onPressed: () {
                final status = statusAsync.valueOrNull;
                if (status != null && !status.canAddChild) {
                  _showProfileLimitDialog(context);
                } else {
                  context.push('/profiles/add');
                }
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  void _showProfileLimitDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Child profile limit reached'),
        content: Text(
          'Free accounts can have up to ${AppConstants.freeChildProfileLimit} child profiles. '
          'Upgrade to Premium for unlimited profiles.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Not now'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              context.push('/account');
            },
            child: const Text('Upgrade'),
          ),
        ],
      ),
    );
  }
}

class _ProfileTile extends ConsumerWidget {
  const _ProfileTile({required this.profile});

  final ChildProfile profile;

  String _ageRangeLabel(String ageRange) {
    return switch (ageRange) {
      AppConstants.ageRange0to3 => 'Ages 0-3',
      AppConstants.ageRange3to7 => 'Ages 3-7',
      AppConstants.ageRange7to12 => 'Ages 7-12',
      _ => ageRange,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.seedGreenLight,
          child: Text(
            profile.name[0].toUpperCase(),
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(profile.name,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(_ageRangeLabel(profile.ageRange)),
        trailing: PopupMenuButton<String>(
          onSelected: (value) async {
            if (value == 'settings') {
              context.push('/profiles/settings/${profile.id}');
            } else if (value == 'edit') {
              context.push('/profiles/edit/${profile.id}');
            } else if (value == 'delete') {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Delete profile?'),
                  content: Text(
                      'This will permanently delete ${profile.name}\'s profile and all session history.'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel')),
                    TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Delete',
                            style: TextStyle(color: AppColors.error))),
                  ],
                ),
              );
              if (confirm == true) {
                await ref
                    .read(childProfilesNotifierProvider.notifier)
                    .delete(profile.id);
              }
            }
          },
          itemBuilder: (_) => [
            const PopupMenuItem(value: 'settings', child: Text('Settings')),
            const PopupMenuItem(value: 'edit', child: Text('Edit')),
            const PopupMenuItem(
                value: 'delete',
                child: Text('Delete', style: TextStyle(color: AppColors.error))),
          ],
        ),
      ),
    );
  }
}
