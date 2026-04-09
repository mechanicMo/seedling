import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seedling/core/constants/app_constants.dart';
import 'package:seedling/features/auth/auth_providers.dart';
import 'package:seedling/features/profiles/profiles_provider.dart';
import 'package:seedling/models/app_user.dart';
import 'package:seedling/services/firestore_service.dart';

// ── AppUser stream ───────────────────────────────────────────────────────────

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

// ── Usage counts ─────────────────────────────────────────────────────────────

/// Streams AI queries used today. Emits 0 if not signed in.
final aiQueriesUsedTodayProvider = StreamProvider<int>((ref) {
  final authAsync = ref.watch(authStateProvider);
  final userId = authAsync.valueOrNull?.uid;
  if (userId == null) return Stream.value(0);
  return ref.watch(firestoreServiceProvider).aiQueriesUsedTodayStream(userId);
});

/// Streams session reports used this calendar month. Emits 0 if not signed in.
final sessionReportsUsedThisMonthProvider = StreamProvider<int>((ref) {
  final authAsync = ref.watch(authStateProvider);
  final userId = authAsync.valueOrNull?.uid;
  if (userId == null) return Stream.value(0);
  return ref.watch(firestoreServiceProvider).sessionReportsUsedThisMonthStream(userId);
});

/// Number of child profiles currently created.
final childProfileCountProvider = FutureProvider<int>((ref) async {
  final profiles = await ref.watch(childProfilesProvider.future);
  return profiles.length;
});

// ── Subscription status ───────────────────────────────────────────────────────

class SubscriptionStatus {
  const SubscriptionStatus({
    required this.isPaid,
    required this.canAddChild,
    required this.canSendAiMessage,
    required this.aiQueriesRemaining,
    required this.sessionReportsRemaining,
    required this.canViewSessionReports,
  });

  final bool isPaid;
  final bool canAddChild;
  final bool canSendAiMessage;
  final int aiQueriesRemaining;
  final int sessionReportsRemaining;
  final bool canViewSessionReports;
}

final subscriptionStatusProvider = FutureProvider<SubscriptionStatus>((ref) async {
  // The streams are watched here; any update to usage counts will trigger a rebuild
  final aiUsedAsync = ref.watch(aiQueriesUsedTodayProvider);
  final reportsUsedAsync = ref.watch(sessionReportsUsedThisMonthProvider);

  final aiUsed = aiUsedAsync.valueOrNull ?? 0;
  final reportsUsed = reportsUsedAsync.valueOrNull ?? 0;

  final isPaid = await ref.watch(isPaidProvider.future);
  final profileCount = await ref.watch(childProfileCountProvider.future);

  if (isPaid) {
    return const SubscriptionStatus(
      isPaid: true,
      canAddChild: true,
      canSendAiMessage: true,
      aiQueriesRemaining: 999,
      sessionReportsRemaining: 999,
      canViewSessionReports: true,
    );
  }

  final aiRemaining = (AppConstants.freeAiQueriesPerDay - aiUsed).clamp(0, AppConstants.freeAiQueriesPerDay);
  final reportsRemaining = (AppConstants.freeSessionReportsPerMonth - reportsUsed).clamp(0, AppConstants.freeSessionReportsPerMonth);

  return SubscriptionStatus(
    isPaid: false,
    canAddChild: profileCount < AppConstants.freeChildProfileLimit,
    canSendAiMessage: aiUsed < AppConstants.freeAiQueriesPerDay,
    aiQueriesRemaining: aiRemaining,
    sessionReportsRemaining: reportsRemaining,
    canViewSessionReports: reportsUsed < AppConstants.freeSessionReportsPerMonth,
  );
});
