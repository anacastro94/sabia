import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../enums/play_button_enum.dart';
import '../provider/player_progress_state.dart';

class AudioPlayerController {
  AudioPlayerController() {
    _init();
  }

  static const url =
      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3'; //TODO: Delete after testing
  late AudioPlayer _audioPlayer;

  final progressNotifier =
      ValueNotifier<PlayerProgressState>(PlayerProgressState(
    current: Duration.zero,
    buffered: Duration.zero,
    total: Duration.zero,
  ));

  final buttonNotifier =
      ValueNotifier<PlayerButtonState>(PlayerButtonState.paused);

  void _init() async {
    _audioPlayer = AudioPlayer();
    await _audioPlayer.setUrl(url);

    _audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        buttonNotifier.value = PlayerButtonState.loading;
      } else if (!isPlaying) {
        buttonNotifier.value = PlayerButtonState.paused;
      } else if (processingState != ProcessingState.completed) {
        buttonNotifier.value = PlayerButtonState.playing;
      } else {
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.pause();
      }
    });

    _audioPlayer.positionStream.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = PlayerProgressState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });

    _audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      final oldState = progressNotifier.value;
      progressNotifier.value = PlayerProgressState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });

    _audioPlayer.durationStream.listen((totalDuration) {
      final oldState = progressNotifier.value;
      progressNotifier.value = PlayerProgressState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );
    });
  }

  void play() {
    _audioPlayer.play();
  }

  void pause() {
    _audioPlayer.pause();
  }

  void dispose() {
    _audioPlayer.dispose();
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
  }
}
