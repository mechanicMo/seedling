import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:seedling/core/constants/app_constants.dart';

/// Provides the FirebaseAuth instance. Override in tests with a mock.
final firebaseAuthProvider = Provider<FirebaseAuth>(
  (_) => FirebaseAuth.instance,
);

/// Real-time stream of the current Firebase user. Null = not signed in.
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

/// Convenience: true if a user is currently signed in.
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).valueOrNull != null;
});

/// Handles all auth operations: email sign-in/up, Google, sign-out.
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AsyncValue<void>>(
  (ref) => AuthNotifier(ref),
);

class AuthNotifier extends StateNotifier<AsyncValue<void>> {
  AuthNotifier(this.ref) : super(const AsyncValue.data(null));

  final Ref ref;

  Future<void> signInWithEmail(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await ref
          .read(firebaseAuthProvider)
          .signInWithEmailAndPassword(email: email, password: password);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    state = const AsyncValue.loading();
    try {
      final credential = await ref
          .read(firebaseAuthProvider)
          .createUserWithEmailAndPassword(email: email, password: password);

      await credential.user!.updateDisplayName(displayName);

      await FirebaseFirestore.instance
          .collection(AppConstants.usersCollection)
          .doc(credential.user!.uid)
          .set({
        'email': email,
        'display_name': displayName,
        'tier': 'free',
        'created_at': FieldValue.serverTimestamp(),
      });
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        state = const AsyncValue.data(null);
        return; // user cancelled
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await ref
          .read(firebaseAuthProvider)
          .signInWithCredential(credential);

      // Create Firestore user doc only on first sign-in
      final userDoc = FirebaseFirestore.instance
          .collection(AppConstants.usersCollection)
          .doc(userCredential.user!.uid);

      final docSnapshot = await userDoc.get();
      if (!docSnapshot.exists) {
        await userDoc.set({
          'email': userCredential.user!.email,
          'display_name': userCredential.user!.displayName ?? '',
          'tier': 'free',
          'created_at': FieldValue.serverTimestamp(),
        });
      }
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await Future.wait([
        ref.read(firebaseAuthProvider).signOut(),
        GoogleSignIn().signOut(),
      ]);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}
