import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seedling/features/auth/auth_providers.dart';
import 'package:seedling/features/profiles/profiles_provider.dart';
import 'package:seedling/models/app_user.dart';

/// Streams the current user's AppUser document. Null if not signed in.
final appUserProvider = StreamProvider<AppUser?>((ref) {
  final authAsync = ref.watch(authStateProvider);
  final userId = authAsync.valueOrNull?.uid;
  if (userId == null) return Stream.value(null);
  return ref.watch(firestoreServiceProvider).userDocStream(userId);
});

/// True if the current user has a 'paid' tier.
final isPaidProvider = FutureProvider<bool>((ref) async {
  final user = await ref.watch(appUserProvider.future);
  return user?.tier == 'paid';
});
