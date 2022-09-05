import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:bbk_final_ana/audio/controller/recorded_audio_handler.dart';
import 'package:bbk_final_ana/audio/enums/recorder_enum.dart';
import 'package:bbk_final_ana/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart'
    as flutter_sound;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

import '../notifiers/audio_metadata_notifier.dart';
import '../notifiers/recoder_progess_notifier.dart';
import '../notifiers/record_button_notifier.dart';
import '../notifiers/recorder_progress_state.dart';

final recorderControllerProvider = Provider((ref) {
  final recordedAudioHandler = ref.watch(recordedAudioHandlerProvider);
  return RecorderController(
    ref: ref,
    auth: FirebaseAuth.instance,
    recordedAudioHandler: recordedAudioHandler,
  );
});

class RecorderController {
  RecorderController({
    required this.ref,
    required this.auth,
    required this.recordedAudioHandler,
  });
  final ProviderRef ref;
  final FirebaseAuth auth;
  final RecordedAudioHandler recordedAudioHandler;
  final recordButtonNotifier = RecordButtonNotifier();
  final progressNotifier = RecorderProgressNotifier();
  final currentAudioMetadataNotifier = CurrentAudioMetadataNotifier();
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;
  StreamSubscription? _recorderSubscription;
  StreamSubscription? _playerSubscription;

  void initRecorder(BuildContext context) async {
    _recorder = FlutterSoundRecorder();
    _player = FlutterSoundPlayer();
    try {
      await _openRecorder();
      await _openPlayer();
      recordButtonNotifier.value = RecorderStateEnum.stopped;
      _listenToRecorderProgress();
      _listenToPlayerProgress();
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Future<void> _openRecorder() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted.');
    }
    await _recorder!.openRecorder();

    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth |
              AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
          AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));
    await _recorder!.setSubscriptionDuration(const Duration(milliseconds: 10));
  }

  Future<void> _openPlayer() async {
    await _player!.openPlayer();
    await _player!.setSubscriptionDuration(const Duration(milliseconds: 10));
  }

  void _listenToRecorderProgress() {
    _recorderSubscription = _recorder!.onProgress!.listen((record) {
      progressNotifier.value =
          RecorderProgressState(maxDuration: record.duration);
    });
  }

  void _cancelRecorderSubscription() {
    if (_recorderSubscription != null) {
      _recorderSubscription!.cancel();
      _recorderSubscription = null;
    }
  }

  void _cancelPlayerSubscriptions() {
    if (_playerSubscription != null) {
      _playerSubscription!.cancel();
      _playerSubscription = null;
    }
  }

  void _listenToPlayerProgress() {
    _playerSubscription = _player!.onProgress!.listen((record) {
      progressNotifier.value =
          RecorderProgressState(maxDuration: record.position);
    });
  }

  void disposeRecorder() {
    _cancelRecorderSubscription();
    _recorder!.closeRecorder();
    _recorder = null;
    _cancelPlayerSubscriptions();
    _player!.closePlayer();
    _player = null;
    recordButtonNotifier.value = RecorderStateEnum.notInitialized;
  }

  void record() async {
    final documentDirectory = await getApplicationDocumentsDirectory();
    final audioId = const Uuid().v1();
    final path = '${documentDirectory.path}/$audioId.aac';
    const audioSource = flutter_sound.AudioSource.microphone;
    const codec = Codec.aacADTS;
    recordedAudioHandler.clear();
    recordedAudioHandler.updateAudioMetadata(
      id: audioId,
      url: path,
      senderId: auth.currentUser!.uid,
    );
    recordButtonNotifier.value = RecorderStateEnum.recording;
    await _recorder!.startRecorder(
      toFile: path,
      codec: codec,
      audioSource: audioSource,
      bitRate: 8000,
      numChannels: 1,
      sampleRate: 8000,
    );
  }

  void stopRecorder() async {
    // This delay is to ensure the last second is captured by the recorder.
    await Future.delayed(const Duration(seconds: 1));
    await _recorder!.stopRecorder();
    recordButtonNotifier.value = RecorderStateEnum.recorded;
  }

  void restart() {
    _recorder!.updateRecorderProgress(duration: 0);
    _player!.updateProgress(duration: 0);
    recordButtonNotifier.value = RecorderStateEnum.stopped;
  }

  void playRecord() async {
    if (recordButtonNotifier.value != RecorderStateEnum.recorded) return;
    recordButtonNotifier.value = RecorderStateEnum.playingPlayback;
    final url = recordedAudioHandler.audioMetadata.url;
    await _player!.startPlayer(
        fromURI: url,
        whenFinished: () {
          recordButtonNotifier.value = RecorderStateEnum.recorded;
        });
  }

  void pausePlayback() async {
    if (recordButtonNotifier.value != RecorderStateEnum.playingPlayback) return;
    recordButtonNotifier.value = RecorderStateEnum.recorded;
    await _player!.pausePlayer();
  }
}
