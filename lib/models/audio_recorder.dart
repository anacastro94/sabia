import 'dart:async';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioRecorder extends ChangeNotifier {
  FlutterSoundRecorder? _recorder;
  bool _isInitialized = false;
  bool _playbackIsReady = false;
  final AudioSource _audioSource = AudioSource.microphone;
  String path = 'audio_file.mp4'; // Default value, should be updated
  Codec _codec = Codec.aacMP4;

  bool get isInitialized => _isInitialized;
  bool get playbackIsReady => _playbackIsReady;
  bool get isRecording => _recorder!.isRecording;
  bool get isStopped => _recorder!.isStopped;
  bool get isPaused => _recorder!.isPaused;
  Stream? get onProgress => _recorder!.onProgress;
  Codec get codec => _codec;

  AudioRecorder.create() {
    _recorder = FlutterSoundRecorder();
    init();
  }

  void init() {
    _openRecorder().then((_) {
      //_isInitialized = true; //TODO: Check if this repetition is necessary
      notifyListeners();
    });
  }

  Future<void> _openRecorder() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException(
            'Microphone permission not granted.');
      }
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
    _isInitialized = true;
  }

  void close() {
    _recorder!.closeRecorder();
    _recorder = null;
    _isInitialized = false;
    notifyListeners();
  }

  void record() async {
    if (!_isInitialized) throw 'Recorder not initialized.';
    await _recorder!
        .startRecorder(
          toFile: path,
          codec: _codec,
          audioSource: _audioSource,
        )
        .then((_) => notifyListeners());
  }

  void stop() async {
    if (!_isInitialized) throw 'Recorder not initialized.';
    await _recorder!.stopRecorder().then((_) {
      _playbackIsReady = true;
      notifyListeners();
    });
  }

  void pause() async {
    if (!_isInitialized) throw 'Recorder not initialized.';
    if (!isRecording) {
      return; //To avoid requesting a recorder to pause when it is not recording
    }
    await _recorder!.pauseRecorder().then((_) => notifyListeners());
  }
}
