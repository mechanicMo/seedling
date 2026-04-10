import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seedling/features/profiles/profiles_provider.dart';
import 'package:seedling/models/models.dart';

/// Available activities for the active child's age range and content selection.
final childActivitiesProvider =
    FutureProvider.autoDispose<List<ChildActivity>>((ref) async {
  final firestoreService = ref.watch(firestoreServiceProvider);
  final activeChild = ref.watch(activeChildProfileProvider);

  if (activeChild == null) return [];

  return firestoreService.getChildActivities(
    ageRange: activeChild.ageRange,
    enabledTypes: activeChild.contentSelection.enabledActivityTypes,
  );
});

// ── Session state ─────────────────────────────────────────────────────────

class ChildSessionState {
  const ChildSessionState({
    this.sessionId,
    this.completedActivities = const [],
    this.elapsedSeconds = 0,
    this.isComplete = false,
  });

  final String? sessionId;
  final List<CompletedActivityEntry> completedActivities;
  final int elapsedSeconds;
  final bool isComplete;

  int get elapsedMinutes => elapsedSeconds ~/ 60;

  ChildSessionState copyWith({
    String? sessionId,
    List<CompletedActivityEntry>? completedActivities,
    int? elapsedSeconds,
    bool? isComplete,
  }) {
    return ChildSessionState(
      sessionId: sessionId ?? this.sessionId,
      completedActivities: completedActivities ?? this.completedActivities,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      isComplete: isComplete ?? this.isComplete,
    );
  }
}

class CompletedActivityEntry {
  const CompletedActivityEntry({
    required this.activityId,
    required this.type,
    required this.durationSeconds,
    required this.title,
    required this.skillsTargeted,
    required this.parentFollowUp,
  });

  final String activityId;
  final String type;
  final int durationSeconds;
  final String title;
  final List<String> skillsTargeted;
  final String parentFollowUp;

  Map<String, dynamic> toMap() => {
    'activity_id': activityId,
    'type': type,
    'duration_seconds': durationSeconds,
    'title': title,
    'skills_targeted': skillsTargeted,
    'parent_follow_up': parentFollowUp,
  };
}

class ChildSessionNotifier extends StateNotifier<ChildSessionState> {
  ChildSessionNotifier() : super(const ChildSessionState());

  void setSessionId(String id) {
    state = state.copyWith(sessionId: id);
  }

  void markActivityComplete(ChildActivity activity, int durationSeconds) {
    final entry = CompletedActivityEntry(
      activityId: activity.id,
      type: activity.type,
      durationSeconds: durationSeconds,
      title: activity.title,
      skillsTargeted: activity.skillsTargeted,
      parentFollowUp: activity.parentFollowUp,
    );
    state = state.copyWith(
      completedActivities: [...state.completedActivities, entry],
    );
  }

  void tickSecond() {
    state = state.copyWith(elapsedSeconds: state.elapsedSeconds + 1);
  }

  void markComplete() {
    state = state.copyWith(isComplete: true);
  }

  void reset() {
    state = const ChildSessionState();
  }
}

final childSessionProvider =
    StateNotifierProvider<ChildSessionNotifier, ChildSessionState>(
  (ref) => ChildSessionNotifier(),
);
