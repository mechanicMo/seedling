import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'child_activity.freezed.dart';
part 'child_activity.g.dart';

@freezed
class ChildActivity with _$ChildActivity {
  const factory ChildActivity({
    required String id,
    required String title,
    required String type,         // story | game | music | movement | video | creative
    @Default([]) List<String> ageRanges,
    @Default(5) int durationMinutes,
    @Default([]) List<String> mediaRefs,
    @Default([]) List<String> skillsTargeted,
    @Default([]) List<String> learningObjectives,
    @Default('') String parentFollowUp,
    @Default(false) bool published,
    @Default(1) int version,
  }) = _ChildActivity;

  factory ChildActivity.fromJson(Map<String, dynamic> json) =>
      _$ChildActivityFromJson(json);

  factory ChildActivity.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChildActivity(
      id: doc.id,
      title: data['title'] as String? ?? '',
      type: data['type'] as String? ?? 'story',
      ageRanges: List<String>.from(data['age_ranges'] as List? ?? []),
      durationMinutes: data['duration_minutes'] as int? ?? 5,
      mediaRefs: List<String>.from(data['media_refs'] as List? ?? []),
      skillsTargeted: List<String>.from(data['skills_targeted'] as List? ?? []),
      learningObjectives:
          List<String>.from(data['learning_objectives'] as List? ?? []),
      parentFollowUp: data['parent_follow_up'] as String? ?? '',
      published: data['published'] as bool? ?? false,
      version: data['version'] as int? ?? 1,
    );
  }
}
