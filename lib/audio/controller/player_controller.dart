import 'package:audio_service/audio_service.dart';
import 'package:bbk_final_ana/audio/enums/repeat_button_enum.dart';
import 'package:bbk_final_ana/audio/notifiers/play_button_notifier.dart';
import 'package:bbk_final_ana/audio/notifiers/player_progress_notifier.dart';
import 'package:bbk_final_ana/audio/notifiers/repeat_button_notifier.dart';
import 'package:bbk_final_ana/models/audio_metadata.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/constants/constants.dart';
import '../enums/play_button_enum.dart';
import '../notifiers/audio_metadata_notifier.dart';
import '../notifiers/player_progress_state.dart';
import '../repository/playlist_repository.dart';
import 'audio_handler.dart';

final audioPlayerControllerProvider = Provider((ref) {
  final playlistRepository = ref.watch(playListRepositoryProvider);
  return AudioPlayerController(
      ref: ref, playlistRepository: playlistRepository);
});

class AudioPlayerController {
  final ProviderRef ref;
  final PlaylistRepository playlistRepository;
  final playButtonNotifier = PlayButtonNotifier();
  final progressNotifier = PlayerProgressNotifier();
  final repeatButtonNotifier = RepeatButtonNotifier();
  final currentAudioMetadataNotifier = CurrentAudioMetadataNotifier();
  final playListNotifier = ValueNotifier<List<AudioMetadata>>([]);
  final isFirstAudioNotifier = ValueNotifier<bool>(true);
  final isLastAudioNotifier = ValueNotifier<bool>(true);
  final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);
  final playerSpeedNotifier = ValueNotifier<double>(1.0);
  late AudioHandler _audioHandler;

  AudioPlayerController({required this.ref, required this.playlistRepository}) {
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
    final playlist = await playlistRepository.fetchInitialPlaylist();
    final mediaItems = playlist
        .map((audio) => MediaItem(
              id: audio.id,
              title: audio.title,
              artist: audio.author,
              artUri: Uri.parse(audio.artUrl),
              extras: {
                'url': audio.url,
                'isFavorite': audio.isFavorite,
                'isSeen': audio.isSeen,
                'senderId': audio.senderId,
                'timeSent': audio.timeSent.millisecondsSinceEpoch,
              },
            ))
        .toList();
    _audioHandler.addQueueItems(mediaItems);
  }

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
          senderId: '',
          timeSent: DateTime.now(),
        );
      } else {
        final newList = playlist.map((mediaItem) {
          return AudioMetadata(
            author: mediaItem.artist ?? '',
            title: mediaItem.title ?? '',
            artUrl: mediaItem.artUri?.path ?? '',
            id: mediaItem.id,
            url: mediaItem.extras?['url'] ?? '',
            isFavorite: mediaItem.extras?['isFavorite'],
            senderId: mediaItem.extras?['senderId'] ?? '',
            timeSent: DateTime.fromMillisecondsSinceEpoch(
                mediaItem.extras!['timeSent']),
          );
        }).toList();
        playListNotifier.value = newList;
      }
      _updateSkipButtons();
    });
  }

  void _listenToPlaybackState() {
    _audioHandler.playbackState.listen((playbackState) {
      final isPlaying = playbackState.playing;
      final processingState = playbackState.processingState;
      if (processingState == AudioProcessingState.loading ||
          processingState == AudioProcessingState.buffering) {
        playButtonNotifier.value = PlayerStateEnum.loading;
      } else if (!isPlaying) {
        playButtonNotifier.value = PlayerStateEnum.paused;
      } else if (processingState != AudioProcessingState.completed) {
        playButtonNotifier.value = PlayerStateEnum.playing;
      } else {
        _audioHandler.seek(Duration.zero);
        _audioHandler.pause();
      }
    });
  }

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

  void _listenToChangesInAudio() {
    _audioHandler.mediaItem.listen((mediaItem) {
      currentAudioMetadataNotifier.value = AudioMetadata(
        id: mediaItem?.id ?? '',
        author: mediaItem?.artist ?? '',
        title: mediaItem?.title ?? '',
        artUrl: mediaItem?.artUri?.toString() ?? kLogoUrl,
        url: mediaItem?.extras!['url'] ?? '',
        isFavorite: mediaItem?.extras?['isFavorite'] ?? false,
        isSeen: mediaItem?.extras?['isSeen'] ?? false,
        senderId: mediaItem?.extras?['senderId'] ?? '',
        timeSent: DateTime.fromMillisecondsSinceEpoch(
            mediaItem?.extras?['timeSent'] ?? 0),
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

  ///Not working
  void addAudioToPlaylist() async {
    final playlistRepository = ref.read(playListRepositoryProvider);
    final audio = await playlistRepository.fetchAnotherAudio();
    final mediaItem = MediaItem(
      id: audio.id,
      title: audio.title,
      artist: audio.author,
      artUri: Uri.parse(audio.artUrl),
      extras: {
        'url': audio.url,
        'isFavorite': audio.isFavorite,
        'isSeen': audio.isSeen,
        'senderId': audio.senderId,
        'timeSent': audio.timeSent.millisecondsSinceEpoch,
      },
    );
    _audioHandler.addQueueItem(mediaItem);
  }

  ///Not being used
  void removeAudioFromPlaylist(int index) {
    final lastIndex = _audioHandler.queue.value.length - 1;
    if (lastIndex < 0) return;
    _audioHandler.removeQueueItemAt(index);
  }

  void skipToQueueItem(int index) {
    _audioHandler.skipToQueueItem(index);
  }

  void setPlayerSpeed(double speed) async {
    await _audioHandler.setSpeed(speed);
    playerSpeedNotifier.value = speed;
  }

  void toggleAudioMessageFavorite(
    BuildContext context,
    String senderId,
    String messageId,
  ) {
    // Update database
    playlistRepository.toggleAudioMessageFavorite(
        context: context, senderId: senderId, messageId: messageId);
    final currentAudioMetadata = currentAudioMetadataNotifier.value;
    final isFavorite = currentAudioMetadata.isFavorite;
    // Update state
    currentAudioMetadataNotifier.value =
        currentAudioMetadata.copyWith(isFavorite: !isFavorite);
  }

  void setAudioMessageSeen({
    required BuildContext context,
    required String senderId,
    required String messageId,
  }) {
    playlistRepository.setAudioMessageSeen(
        context: context, senderId: senderId, messageId: messageId);
  }

  Stream<List<AudioMetadata>> getAudioMessagesStream() {
    return playlistRepository.getAudioMessagesStream();
  }

  void playSelectedAudio(AudioMetadata audio) async {
    final index = _getItemIndex(audio.id);
    _audioHandler.skipToQueueItem(index);
  }

  int _getItemIndex(String id) {
    final playlist = _audioHandler.queue.value;
    final mediaItem = playlist.where((element) => element.id == id).first;
    playlist.indexOf(mediaItem);
    return playlist.indexOf(mediaItem);
  }
}
