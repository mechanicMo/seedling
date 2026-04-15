import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:seedling/core/theme/app_theme.dart';
import 'package:seedling/features/parent/ai_chat_notifier.dart';
import 'package:seedling/features/parent/parent_providers.dart';
import 'package:seedling/models/models.dart';

class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({this.initialSituation, super.key});
  final String? initialSituation;

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  bool _initialMessageSent = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_initialMessageSent && widget.initialSituation != null) {
        _initialMessageSent = true;
        ref.read(aiChatProvider.notifier).sendMessage(widget.initialSituation!);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    ref.read(aiChatProvider.notifier).sendMessage(text);
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(aiChatProvider);

    ref.listen(aiChatProvider, (_, __) {
      Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Seedling Guidance'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: chatState.messages.isEmpty && !chatState.isLoading
                ? Center(
                    child: Text(
                      'Ask anything about your child.',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: chatState.messages.length + (chatState.isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == chatState.messages.length) {
                        return const _TypingIndicator();
                      }
                      return _MessageBubble(
                        message: chatState.messages[index],
                      );
                    },
                  ),
          ),

          if (chatState.error != null)
            Container(
              width: double.infinity,
              color: AppColors.error.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                chatState.error!,
                style: TextStyle(color: AppColors.error, fontSize: 13),
              ),
            ),

          _ChatInput(
            controller: _controller,
            isLoading: chatState.isLoading,
            onSend: _send,
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends ConsumerWidget {
  const _MessageBubble({required this.message});
  final ChatMessage message;

  String _labelForGuide(String id, List<ParentGuideDoc> guides) {
    final match = guides.where((g) => g.id == id).toList();
    final title = match.isNotEmpty ? match.first.title : null;
    if (title == null || title.isEmpty) return 'Read guide';
    return title.length > 32 ? '${title.substring(0, 29)}…' : title;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isUser = !message.isAssistant;
    final guidesAsync = ref.watch(parentGuidesProvider);
    final guides = guidesAsync.asData?.value ?? const <ParentGuideDoc>[];

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.82,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isUser ? AppColors.seedGreen : AppColors.surface,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isUser ? 16 : 4),
                bottomRight: Radius.circular(isUser ? 4 : 16),
              ),
              border: isUser
                  ? null
                  : Border.all(color: AppColors.seedGreenLight.withOpacity(0.3)),
            ),
            child: Text(
              message.content,
              style: TextStyle(
                color: isUser ? Colors.white : AppColors.textPrimary,
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ),

          if (message.guideRefs.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Wrap(
                spacing: 6,
                children: [
                  for (final guideId in message.guideRefs)
                    ActionChip(
                      avatar: Icon(Icons.article_outlined,
                          size: 14, color: AppColors.seedGreen),
                      label: Text(_labelForGuide(guideId, guides),
                          style: TextStyle(
                              fontSize: 12, color: AppColors.seedGreen)),
                      onPressed: () =>
                          context.push('/guidance/guide/$guideId'),
                      backgroundColor: AppColors.seedGreen.withOpacity(0.08),
                      side: BorderSide(
                          color: AppColors.seedGreen.withOpacity(0.3)),
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
          ),
          border: Border.all(color: AppColors.seedGreenLight.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 40,
              child: LinearProgressIndicator(
                color: AppColors.seedGreen,
                backgroundColor: AppColors.seedGreenLight.withOpacity(0.2),
              ),
            ),
            const SizedBox(width: 8),
            Text('Thinking...',
                style:
                    TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

class _ChatInput extends StatelessWidget {
  const _ChatInput({
    required this.controller,
    required this.isLoading,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
              color: AppColors.textSecondary.withOpacity(0.2)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Ask a follow-up...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                maxLines: 3,
                minLines: 1,
                enabled: !isLoading,
              ),
            ),
            const SizedBox(width: 8),
            FilledButton(
              onPressed: isLoading ? null : onSend,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.seedGreen,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(12),
              ),
              child: const Icon(Icons.send, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}
