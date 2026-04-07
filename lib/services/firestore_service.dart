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
    });
  }
}
