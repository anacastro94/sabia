import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../enums/play_button_enum.dart';
import '../provider/player_buttton_state_provider.dart';
import '../provider/progress_bar_state_provider.dart';

final audioPlayerControllerProvider = Provider((ref) => AudioPlayerController(
      ref: ref,
      playerButtonStateProvider: playerButtonStateProvider,
      playerProgressStateProvider: playerProgressStateProvider,
    ));

class AudioPlayerController {
  AudioPlayerController({
    required this.ref,
    required this.playerButtonStateProvider,
    required this.playerProgressStateProvider,
  }) {
    _init();
  }
  final ProviderRef ref;
  final StateProvider<PlayerButtonState> playerButtonStateProvider;
  final StateProvider<PlayerProgressState> playerProgressStateProvider;

  static const url =
      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3'; //TODO: Delete after testing
  late AudioPlayer _audioPlayer;

  void _init() async {
    _audioPlayer = AudioPlayer();
    await _audioPlayer.setUrl(url);

    _audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        ref
            .read(playerButtonStateProvider.state)
            .update((state) => PlayerButtonState.loading);
      } else if (!isPlaying) {
        ref
            .read(playerButtonStateProvider.state)
            .update((state) => PlayerButtonState.paused);
      } else {
        ref
            .read(playerButtonStateProvider.state)
            .update((state) => PlayerButtonState.playing);
      }
    });

    _audioPlayer.positionStream.listen((position) {
      final oldState = ref.read(playerProgressStateProvider);
      final playerProgressState = PlayerProgressState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
      ref
          .read(playerProgressStateProvider.notifier)
          .update((state) => playerProgressState);
      // print('Current position: ${playerProgressState.current}'); //TODO DEL
    });

    _audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      final oldState = ref.read(playerProgressStateProvider);
      ref
          .read(playerProgressStateProvider.notifier)
          .update((state) => PlayerProgressState(
                current: oldState.current,
                buffered: bufferedPosition,
                total: oldState.total,
              ));
      // print(
      //     'Buffered position: ${ref.read(playerProgressStateProvider).buffered}');//TODO DEL
    });

    _audioPlayer.durationStream.listen((totalDuration) {
      final oldState = ref.read(playerProgressStateProvider);
      ref
          .read(playerProgressStateProvider.notifier)
          .update((state) => PlayerProgressState(
                current: oldState.current,
                buffered: oldState.buffered,
                total: totalDuration ?? Duration.zero,
              ));
      // print('Total duration: ${ref.read(playerProgressStateProvider).total}');//TODO DEL
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
}
