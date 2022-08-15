import 'dart:async';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:permission_handler/permission_handler.dart';

/*
 * This is an example showing how to record to a Dart Stream.
 * It writes all the recorded data from a Stream to a File, which is completely stupid:
 * if an App wants to record something to a File, it must not use Streams.
 *
 * The real interest of recording to a Stream is for example to feed a
 * Speech-to-Text engine, or for processing the Live data in Dart in real time.
 *
 */

typedef _Fn = void Function();

const theSource = AudioSource.microphone;

class SimpleRecorder extends StatefulWidget {
  const SimpleRecorder({Key? key}) : super(key: key);

  @override
  State<SimpleRecorder> createState() => _SimpleRecorderState();
}

class _SimpleRecorderState extends State<SimpleRecorder> {
  Codec _codec = Codec.aacMP4;
  String _mPath = 'tau_file.mp4';
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  bool _mPlayerIsInitialized = false;
  bool _mRecorderIsInitialized = false;
  bool _mPlaybackReady = false;

  @override
  void initState() {
    _mPlayer!.openPlayer().then((value) => setState(() {
          _mPlayerIsInitialized = true;
        }));

    openTheRecorder().then((value) => setState(() {
          _mRecorderIsInitialized = true;
        }));

    super.initState();
  }

  @override
  void dispose() {
    _mPlayer!.closePlayer();
    _mPlayer = null;
    _mRecorder!.closeRecorder();
    _mRecorder = null;
    super.dispose();
  }

  Future<void> openTheRecorder() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    await _mRecorder!.openRecorder();
    if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
      _codec = Codec.opusWebM;
      _mPath = 'tau_file.webm';
      if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
        _mRecorderIsInitialized = true;
        return;
      }
    }
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

    _mRecorderIsInitialized = true;
  }

  // ----------------------  Here is the code for recording and playback -------

  void record() {
    _mRecorder!
        .startRecorder(
          toFile: _mPath,
          codec: _codec,
          audioSource: theSource,
        )
        .then((value) => setState(() {}));
  }

  void stopRecorder() async {
    await _mRecorder!.stopRecorder().then((value) => setState(() {
          _mPlaybackReady = true;
        }));
  }

  void play() {
    assert(_mPlayerIsInitialized &&
        _mPlaybackReady &&
        _mRecorder!.isStopped &&
        _mPlayer!
            .isStopped); // TODO: this logic has to stay where the player and recorder are used

    _mPlayer!
        .startPlayer(
          fromURI: _mPath,
          whenFinished: () {
            setState(() {});
          },
        )
        .then((value) => setState(() {}));
  }

  void stopPlayer() {
    _mPlayer!.stopPlayer().then((value) => setState(() {}));
  }

  // ----------------------------- UI ------------------------------------------

  _Fn? getRecorderFn() {
    if (!_mRecorderIsInitialized || !_mPlayer!.isStopped) {
      return null;
    }
    return _mRecorder!.isStopped ? record : stopRecorder;
  }

  _Fn? getPlaybackFn() {
    if (!_mPlayerIsInitialized || !_mPlaybackReady || !_mRecorder!.isStopped) {
      return null;
    }
    return _mPlayer!.isStopped ? play : stopPlayer;
  }

  @override
  Widget build(BuildContext context) {
    Widget makeBody() {
      return Column(
        children: [
          Container(
            margin: const EdgeInsets.all(3),
            padding: const EdgeInsets.all(3),
            height: 80,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFFAF0E6),
              border: Border.all(
                color: Colors.indigo,
                width: 3,
              ),
            ),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: getRecorderFn(),
                  child: Text(_mRecorder!.isRecording ? 'Stop' : 'Record'),
                ),
                const SizedBox(width: 20),
                Text(_mRecorder!.isRecording
                    ? 'Recording in progress'
                    : 'Recorder is stopped'),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(3),
            padding: const EdgeInsets.all(3),
            height: 80,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFFAF0E6),
              border: Border.all(
                color: Colors.indigo,
                width: 3,
              ),
            ),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: getPlaybackFn(),
                  child: Text(_mPlayer!.isPlaying ? 'Stop' : 'Play'),
                ),
                const SizedBox(width: 20),
                Text(_mPlayer!.isPlaying
                    ? 'Playback in progress'
                    : 'Player is stopped'),
              ],
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Recorder'),
      ),
      body: makeBody(),
    );
  }
}
