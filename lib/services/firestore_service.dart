import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seedling/core/constants/app_constants.dart';
import 'package:seedling/models/models.dart';

class FirestoreService {
  FirestoreService({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  // ── Child Profiles ──────────────────────────────────────────────────────────

  CollectionReference<Map<String, dynamic>> _childrenRef(String userId) => _db
      .collection(AppConstants.usersCollection)
      .doc(userId)
      .collection(AppConstants.childrenCollection);

  /// Creates a child profile. The [profile.id] is ignored — Firestore assigns a new id.
  Future<ChildProfile> createChildProfile(
      String userId, ChildProfile profile) async {
    final docRef = await _childrenRef(userId).add(profile.toFirestore());
    final snapshot = await docRef.get();
    return ChildProfile.fromFirestore(snapshot);
  }

  /// Returns a real-time stream of child profiles for [userId].
  Stream<List<ChildProfile>> getChildProfiles(String userId) {
    return _childrenRef(userId).snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => ChildProfile.fromFirestore(doc))
              .toList(),
        );
  }

  /// Updates an existing child profile. [profile.id] must be set.
  Future<void> updateChildProfile(String userId, ChildProfile profile) async {
    await _childrenRef(userId).doc(profile.id).update(profile.toFirestore());
  }

  /// Deletes a child profile by id.
  Future<void> deleteChildProfile(String userId, String childId) async {
    await _childrenRef(userId).doc(childId).delete();
  }

  /// Returns true if the user has at least one child profile.
  Future<bool> hasChildProfiles(String userId) async {
    final snapshot = await _childrenRef(userId).limit(1).get();
    return snapshot.docs.isNotEmpty;
  }

  // ── User Document ────────────────────────────────────────────────────────────

  /// Fetches the user document. Returns null if it doesn't exist.
  Future<AppUser?> getUser(String userId) async {
    final doc = await _db
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .get();
    if (!doc.exists) return null;
    return AppUser.fromFirestore(doc);
  }

  /// Real-time stream of the parent user document.
  Stream<AppUser?> userDocStream(String userId) {
    return _db
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .snapshots()
        .map((doc) => doc.exists ? AppUser.fromFirestore(doc) : null);
  }

  /// Returns AI queries used today for [userId]. Returns 0 if no record exists.
  Future<int> getAiQueriesUsedToday(String userId) async {
    final today = _todayKey();
    final doc = await _db
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .collection('daily_usage')
        .doc(today)
        .get();
    if (!doc.exists) return 0;
    return (doc.data()?['ai_queries'] as int?) ?? 0;
  }

  /// Increments today's AI query count by 1.
  Future<void> incrementAiQueryUsage(String userId) async {
    final today = _todayKey();
    await _db
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .collection('daily_usage')
        .doc(today)
        .set({'ai_queries': FieldValue.increment(1)}, SetOptions(merge: true));
  }

  /// Returns session reports used this calendar month for [userId].
  Future<int> getSessionReportsUsedThisMonth(String userId) async {
    final month = _monthKey();
    final doc = await _db
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .collection('monthly_usage')
        .doc(month)
        .get();
    if (!doc.exists) return 0;
    return (doc.data()?['session_reports'] as int?) ?? 0;
  }

  /// Increments this month's session report count by 1.
  Future<void> incrementSessionReportUsage(String userId) async {
    final month = _monthKey();
    await _db
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .collection('monthly_usage')
        .doc(month)
        .set({'session_reports': FieldValue.increment(1)}, SetOptions(merge: true));
  }

  /// Streams AI queries used today for [userId]. Emits 0 if no record exists.
  Stream<int> aiQueriesUsedTodayStream(String userId) {
    final today = _todayKey();
    return _db
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .collection('daily_usage')
        .doc(today)
        .snapshots()
        .map((doc) => (doc.data()?['ai_queries'] as int?) ?? 0);
  }

  /// Streams session reports used this calendar month for [userId]. Emits 0 if no record exists.
  Stream<int> sessionReportsUsedThisMonthStream(String userId) {
    final month = _monthKey();
    return _db
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .collection('monthly_usage')
        .doc(month)
        .snapshots()
        .map((doc) => (doc.data()?['session_reports'] as int?) ?? 0);
  }

  String _todayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  String _monthKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}';
  }

  // ── Parent Guides ────────────────────────────────────────────────────────────

  /// Fetches all published ParentGuides for a given age range.
  Future<List<ParentGuideDoc>> getParentGuides({String? ageRange}) async {
    Query<Map<String, dynamic>> query = _db
        .collection('parent_guides')
        .where('published', isEqualTo: true);

    if (ageRange != null) {
      query = query.where('age_ranges', arrayContains: ageRange);
    }

    final snapshot = await query.get();
    return snapshot.docs.map(ParentGuideDoc.fromFirestore).toList();
  }

  /// Fetches a single ParentGuide by ID.
  Future<ParentGuideDoc?> getParentGuide(String guideId) async {
    final doc = await _db.collection('parent_guides').doc(guideId).get();
    if (!doc.exists) return null;
    return ParentGuideDoc.fromFirestore(doc);
  }

  // ── Child Sessions ────────────────────────────────────────────────────────

  /// Real-time stream of child sessions, newest first.
  Stream<List<ChildSession>> childSessionsStream(
      String userId, String childId) {
    return _db
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .collection(AppConstants.childrenCollection)
        .doc(childId)
        .collection(AppConstants.sessionsCollection)
        .orderBy('started_at', descending: true)
        .limit(20)
        .snapshots()
        .map((snap) =>
            snap.docs.map(ChildSession.fromFirestore).toList());
  }

  // ── Child Activities ──────────────────────────────────────────────────────

  /// Fetches published activities for a child's age range and enabled types.
  Future<List<ChildActivity>> getChildActivities({
    required String ageRange,
    required List<String> enabledTypes,
  }) async {
    if (enabledTypes.isEmpty) return [];

    final snapshot = await _db
        .collection(AppConstants.childActivitiesCollection)
        .where('published', isEqualTo: true)
        .where('age_ranges', arrayContains: ageRange)
        .get();

    return snapshot.docs
        .map(ChildActivity.fromFirestore)
        .where((a) => enabledTypes.contains(a.type))
        .toList();
  }

  // ── Session Lifecycle ─────────────────────────────────────────────────────

  /// Creates a new session document and returns its ID.
  Future<String> startChildSession(String userId, String childId) async {
    final docRef = await _childrenRef(userId)
        .doc(childId)
        .collection(AppConstants.sessionsCollection)
        .add({
      'started_at': FieldValue.serverTimestamp(),
      'duration_minutes': 0,
      'activities_completed': [],
    });
    return docRef.id;
  }

  /// Writes final session data. Report generation is triggered separately via Cloud Function.
  Future<void> endChildSession({
    required String userId,
    required String childId,
    required String sessionId,
    required List<Map<String, dynamic>> completedActivities,
    required int durationMinutes,
  }) async {
    await _childrenRef(userId)
        .doc(childId)
        .collection(AppConstants.sessionsCollection)
        .doc(sessionId)
        .update({
      'ended_at': FieldValue.serverTimestamp(),
      'duration_minutes': durationMinutes,
      'activities_completed': completedActivities,
      'report_status': 'generating',
    });
  }

  /// Marks a session's report as failed after a Cloud Function error.
  Future<void> markReportFailed({
    required String userId,
    required String childId,
    required String sessionId,
    required String error,
  }) async {
    await _childrenRef(userId)
        .doc(childId)
        .collection(AppConstants.sessionsCollection)
        .doc(sessionId)
        .update({
      'report_status': 'failed',
      'report_error': error,
    });
  }

  /// Clears report status flags once the report is generated.
  /// (Cloud Function writes the `report` field itself; this just cleans up the state.)
  Future<void> clearReportStatus({
    required String userId,
    required String childId,
    required String sessionId,
  }) async {
    await _childrenRef(userId)
        .doc(childId)
        .collection(AppConstants.sessionsCollection)
        .doc(sessionId)
        .update({
      'report_status': FieldValue.delete(),
      'report_error': FieldValue.delete(),
    });
  }

  /// Reads the raw `activities_completed` array for retrying report generation.
  Future<List<Map<String, dynamic>>> getSessionActivities({
    required String userId,
    required String childId,
    required String sessionId,
  }) async {
    final doc = await _childrenRef(userId)
        .doc(childId)
        .collection(AppConstants.sessionsCollection)
        .doc(sessionId)
        .get();
    final data = doc.data();
    if (data == null) return [];
    final raw = data['activities_completed'] as List? ?? [];
    return raw
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }
}
