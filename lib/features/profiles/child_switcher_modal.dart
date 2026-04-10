import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:seedling/core/theme/app_theme.dart';
import 'package:seedling/features/profiles/profiles_provider.dart';

/// Opens the child switcher bottom sheet.
void showChildSwitcher(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => const _ChildSwitcherSheet(),
  );
}

class _ChildSwitcherSheet extends ConsumerWidget {
  const _ChildSwitcherSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profiles = ref.watch(childProfilesProvider).valueOrNull ?? [];
    final active = ref.watch(activeChildProfileProvider);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Switch child',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: 12),
            for (final profile in profiles)
              ListTile(
                leading: CircleAvatar(
                  radius: 20,
                  backgroundColor: active?.id == profile.id
                      ? AppColors.seedGreen
                      : AppColors.seedGreen.withOpacity(0.15),
                  child: Text(
                    profile.name.isNotEmpty ? profile.name[0].toUpperCase() : '?',
                    style: TextStyle(
                      color: active?.id == profile.id
                          ? Colors.white
                          : AppColors.seedGreen,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
                title: Text(
                  profile.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  'Ages ${profile.ageRange}',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
                trailing: active?.id == profile.id
                    ? const Icon(Icons.check_circle,
                        color: AppColors.seedGreen, size: 20)
                    : null,
                onTap: () {
                  ref.read(activeChildProfileProvider.notifier).select(profile);
                  Navigator.of(context).pop();
                },
              ),
            const Divider(height: 1),
            ListTile(
              leading: CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.seedGreen.withOpacity(0.12),
                child: const Icon(Icons.add, color: AppColors.seedGreen, size: 20),
              ),
              title: const Text(
                'Add a child',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              onTap: () {
                Navigator.of(context).pop();
                context.push('/profiles/add');
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

/// Tappable child name + chevron. Drop this wherever you need the switcher trigger.
/// Set [chipStyle] to true to render as a filled green chip (like the home screen selector).
class ChildSwitcherButton extends ConsumerWidget {
  const ChildSwitcherButton({this.style, this.chipStyle = false, super.key});

  final TextStyle? style;
  final bool chipStyle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(activeChildProfileProvider);
    if (active == null) return const SizedBox.shrink();

    if (chipStyle) {
      return GestureDetector(
        onTap: () => showChildSwitcher(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.seedGreen,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                active.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 2),
              const Icon(Icons.expand_more, size: 16, color: Colors.white),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => showChildSwitcher(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            active.name,
            style: style ??
                TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(width: 2),
          Icon(
            Icons.expand_more,
            size: 16,
            color: style?.color ?? AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}
