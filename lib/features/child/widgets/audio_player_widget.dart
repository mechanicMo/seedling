import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:seedling/core/theme/app_theme.dart';

class AudioPlayerWidget extends StatefulWidget {
  const AudioPlayerWidget({
    required this.audioUrl,
    required this.onComplete,
    super.key,
  });

  final String audioUrl;
  final VoidCallback onComplete;

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late final AudioPlayer _player;
  StreamSubscription<PlayerState>? _stateSub;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isPlaying = false;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _init();
  }

  Future<void> _init() async {
    try {
      _player.positionStream.listen((pos) {
        if (mounted) setState(() => _position = pos);
      });
      _player.durationStream.listen((dur) {
        if (dur != null && mounted) setState(() => _duration = dur);
      });
      _player.playerStateStream.listen((state) {
        if (!mounted) return;
        setState(() => _isPlaying = state.playing);
        if (state.processingState == ProcessingState.completed) {
          widget.onComplete();
        }
      });

      await _player.setUrl(widget.audioUrl);
      if (mounted) setState(() => _isLoading = false);
    } catch (_) {
      if (mounted) setState(() { _isLoading = false; _hasError = true; });
    }
  }

  @override
  void dispose() {
    _stateSub?.cancel();
    _player.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final remaining = _duration > _position ? _duration - _position : Duration.zero;
    final progress = _duration.inMilliseconds > 0
        ? (_position.inMilliseconds / _duration.inMilliseconds).clamp(0.0, 1.0)
        : 0.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_hasError)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'Audio unavailable',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          )
        else ...[
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _isLoading ? null : progress,
              backgroundColor: AppColors.seedGreen.withOpacity(0.15),
              color: AppColors.seedGreen,
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 8),
          // Time display
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                _isLoading
                    ? '--:--'
                    : '-${_formatDuration(remaining)}',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Play / Pause button
          GestureDetector(
            onTap: () {
              if (_isPlaying) {
                _player.pause();
              } else {
                _player.play();
              }
            },
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.seedGreen,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.seedGreen.withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(
                _isLoading
                    ? Icons.hourglass_empty
                    : (_isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
                color: Colors.white,
                size: 44,
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
        // Always-visible done button
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
            onPressed: widget.onComplete,
            child: const Text(
              'All done!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }
}
