import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seedling/core/constants/app_constants.dart';
import 'package:seedling/features/account/account_providers.dart';
import 'package:seedling/features/auth/auth_providers.dart';
import 'package:seedling/features/profiles/profiles_provider.dart';
import 'package:seedling/models/models.dart';
import 'package:seedling/services/ai_service.dart';
import 'package:seedling/services/firestore_service.dart';

class AiChatState {
  const AiChatState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
    this.sessionId,
  });

  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;
  final String? sessionId;

  AiChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
    String? sessionId,
  }) {
    return AiChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      sessionId: sessionId ?? this.sessionId,
    );
  }
}

class AiChatNotifier extends StateNotifier<AiChatState> {
  AiChatNotifier(this._ref) : super(const AiChatState());

  final Ref _ref;

  Future<void> sendMessage(String situation) async {
    // Wait for profiles to load before proceeding — fixes race condition where
    // the initial message fires before the Firestore stream has emitted.
    var activeChild = _ref.read(activeChildProfileProvider);
    if (activeChild == null) {
      final profiles = await _ref.read(childProfilesProvider.future);
      activeChild = _ref.read(activeChildProfileProvider) ??
          (profiles.isNotEmpty ? profiles.first : null);
    }
    if (activeChild == null) return;

    // Check AI query limit
    final status = await _ref.read(subscriptionStatusProvider.future);
    if (!status.canSendAiMessage) {
      state = state.copyWith(
        error: 'You\'ve reached your daily limit of ${AppConstants.freeAiQueriesPerDay} AI queries. Upgrade to Premium for unlimited guidance.',
        isLoading: false,
      );
      return;
    }

    // Optimistically add user message
    state = state.copyWith(
      messages: [
        ...state.messages,
        ChatMessage(role: 'user', content: situation),
      ],
      isLoading: true,
      error: null,
    );

    try {
      final aiService = AiService();
      final result = await aiService.getParentGuidance(
        situation: situation,
        childId: activeChild.id,
      );

      state = state.copyWith(
        messages: [
          ...state.messages,
          ChatMessage(
            role: 'assistant',
            content: result.response,
            guideRefs: result.guideRefs,
          ),
        ],
        isLoading: false,
        sessionId: result.sessionId,
      );

      // Increment usage counter
      final authAsync = _ref.read(authStateProvider);
      final userId = authAsync.valueOrNull?.uid;
      if (userId != null) {
        await _ref.read(firestoreServiceProvider).incrementAiQueryUsage(userId);
      }
    } on FirebaseFunctionsException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.message ?? 'Something went wrong. Please try again.',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Something went wrong. Please try again.',
      );
    }
  }
}

final aiChatProvider =
    StateNotifierProvider.autoDispose<AiChatNotifier, AiChatState>((ref) {
  return AiChatNotifier(ref);
});
