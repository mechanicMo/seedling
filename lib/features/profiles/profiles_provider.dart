import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seedling/features/auth/auth_providers.dart';
import 'package:seedling/models/models.dart';
import 'package:seedling/services/firestore_service.dart';

/// Provides the FirestoreService singleton. Override in tests.
final firestoreServiceProvider = Provider<FirestoreService>(
  (_) => FirestoreService(),
);

/// Returns the current user's UID if authenticated, null otherwise.
final currentUserIdProvider = Provider<String?>((ref) {
  // Try to get from the auth stream first (if it's emitted)
  final authAsync = ref.watch(authStateProvider);
  final userFromStream = authAsync.valueOrNull;
  if (userFromStream != null) return userFromStream.uid;

  // Fallback to currentUser for synchronous access
  return ref.watch(firebaseAuthProvider).currentUser?.uid;
});

/// Real-time stream of child profiles for the current user.
final childProfilesProvider = StreamProvider<List<ChildProfile>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) {
    return Stream.value([]);
  }

  return ref.watch(firestoreServiceProvider).getChildProfiles(userId);
});

/// The currently selected child profile (for context-aware parent features).
/// Defaults to the first profile if any exist.
final activeChildProfileProvider =
    StateNotifierProvider<ActiveChildProfileNotifier, ChildProfile?>(
  (ref) => ActiveChildProfileNotifier(ref),
);

class ActiveChildProfileNotifier extends StateNotifier<ChildProfile?> {
  ActiveChildProfileNotifier(this.ref) : super(null) {
    // Watch childProfiles and auto-select first if none selected
    ref.listen(childProfilesProvider, (_, next) {
      final profiles = next.valueOrNull;
      if (state == null && profiles?.isNotEmpty == true) {
        state = profiles!.first;
      }
    });
  }

  final Ref ref;

  void select(ChildProfile profile) => state = profile;
}

/// Handles create/update/delete operations for child profiles.
final childProfilesNotifierProvider =
    StateNotifierProvider<ChildProfilesNotifier, void>(
  (ref) => ChildProfilesNotifier(ref),
);

class ChildProfilesNotifier extends StateNotifier<void> {
  ChildProfilesNotifier(this.ref) : super(null);

  final Ref ref;

  Future<void> add(ChildProfile profile) async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) throw StateError('Not authenticated');

    await ref
        .read(firestoreServiceProvider)
        .createChildProfile(userId, profile);
  }

  Future<void> update(ChildProfile profile) async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) throw StateError('Not authenticated');

    await ref
        .read(firestoreServiceProvider)
        .updateChildProfile(userId, profile);
  }

  Future<void> delete(String childId) async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) throw StateError('Not authenticated');

    await ref
        .read(firestoreServiceProvider)
        .deleteChildProfile(userId, childId);
  }
}
