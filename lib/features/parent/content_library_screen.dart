import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:seedling/core/constants/app_constants.dart';
import 'package:seedling/core/theme/app_theme.dart';
import 'package:seedling/features/parent/parent_providers.dart';
import 'package:seedling/models/models.dart';

class ContentLibraryScreen extends ConsumerStatefulWidget {
  const ContentLibraryScreen({super.key});

  @override
  ConsumerState<ContentLibraryScreen> createState() => _ContentLibraryScreenState();
}

class _ContentLibraryScreenState extends ConsumerState<ContentLibraryScreen> {
  String _searchQuery = '';
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final guidesAsync = ref.watch(parentGuidesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Guide Library'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search guides...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
              onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
            ),
          ),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                _CategoryChip(
                  label: 'All',
                  selected: _selectedCategory == null,
                  onTap: () => setState(() => _selectedCategory = null),
                ),
                for (final cat in AppConstants.parentGuideCategories)
                  _CategoryChip(
                    label: _categoryLabel(cat),
                    selected: _selectedCategory == cat,
                    onTap: () => setState(() =>
                        _selectedCategory = _selectedCategory == cat ? null : cat),
                  ),
              ],
            ),
          ),

          Expanded(
            child: guidesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (guides) {
                final filtered = guides.where((g) {
                  final matchesSearch = _searchQuery.isEmpty ||
                      g.title.toLowerCase().contains(_searchQuery) ||
                      g.category.contains(_searchQuery) ||
                      g.situationTags
                          .any((t) => t.contains(_searchQuery));
                  final matchesCat = _selectedCategory == null ||
                      g.category == _selectedCategory;
                  return matchesSearch && matchesCat;
                }).toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Text(
                      _searchQuery.isNotEmpty
                          ? 'No guides match "$_searchQuery"'
                          : 'No guides in this category yet.',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) =>
                      _GuideTile(guide: filtered[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _categoryLabel(String cat) => switch (cat) {
        'behavior' => 'Behavior',
        'sleep' => 'Sleep',
        'emotions' => 'Emotions',
        'development' => 'Development',
        'routines' => 'Routines',
        _ => cat,
      };
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: AppColors.seedGreen,
        labelStyle: TextStyle(
          color: selected ? Colors.white : AppColors.textPrimary,
          fontSize: 13,
        ),
        checkmarkColor: Colors.white,
      ),
    );
  }
}

class _GuideTile extends StatelessWidget {
  const _GuideTile({required this.guide});
  final ParentGuideDoc guide;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(guide.title,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          guide.quickResponse,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: AppColors.textSecondary, fontSize: 13, height: 1.4),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push('/library/guide/${guide.id}'),
      ),
    );
  }
}
