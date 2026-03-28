import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import '../core/app_config.dart';
import '../core/app_styles.dart';

/// Kompakter Audio-Clip-Player (z.B. Begrüßung neben Avatar).
///
/// Nutzt eine **eigene** [AudioPlayer]-Instanz, damit laufende
/// Meditationen im Haupt-AudioService nicht unterbrochen werden.
class AvatarAudioClip extends StatefulWidget {
  final String? appwriteId;
  final String label;
  final String? durationHint;

  const AvatarAudioClip({
    super.key,
    required this.appwriteId,
    required this.label,
    this.durationHint,
  });

  @override
  State<AvatarAudioClip> createState() => _AvatarAudioClipState();
}

class _AvatarAudioClipState extends State<AvatarAudioClip> {
  AudioPlayer? _player;
  StreamSubscription<PlayerState>? _stateSub;
  StreamSubscription<Duration>? _positionSub;

  bool _isPlaying = false;
  bool _isLoading = false;
  bool _hasError = false;
  double _progress = 0.0;

  bool get _isAvailable =>
      widget.appwriteId != null && widget.appwriteId!.isNotEmpty;

  @override
  void dispose() {
    _stateSub?.cancel();
    _positionSub?.cancel();
    _player?.dispose();
    super.dispose();
  }

  String _buildUrl(String fileId) {
    return '${AppConfig.appwriteEndpoint}/storage/buckets/'
        '${AppConfig.audiosBucketId}/files/$fileId/view'
        '?project=${AppConfig.appwriteProjectId}';
  }

  /// Nach Ende der Wiedergabe (v. a. Web) muss oft auf 0 gesprungen werden,
  /// sonst reagiert [play] nicht erneut.
  Future<void> _ensureAtStartIfFinished() async {
    final p = _player!;
    if (p.processingState == ProcessingState.completed) {
      await p.seek(Duration.zero);
      return;
    }
    final d = p.duration;
    if (d != null && d > Duration.zero) {
      if (p.position >= d - const Duration(milliseconds: 250)) {
        await p.seek(Duration.zero);
      }
    }
  }

  Future<void> _toggle() async {
    if (!_isAvailable) return;

    HapticFeedback.lightImpact();

    if (_player == null) {
      await _initAndPlay();
      return;
    }

    if (_isPlaying) {
      await _player!.pause();
    } else {
      try {
        await _ensureAtStartIfFinished();
        await _player!.play();
      } catch (e) {
        if (kDebugMode) debugPrint('AvatarAudioClip: Wiederholen: $e');
        if (mounted) {
          setState(() {
            _hasError = true;
            _isLoading = false;
          });
        }
      }
    }
  }

  Future<void> _initAndPlay() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      _player = AudioPlayer();

      _stateSub = _player!.playerStateStream.listen((state) {
        if (!mounted) return;
        final playing = state.playing;
        final done = state.processingState == ProcessingState.completed;

        setState(() {
          _isPlaying = playing && !done;
          if (done) {
            // Ende: kein „hängender“ Ladezustand; Fortschritt zurücksetzen.
            _isLoading = false;
            _progress = 0.0;
          } else {
            _isLoading = state.processingState == ProcessingState.loading ||
                state.processingState == ProcessingState.buffering;
          }
        });
      });

      _positionSub = _player!.positionStream.listen((pos) {
        if (!mounted) return;
        final total = _player?.duration;
        if (total != null && total.inMilliseconds > 0) {
          setState(() {
            _progress = (pos.inMilliseconds / total.inMilliseconds).clamp(0, 1);
          });
        }
      });

      final url = _buildUrl(widget.appwriteId!);
      await _player!.setAudioSource(
        AudioSource.uri(Uri.parse(url), tag: widget.label),
        preload: true,
      );
      await _player!.play();
    } catch (e) {
      if (kDebugMode) debugPrint('AvatarAudioClip: Fehler: $e');
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAvailable) {
      return _buildPendingChip();
    }

    return GestureDetector(
      onTap: _toggle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppStyles.primaryOrange.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppStyles.primaryOrange.withValues(alpha: 0.18),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildPlayIcon(),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    widget.label,
                    style: AppStyles.bodyStyle.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppStyles.textDark,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (widget.durationHint != null && !_isPlaying) ...[
                  const SizedBox(width: 8),
                  Text(
                    widget.durationHint!,
                    style: AppStyles.smallTextStyle.copyWith(
                      fontSize: 12,
                      color: AppStyles.textMuted,
                    ),
                  ),
                ],
              ],
            ),
            if (_isPlaying || _progress > 0) ...[
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: _progress,
                  minHeight: 3,
                  backgroundColor:
                      AppStyles.primaryOrange.withValues(alpha: 0.12),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppStyles.primaryOrange.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPlayIcon() {
    if (_isLoading) {
      return SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppStyles.primaryOrange,
        ),
      );
    }
    if (_hasError) {
      return Icon(
        Icons.error_outline,
        size: 22,
        color: AppStyles.errorRed.withValues(alpha: 0.7),
      );
    }
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: AppStyles.primaryOrange,
        shape: BoxShape.circle,
      ),
      child: Icon(
        _isPlaying ? Icons.pause : Icons.play_arrow,
        size: 16,
        color: Colors.white,
      ),
    );
  }

  Widget _buildPendingChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppStyles.textMuted.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppStyles.textMuted.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.volume_up_outlined,
            size: 18,
            color: AppStyles.textMuted.withValues(alpha: 0.4),
          ),
          const SizedBox(width: 8),
          Text(
            'Audio folgt',
            style: AppStyles.smallTextStyle.copyWith(
              fontSize: 12,
              color: AppStyles.textMuted.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
