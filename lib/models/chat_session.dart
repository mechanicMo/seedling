import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_session.freezed.dart';
part 'chat_session.g.dart';

@freezed
class ChatMessage with _$ChatMessage {
  const ChatMessage._();

  const factory ChatMessage({
    required String role,
    required String content,
    @Default([]) List<String> guideRefs,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);

  bool get isAssistant => role == 'assistant';
}

@freezed
class ChatSession with _$ChatSession {
  const factory ChatSession({
    required String id,
    required String childId,
    required DateTime createdAt,
    @Default([]) List<ChatMessage> messages,
  }) = _ChatSession;

  factory ChatSession.fromJson(Map<String, dynamic> json) =>
      _$ChatSessionFromJson(json);

  factory ChatSession.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final msgs = (data['messages'] as List? ?? [])
        .map((m) => ChatMessage.fromJson(Map<String, dynamic>.from(m as Map)))
        .toList();

    return ChatSession(
      id: doc.id,
      childId: data['child_id'] as String,
      createdAt: data['created_at'] is Timestamp
          ? (data['created_at'] as Timestamp).toDate()
          : DateTime.now(),
      messages: msgs,
    );
  }
}
