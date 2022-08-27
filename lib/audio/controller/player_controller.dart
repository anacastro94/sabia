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

final audioPlayerControllerProvider =
    Provider((ref) => AudioPlayerController());

class AudioPlayerController {
  final playButtonNotifier = PlayButtonNotifier();
  final progressNotifier = ProgressNotifier();
  final repeatButtonNotifier = RepeatButtonNotifier();
  final currentAudioMetadataNotifier = ValueNotifier<AudioMetadata>(
      AudioMetadata(author: '', title: '', artwork: kLogoUrl));
  final playListNotifier = ValueNotifier<List<String>>([]);
  final isFirstAudioNotifier = ValueNotifier<bool>(true);
  final isLastAudioNotifier = ValueNotifier<bool>(true);
  final isShuffleModeEnabledNotifier = ValueNotifier<bool>(false);
  late AudioPlayer _audioPlayer;
  late ConcatenatingAudioSource _playlist;

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

  void _setInitialPlaylist() async {
    // TODO: Get from database
    const audioPrefix = 'https://www.soundhelix.com/examples/mp3';
    final audio1 = Uri.parse('$audioPrefix/SoundHelix-Song-1.mp3');
    final audio2 = Uri.parse('$audioPrefix/SoundHelix-Song-2.mp3');
    final audio3 = Uri.parse('$audioPrefix/SoundHelix-Song-3.mp3');
    const artworkPrefix =
        'https://firebasestorage.googleapis.com/v0/b/bbk-final-project.appspot.com/o/images';
    List<String> artworkUrls = [
      '$artworkPrefix%2Fc3.png?alt=media&token=56c0c368-36d8-4054-9455-dc9ba82dc8f1',
      '$artworkPrefix%2Fc1.png?alt=media&token=ec4c0419-59fb-40f2-b934-46c51fd37a90',
      '$artworkPrefix%2Fc2.png?alt=media&token=300a5735-29cf-44e3-a84d-ee1e77446575',
    ];

    _playlist = ConcatenatingAudioSource(children: [
      AudioSource.uri(audio1,
          tag: AudioMetadata(
            author: 'Estelle Darcy',
            title: 'Feeling Alone in the Desert',
            artwork: artworkUrls[0],
          )),
      AudioSource.uri(audio2,
          tag: AudioMetadata(
            author: 'Estelle Darcy',
            title: 'Old Boat',
            artwork: artworkUrls[1],
          )),
      AudioSource.uri(audio3,
          tag: AudioMetadata(
            author: 'Claudia Wilson',
            title: 'Our Last Summer',
            artwork: artworkUrls[2],
          )),
    ]);
    await _audioPlayer.setAudioSource(_playlist);
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

  void _listenForChangesInSequenceState() {
    _audioPlayer.sequenceStateStream.listen((sequenceState) {
      if (sequenceState == null) return;
      // Updates current audio title, author and artwork
      final currentItem = sequenceState.currentSource;
      final metadata = currentItem!.tag as AudioMetadata;
      currentAudioMetadataNotifier.value = metadata;
      // Updates playlist
      final playlist = sequenceState.effectiveSequence;
      final titles = playlist
          .map((item) => item.tag as AudioMetadata)
          .map((audioMetadata) => audioMetadata.title)
          .toList();
      playListNotifier.value = titles;
      //  Tells the UI to update based on the current value of shuffle mode
      isShuffleModeEnabledNotifier.value = sequenceState.shuffleModeEnabled;
      // Previous and next buttons
      // If you are in the first audio, you cannot go to the previous.
      // If you are in the last audio, you cannot go to the next.
      if (playlist.isEmpty || currentItem == null) {
        isFirstAudioNotifier.value = true;
        isLastAudioNotifier.value = true;
      } else {
        isFirstAudioNotifier.value = playlist.first == currentItem;
        isLastAudioNotifier.value = playlist.last == currentItem;
      }
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

  void onRepeatButtonPressed() {
    repeatButtonNotifier.nextState();
    switch (repeatButtonNotifier.value) {
      case RepeatState.off:
        _audioPlayer.setLoopMode(LoopMode.off);
        break;
      case RepeatState.repeatSong:
        _audioPlayer.setLoopMode(LoopMode.one);
        break;
      case RepeatState.repeatPlaylist:
        _audioPlayer.setLoopMode(LoopMode.all);
        break;
    }
  }

  void onPreviousAudioButtonPressed() {
    _audioPlayer.seekToPrevious();
  }

  void onNextAudioButtonPressed() {
    _audioPlayer.seekToNext();
  }

  void onShuffleButtonPressed() async {
    final isEnabled = !_audioPlayer.shuffleModeEnabled;
    if (isEnabled) {
      await _audioPlayer.shuffle();
    }
    await _audioPlayer.setShuffleModeEnabled(isEnabled);
  }

  void addAudioToPlaylist() {
    final songNumber = _playlist.length + 1;
    //TODO: Get list from database and limit to the size of the list
    const prefix = 'https://www.soundhelix.com/examples/mp3';
    final song = Uri.parse('$prefix/SoundHelix-Song-$songNumber.mp3');
    _playlist.add(AudioSource.uri(song,
        tag: AudioMetadata(
          author: 'Author $songNumber',
          title: 'Song $songNumber',
          artwork: kLogoUrl,
        )));
  }

  void removeAudioFromPlaylist() {
    // Removing the final song
    //TODO: Update to remove a selected song
    final index = _playlist.length - 1;
    if (index < 0) return;
    _playlist.removeAt(index);
  }
}
