import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:seedling/core/theme/app_theme.dart';
import 'package:seedling/features/child/child_providers.dart';
import 'package:seedling/features/child/widgets/audio_player_widget.dart';
import 'package:seedling/features/child/widgets/story_reader_widget.dart';
import 'package:seedling/features/child/widgets/guided_steps_widget.dart';
import 'package:seedling/features/child/widgets/tap_match_game_widget.dart';
import 'package:seedling/features/child/widgets/memory_flip_game_widget.dart';
import 'package:seedling/features/child/widgets/sequence_game_widget.dart';
import 'package:seedling/models/models.dart';

class ActivityPlayerScreen extends ConsumerStatefulWidget {
  const ActivityPlayerScreen({required this.activity, super.key});
  final ChildActivity activity;

  @override
  ConsumerState<ActivityPlayerScreen> createState() => _ActivityPlayerScreenState();
}

class _ActivityPlayerScreenState extends ConsumerState<ActivityPlayerScreen> {
  final _stopwatch = Stopwatch();

  bool get _hasAudio {
    final type = widget.activity.type;
    return (type == 'story' || type == 'music') &&
        widget.activity.mediaRefs.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    _stopwatch.start();
  }

  @override
  void dispose() {
    _stopwatch.stop();
    super.dispose();
  }

  void _markDone() {
    _stopwatch.stop();
    ref.read(childSessionProvider.notifier).markActivityComplete(
      widget.activity,
      _stopwatch.elapsed.inSeconds,
    );
    context.pop();
  }

  void _exitActivity() {
    _stopwatch.stop();
    context.pop();
  }

  Widget _buildContent() {
    final activity = widget.activity;
    switch (activity.contentType) {
      case 'story_pages':
        return StoryReaderWidget(content: activity.content, onDone: _markDone);
      case 'game_tap_match':
        return TapMatchGameWidget(content: activity.content, onDone: _markDone);
      case 'game_memory':
        return MemoryFlipGameWidget(content: activity.content, onDone: _markDone);
      case 'game_sequence':
        return SequenceGameWidget(content: activity.content, onDone: _markDone);
      case 'guided_steps':
        return GuidedStepsWidget(content: activity.content, onDone: _markDone);
      default:
        return _LegacyFallback(activity: activity, hasAudio: _hasAudio, onDone: _markDone);
    }
  }

  @override
  Widget build(BuildContext context) {
    final activity = widget.activity;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F4EF),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: _buildContent(),
                  ),
                ],
              ),
              Positioned(
                top: 12,
                right: 12,
                child: _ExitButton(onExit: _exitActivity),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExitButton extends StatelessWidget {
  const _ExitButton({required this.onExit});
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onExit,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.18),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.close, color: Colors.white, size: 20),
      ),
    );
  }
}

class _ActivityIcon extends StatelessWidget {
  const _ActivityIcon({required this.type});
  final String type;

  @override
  Widget build(BuildContext context) {
    const icons = {
      'story': Icons.auto_stories,
      'game': Icons.sports_esports,
      'music': Icons.music_note,
      'movement': Icons.directions_walk,
      'video': Icons.play_circle,
      'creative': Icons.brush,
    };
    const colors = {
      'story': Color(0xFF7BB8D4),
      'game': Color(0xFF8DC48A),
      'music': Color(0xFFD4A96A),
      'movement': Color(0xFFB09FD4),
      'video': Color(0xFFD48A8A),
      'creative': Color(0xFFD4C56A),
    };

    final icon = icons[type] ?? Icons.star;
    final color = colors[type] ?? AppColors.seedGreen;

    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        shape: BoxShape.circle,
        border: Border.all(color: color.withOpacity(0.3), width: 2),
      ),
      child: Icon(icon, size: 60, color: color),
    );
  }
}

class _LegacyFallback extends StatelessWidget {
  const _LegacyFallback({this.activity, this.hasAudio = false, this.onDone});
  final ChildActivity? activity;
  final bool hasAudio;
  final VoidCallback? onDone;

  @override
  Widget build(BuildContext context) {
    if (activity == null) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _ActivityIcon(type: activity!.type),
          const SizedBox(height: 24),
          Text(
            activity!.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (!hasAudio && activity!.learningObjectives.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              activity!.learningObjectives.first,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
          const SizedBox(height: 48),
          if (hasAudio)
            AudioPlayerWidget(
              audioUrl: activity!.mediaRefs.first,
              onComplete: onDone!,
            )
          else
            SizedBox(
              width: double.infinity,
              height: 64,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.seedGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: onDone,
                child: const Text(
                  'All done!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
