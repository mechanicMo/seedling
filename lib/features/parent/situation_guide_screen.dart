import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:seedling/core/theme/app_theme.dart';
import 'package:seedling/features/parent/parent_providers.dart';
import 'package:seedling/features/profiles/profiles_provider.dart';

class SituationGuideScreen extends ConsumerStatefulWidget {
  const SituationGuideScreen({super.key});

  @override
  ConsumerState<SituationGuideScreen> createState() => _SituationGuideScreenState();
}

class _SituationGuideScreenState extends ConsumerState<SituationGuideScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _launchChat(String situation) {
    if (situation.trim().isEmpty) return;
    context.push('/guidance/chat', extra: situation.trim());
  }

  @override
  Widget build(BuildContext context) {
    final activeChild = ref.watch(activeChildProfileProvider);
    final categories = ref.watch(situationCategoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Get Guidance'),
        actions: [
          if (activeChild != null)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  activeChild.name,
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Free-text entry
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "What's happening right now?",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    color: AppColors.seedGreen,
                    onPressed: () => _launchChat(_controller.text),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.seedGreen, width: 2),
                  ),
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: _launchChat,
                maxLines: 2,
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: Text(
                'Or tap a common situation:',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
            ),

            // Quick-tap chips
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final cat in categories)
                      _SituationChip(
                        label: cat.label,
                        onTap: () => _launchChat(cat.label),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SituationChip extends StatelessWidget {
  const _SituationChip({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
      backgroundColor: AppColors.warmCream,
      labelStyle: TextStyle(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: AppColors.seedGreen.withOpacity(0.3)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
    );
  }
}
