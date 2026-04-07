import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_report.freezed.dart';
part 'session_report.g.dart';

@freezed
class SessionReport with _$SessionReport {
  const factory SessionReport({
    required String summary,
    @Default([]) List<String> skillsPracticed,
    @Default([]) List<String> parentFollowUps,
    @Default('') String aiObservations,
  }) = _SessionReport;

  factory SessionReport.fromJson(Map<String, dynamic> json) =>
      _$SessionReportFromJson(json);

  /// Convenience constructor from a raw Firestore/Cloud Function map (snake_case keys).
  factory SessionReport.fromMap(Map<String, dynamic> data) {
    return SessionReport(
      summary: data['summary'] as String? ?? '',
      skillsPracticed: List<String>.from(data['skills_practiced'] as List? ?? []),
      parentFollowUps: List<String>.from(data['parent_follow_ups'] as List? ?? []),
      aiObservations: data['ai_observations'] as String? ?? '',
    );
  }
}
