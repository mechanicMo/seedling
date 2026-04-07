import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seedling/features/profiles/profiles_provider.dart';
import 'package:seedling/models/models.dart';
import 'package:seedling/services/ai_service.dart';

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
    final activeChild = _ref.read(activeChildProfileProvider);
    if (activeChild == null) return;

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
