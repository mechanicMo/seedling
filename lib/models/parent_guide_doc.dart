import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'parent_guide_doc.freezed.dart';
part 'parent_guide_doc.g.dart';

@freezed
class ParentGuideDoc with _$ParentGuideDoc {
  const factory ParentGuideDoc({
    required String id,
    required String title,
    required String category,
    @Default([]) List<String> ageRanges,
    @Default([]) List<String> situationTags,
    required String quickResponse,
    required String fullGuide,
    @Default([]) List<String> researchBasis,
    @Default([]) List<String> doThis,
    @Default([]) List<String> notThat,
    @Default([]) List<String> followUpActivityIds,
    @Default(true) bool published,
    @Default(1) int version,
  }) = _ParentGuideDoc;

  factory ParentGuideDoc.fromJson(Map<String, dynamic> json) =>
      _$ParentGuideDocFromJson(json);

  factory ParentGuideDoc.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ParentGuideDoc(
      id: doc.id,
      title: data['title'] as String,
      category: data['category'] as String,
      ageRanges: List<String>.from(data['age_ranges'] as List? ?? []),
      situationTags: List<String>.from(data['situation_tags'] as List? ?? []),
      quickResponse: data['quick_response'] as String,
      fullGuide: data['full_guide'] as String,
      researchBasis: List<String>.from(data['research_basis'] as List? ?? []),
      doThis: List<String>.from(data['do_this'] as List? ?? []),
      notThat: List<String>.from(data['not_that'] as List? ?? []),
      followUpActivityIds: List<String>.from(data['follow_up_activity_ids'] as List? ?? []),
      published: data['published'] as bool? ?? true,
      version: data['version'] as int? ?? 1,
    );
  }
}
