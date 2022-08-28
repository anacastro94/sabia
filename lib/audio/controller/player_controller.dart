import 'package:audio_service/audio_service.dart';
import 'package:bbk_final_ana/audio/enums/repeat_button_enum.dart';
import 'package:bbk_final_ana/audio/notifiers/play_button_notifier.dart';
import 'package:bbk_final_ana/audio/notifiers/progress_notifier.dart';
import 'package:bbk_final_ana/audio/notifiers/repeat_button_notifier.dart';
import 'package:bbk_final_ana/models/audio_metadata.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../common/constants/constants.dart';
import '../enums/play_button_enum.dart';
import '../notifiers/player_progress_state.dart';
import '../repository/playlist_repository.dart';
import 'audio_handler.dart';

final audioPlayerControllerProvider =
    Provider((ref) => AudioPlayerController(ref: ref));

class AudioPlayerController {
  final ProviderRef ref;
  final playButtonNotifier = PlayButtonNotifier();
  final progressNotifier = ProgressNotifier();
  final repeatButtonNotifier = RepeatButtonNotifier();
  final currentAudioMetadataNotifier = ValueNotifier<AudioMetadata>(
      AudioMetadata(author: '', title: '', artUrl: kLogoUrl, id: '', url: ''));
  final playListNotifier = ValueNotifier<List<AudioMetadata>>([]);
  final isFirstAudioNotifier = ValueNotifier<bool>(true);
  final isLastAudioNotifier = ValueNotifier<bool>(true);
  final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);
  final playerSpeedNotifier = ValueNotifier<double>(1.0);
  late AudioHandler _audioHandler;
  late ConcatenatingAudioSource _playlist;

  AudioPlayerController({required this.ref}) {
    _init();
  }
  void _init() async {
    _audioHandler = ref.read(audioHandlerProvider);
    await _loadPlaylist();
    _listenToChangesInPlaylist();
    _listenToPlaybackState();
    _listenToCurrentPosition();
    _listenToBufferedPosition();
    _listenToTotalDuration();
    _listenToChangesInAudio();
  }

  Future<void> _loadPlaylist() async {
    final playlistRepository = ref.read(playListRepositoryProvider);
    final playList = await playlistRepository.fetchInitialPlaylist();
    final mediaItems = playList
        .map((audio) => MediaItem(
              id: audio['id'] ?? ' ',
              title: audio['title'] ?? ' ',
              artist: audio['author'] ?? ' ',
              artUri: Uri.parse(audio['artUrl'] ?? kLogoUrl),
              extras: {'url': audio['url']},
            ))
        .toList();
    _audioHandler.addQueueItems(mediaItems);
  }

  ///NEW
  void _listenToChangesInPlaylist() {
    _audioHandler.queue.listen((playlist) {
      if (playlist.isEmpty) {
        playListNotifier.value = [];
        currentAudioMetadataNotifier.value = AudioMetadata(
          author: '',
          title: '',
          artUrl: kLogoUrl,
          id: '',
          url: '',
        );
      } else {
        final newList = playlist
            .map((item) => AudioMetadata(
                  author: item.artist ?? '',
                  title: item.title ?? '',
                  artUrl: item.artUri?.path ?? '',
                  id: item.id,
                  url: item.extras?['url'] ?? '',
                ))
            .toList();
        playListNotifier.value = newList;
      }
      _updateSkipButtons();
    });
  }

  ///NEW
  void _listenToPlaybackState() {
    _audioHandler.playbackState.listen((playbackState) {
      final isPlaying = playbackState.playing;
      final processingState = playbackState.processingState;
      if (processingState == AudioProcessingState.loading ||
          processingState == AudioProcessingState.buffering) {
        playButtonNotifier.value = PlayerButtonState.loading;
      } else if (!isPlaying) {
        playButtonNotifier.value = PlayerButtonState.paused;
      } else if (processingState != AudioProcessingState.completed) {
        playButtonNotifier.value = PlayerButtonState.playing;
      } else {
        _audioHandler.seek(Duration.zero);
        _audioHandler.pause();
      }
    });
  }

  ///NEW
  void _listenToCurrentPosition() {
    AudioService.position.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = PlayerProgressState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });
  }

  ///NEW
  void _listenToBufferedPosition() {
    _audioHandler.playbackState.listen((playbackState) {
      final oldState = progressNotifier.value;
      progressNotifier.value = PlayerProgressState(
        current: oldState.current,
        buffered: playbackState.bufferedPosition,
        total: oldState.total,
      );
    });
  }

  ///NEW
  void _listenToTotalDuration() {
    _audioHandler.mediaItem.listen((mediaItem) {
      final oldState = progressNotifier.value;
      progressNotifier.value = PlayerProgressState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: mediaItem?.duration ?? Duration.zero,
      );
    });
  }

  ///NEW
  void _updateSkipButtons() {
    final mediaItem = _audioHandler.mediaItem.value;
    final playlist = _audioHandler.queue.value;
    if (playlist.length < 2 || mediaItem == null) {
      isFirstAudioNotifier.value = true;
      isLastAudioNotifier.value = true;
    } else {
      isFirstAudioNotifier.value = playlist.first == mediaItem;
      isLastAudioNotifier.value = playlist.last == mediaItem;
    }
  }

  ///NEW
  void _listenToChangesInAudio() {
    _audioHandler.mediaItem.listen((mediaItem) {
      currentAudioMetadataNotifier.value = AudioMetadata(
        id: mediaItem?.id ?? '',
        author: mediaItem?.artist ?? '',
        title: mediaItem?.title ?? '',
        artUrl: mediaItem?.artUri?.toString() ?? '',
        url: mediaItem?.extras!['url'] ?? '',
      );
      _updateSkipButtons();
    });
  }

  void play() => _audioHandler.play();

  void pause() => _audioHandler.pause();

  void seek(Duration position) => _audioHandler.seek(position);

  void dispose() {
    _audioHandler.customAction('dispose');
  }

  void stop() {
    _audioHandler.stop();
  }

  void onRepeatButtonPressed() {
    repeatButtonNotifier.nextState();
    switch (repeatButtonNotifier.value) {
      case RepeatState.off:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
        break;
      case RepeatState.repeatSong:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
        break;
      case RepeatState.repeatPlaylist:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
        break;
    }
  }

  void onPreviousAudioButtonPressed() {
    _audioHandler.skipToPrevious();
  }

  void onNextAudioButtonPressed() {
    _audioHandler.skipToNext();
  }

  void onShuffleButtonPressed() async {
    final enable = !isShuffleModeEnabledNotifier.value;
    isShuffleModeEnabledNotifier.value = enable;
    if (enable) {
      _audioHandler.setShuffleMode(AudioServiceShuffleMode.all);
    } else {
      _audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
    }
  }

  void addAudioToPlaylist() async {
    final playlistRepository = ref.read(playListRepositoryProvider);
    final audio = await playlistRepository
        .fetchAnotherAudio(); //TODO: Add an specific audio to playlist
    final mediaItem = MediaItem(
      id: audio['id'] ?? ' ',
      title: audio['title'] ?? ' ',
      artist: audio['author'] ?? ' ',
      artUri: Uri.parse(audio['artUrl'] ?? kLogoUrl),
      extras: {'url': audio['url']},
    );
    _audioHandler.addQueueItem(mediaItem);
  }

  void removeAudioFromPlaylist() {
    // Removing the final song
    //TODO: Update to remove a selected song
    final lastIndex = _audioHandler.queue.value.length - 1;
    if (lastIndex < 0) return;
    _audioHandler.removeQueueItemAt(lastIndex);
  }

  void skipToQueueItem(int index) {
    _audioHandler.skipToQueueItem(index);
  }

  void setPlayerSpeed(double speed) async {
    await _audioHandler.setSpeed(speed);
    playerSpeedNotifier.value = speed;
  }
}
