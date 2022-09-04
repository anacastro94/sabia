import 'package:audio_session/audio_session.dart';
import 'package:bbk_final_ana/audio/enums/recorder_enum.dart';
import 'package:bbk_final_ana/auth/controller/auth_controller.dart';
import 'package:bbk_final_ana/models/audio_metadata.dart';
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

final recorderControllerProvider = Provider((ref) => RecorderController(
      ref: ref,
      auth: FirebaseAuth.instance,
    ));

class RecorderController {
  RecorderController({
    required this.ref,
    required this.auth,
  });
  final ProviderRef ref;
  final FirebaseAuth auth;
  final recordButtonNotifier = RecordButtonNotifier();
  final progressNotifier = RecorderProgressNotifier();
  final currentAudioMetadataNotifier = CurrentAudioMetadataNotifier();
  FlutterSoundRecorder? _recorder;

  void initRecorder(BuildContext context) async {
    _recorder = FlutterSoundRecorder();
    try {
      await _openRecorder();
      _listenToRecorderProgress();
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
    recordButtonNotifier.value = RecorderStateEnum.stopped;
  }

  void _listenToRecorderProgress() {
    _recorder!.onProgress!.listen((record) {
      progressNotifier.value =
          RecorderProgressState(maxDuration: record.duration);
    });
  }

  void disposeRecorder() {
    _recorder!.closeRecorder();
    _recorder = null;
    recordButtonNotifier.value = RecorderStateEnum.notInitialized;
  }

  void record() async {
    final documentDirectory = await getApplicationDocumentsDirectory();
    final audioId = const Uuid().v1();
    final path = '${documentDirectory.path}/$audioId.aac';
    const audioSource = flutter_sound.AudioSource.microphone;
    const codec = Codec.aacADTS;
    currentAudioMetadataNotifier.value = AudioMetadata(
      id: audioId,
      author: '',
      title: '',
      artUrl: '',
      url: '',
      senderId: auth.currentUser!.uid,
      timeSent: DateTime.now(),
    );
    recordButtonNotifier.value = RecorderStateEnum.recording;
    await _recorder!.startRecorder(
      toFile: path,
      codec: codec,
      audioSource: audioSource,
    );
  }

  void stop() async {
    final audioUrl = await _recorder!.stopRecorder();
    recordButtonNotifier.value = RecorderStateEnum.recorded;
    final audioMetadata = currentAudioMetadataNotifier.value;
    currentAudioMetadataNotifier.value = AudioMetadata(
      id: audioMetadata.id,
      author: audioMetadata.author,
      title: audioMetadata.title,
      artUrl: audioMetadata.artUrl,
      url: audioUrl ?? '',
      senderId: audioMetadata.senderId,
      timeSent: audioMetadata.timeSent,
    );
    recordButtonNotifier.value = RecorderStateEnum.recorded;
  }

  void restart() {
    _recorder!.updateRecorderProgress(duration: 0);
    recordButtonNotifier.value = RecorderStateEnum.stopped;
  }

  void playRecord() {
    recordButtonNotifier.value = RecorderStateEnum.playingPlayback;
  }

  void pausePlayback() {
    recordButtonNotifier.value = RecorderStateEnum.recorded;
  }

  void sendRecording({
    required String title,
    required String author,
    required String artUrl,
  }) async {
    if (recordButtonNotifier.value != RecorderStateEnum.recorded) return;
    final audioMetadata = currentAudioMetadataNotifier.value;
    currentAudioMetadataNotifier.value = AudioMetadata(
      id: audioMetadata.id,
      author: author,
      title: title,
      artUrl: artUrl,
      url: audioMetadata.artUrl,
      senderId: audioMetadata.senderId,
      timeSent: DateTime.now(),
    );
    //TODO
  }
}
