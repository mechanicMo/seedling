import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seedling/features/profiles/profiles_provider.dart';
import 'package:seedling/models/models.dart';
import 'package:seedling/services/firestore_service.dart';

/// All published parent guides, filtered by active child's age range.
final parentGuidesProvider = FutureProvider<List<ParentGuideDoc>>((ref) async {
  final firestoreService = ref.watch(firestoreServiceProvider);
  final activeChild = ref.watch(activeChildProfileProvider);

  return firestoreService.getParentGuides(
    ageRange: activeChild?.ageRange,
  );
});

/// Single guide by ID — used in guide detail screen.
final guideDetailProvider =
    FutureProvider.family<ParentGuideDoc?, String>((ref, guideId) async {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.getParentGuide(guideId);
});

/// Extracts simple tags from a free-text situation string.
/// MVP: keyword split. v2: NLP-based extraction via Cloud Function.
final situationTagsProvider = Provider.family<List<String>, String>((ref, situation) {
  return situation
      .toLowerCase()
      .split(RegExp(r'\s+'))
      .where((w) => w.length > 3)
      .take(10)
      .toList();
});

/// Quick-tap situation categories shown on the Situation Guide screen.
/// These are presented as chips — each maps to a search query.
final situationCategoriesProvider = Provider<List<SituationCategory>>((ref) {
  return [
    const SituationCategory(label: 'Tantrum / Meltdown', tags: ['tantrum', 'meltdown', 'screaming']),
    const SituationCategory(label: 'Hitting / Biting', tags: ['hitting', 'biting', 'kicking']),
    const SituationCategory(label: 'Won\'t Sleep', tags: ['sleep', 'bedtime', 'wont sleep']),
    const SituationCategory(label: 'Big Feelings', tags: ['emotions', 'feelings', 'upset', 'angry']),
    const SituationCategory(label: 'Screen Time', tags: ['screen', 'tablet', 'phone']),
    const SituationCategory(label: 'Not Eating', tags: ['eating', 'food', 'picky']),
    const SituationCategory(label: 'Morning Chaos', tags: ['morning', 'routine', 'rush']),
    const SituationCategory(label: 'Sibling Conflict', tags: ['sibling', 'fighting', 'sharing']),
    const SituationCategory(label: 'Back Talk', tags: ['backtalk', 'disrespect', 'attitude']),
    const SituationCategory(label: 'Separation Anxiety', tags: ['separation', 'clingy', 'crying school']),
    const SituationCategory(label: 'Potty Training', tags: ['potty', 'toilet', 'training']),
    const SituationCategory(label: 'Something Else', tags: []),
  ];
});

class SituationCategory {
  const SituationCategory({required this.label, required this.tags});
  final String label;
  final List<String> tags;
}
