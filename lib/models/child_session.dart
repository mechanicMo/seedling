import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:seedling/models/session_report.dart';

part 'child_session.freezed.dart';
part 'child_session.g.dart';

@freezed
class ChildSession with _$ChildSession {
  const factory ChildSession({
    required String id,
    required DateTime startedAt,
    DateTime? endedAt,
    @Default(0) int durationMinutes,
    @Default([]) List<String> activityIds,
    SessionReport? report,
  }) = _ChildSession;

  factory ChildSession.fromJson(Map<String, dynamic> json) =>
      _$ChildSessionFromJson(json);

  factory ChildSession.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChildSession(
      id: doc.id,
      startedAt: data['started_at'] is Timestamp
          ? (data['started_at'] as Timestamp).toDate()
          : DateTime.now(),
      endedAt: data['ended_at'] is Timestamp
          ? (data['ended_at'] as Timestamp).toDate()
          : null,
      durationMinutes: data['duration_minutes'] as int? ?? 0,
      activityIds: List<String>.from(
          (data['activities_completed'] as List? ?? [])
              .map((a) => (a as Map)['activity_id'] as String)),
      report: data['report'] != null
          ? SessionReport.fromMap(
              Map<String, dynamic>.from(data['report'] as Map))
          : null,
    );
  }
}
