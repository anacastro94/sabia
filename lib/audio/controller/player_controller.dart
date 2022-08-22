import 'package:bbk_final_ana/audio/notifier/play_button_notifier.dart';
import 'package:bbk_final_ana/audio/notifier/progress_notifier.dart';
import 'package:bbk_final_ana/audio/notifier/repeat_button_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../enums/play_button_enum.dart';
import '../notifier/player_progress_state.dart';

final audioPlayerControllerProvider =
    Provider((ref) => AudioPlayerController());

class AudioPlayerController {
  final playButtonNotifier = PlayButtonNotifier();
  final progressNotifier = ProgressNotifier();
  final repeatButtonNotifier = RepeatButtonNotifier();
  final currentAudioTitleNotifier = ValueNotifier<String>('');
  final playListNotifier = ValueNotifier<List<String>>([]);
  final isFirstAudioNotifier = ValueNotifier<bool>(true);
  final isLastAudioNotifier = ValueNotifier<bool>(true);
  final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);
  late AudioPlayer _audioPlayer;

  AudioPlayerController() {
    _init();
  }
  void _init() async {
    _audioPlayer = AudioPlayer();
    _setInitialPlaylist();
    _listenForChangesInPlayerState();
    _listenForChangesInPlayerPosition();
    _listenForChangesInBufferedPosition();
    _listenForChangesInTotalDuration();
    _listenForChangesInSequenceState();
  }

  //TODO: Set playlist
  void _setInitialPlaylist() async {
    const url =
        'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3'; //TODO: Delete after testing
    await _audioPlayer.setUrl(url);
  }

  void _listenForChangesInPlayerState() {
    _audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        playButtonNotifier.value = PlayerButtonState.loading;
      } else if (!isPlaying) {
        playButtonNotifier.value = PlayerButtonState.paused;
      } else if (processingState != ProcessingState.completed) {
        playButtonNotifier.value = PlayerButtonState.playing;
      } else {
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.pause();
      }
    });
  }

  void _listenForChangesInPlayerPosition() {
    _audioPlayer.positionStream.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = PlayerProgressState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });
  }

  void _listenForChangesInBufferedPosition() {
    _audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      final oldState = progressNotifier.value;
      progressNotifier.value = PlayerProgressState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });
  }

  void _listenForChangesInTotalDuration() {
    _audioPlayer.durationStream.listen((totalDuration) {
      final oldState = progressNotifier.value;
      progressNotifier.value = PlayerProgressState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );
    });
  }

  void _listenForChangesInSequenceState() {}

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

  void onRepeatButtonPressed() {
    //TODO
  }
  void onPreviousAudioButtonPressed() {
    //TODO
  }
  void onNextAudioButtonPressed() {
    //TODO
  }
  void onShuffleButtonPressed() async {
    //TODO
  }
  void addSong() {
    //TODO
  }
  void removeSong() {
    //TODO
  }
}
