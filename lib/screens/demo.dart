import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data' show Uint8List;

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/*
 * The biggest interest of this Demo is that it shows most of the features of Flutter Sound :
 *  - Plays from various media with various codecs
 * - Records to various media with various codecs
 * - Pause and Resume control from recording or playback
 * - Shows how to use a Stream for getting the playback (or recoding) events
 * - Shows how to specify a callback function when a playback is terminated,
 * - Shows how to record to a Stream or playback from a stream
 * - Can show controls on the iOS or Android lock-screen
 */

const int kSampleRate = 8000;

/// Sample rate used for Streams
const int kStreamSampleRate = 44000;
const int kBlockSize = 4096;
const albumArtPathRemote =
    'https://flutter-sound.canardoux.xyz/web_example/assets/extract/3iob.png';
const albumArtPath =
    'https://file-examples-com.github.io/uploads/2017/10/file_example_PNG_500kB.png';

enum Media {
  file,
  buffer,
  asset,
  stream,
  remoteExampleFile,
}

enum AudioState {
  isPlaying,
  isPaused,
  isStopped,
  isRecording,
  isRecordingPaused,
}

class Demo extends StatefulWidget {
  const Demo({Key? key}) : super(key: key);

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  final List<String?> _path = [
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
  ]; //Why initialize with all those nulls?
  // So that there is a path for each example selected with different codecs.
  // There are 19 codecs in total.

  List<String> assetSample = [
    'assets/samples/sample.aac',
    'assets/samples/sample.aac',
    'assets/samples/sample.opus',
    'assets/samples/sample_opus.caf',
    'assets/samples/sample.mp3',
    'assets/samples/sample.ogg',
    'assets/samples/sample.pcm',
    'assets/samples/sample.wav',
    'assets/samples/sample.aiff',
    'assets/samples/sample_pcm.caf',
    'assets/samples/sample.flac',
    'assets/samples/sample.mp4',
    'assets/samples/sample.amr', // amrNB
    'assets/samples/sample_xxx.amr', // amrWB
    'assets/samples/sample_xxx.pcm', // pcm8
    'assets/samples/sample_xxx.pcm', // pcmFloat32
    '', // 'assets/samples/sample_xxx.pcm', // pcmWebM
    'assets/samples/sample_opus.webm', // opusWebM
    'assets/samples/sample_vorbis.webm', // vorbisWebM
  ];

  List<String> remoteSample = [
    'https://flutter-sound.canardoux.xyz/web_example/assets/extract/01.aac', // 'assets/samples/sample.aac',
    'https://flutter-sound.canardoux.xyz/web_example/assets/extract/01.aac', // 'assets/samples/sample.aac',
    'https://flutter-sound.canardoux.xyz/web_example/assets/extract/08.opus', // 'assets/samples/sample.opus',
    'https://flutter-sound.canardoux.xyz/web_example/assets/extract/04-opus.caf', // 'assets/samples/sample_opus.caf',
    'https://flutter-sound.canardoux.xyz/web_example/assets/extract/05.mp3', // 'assets/samples/sample.mp3',
    'https://flutter-sound.canardoux.xyz/web_example/assets/extract/07.ogg', // 'assets/samples/sample.ogg',
    'https://flutter-sound.canardoux.xyz/web_example/assets/extract/10-pcm16.raw', // 'assets/samples/sample.pcm',
    'https://flutter-sound.canardoux.xyz/web_example/assets/extract/13.wav', // 'assets/samples/sample.wav',
    'https://flutter-sound.canardoux.xyz/web_example/assets/extract/02.aiff', // 'assets/samples/sample.aiff',
    'https://flutter-sound.canardoux.xyz/web_example/assets/extract/01-pcm.caf', // 'assets/samples/sample_pcm.caf',
    'https://flutter-sound.canardoux.xyz/web_example/assets/extract/04.flac', // 'assets/samples/sample.flac',
    'https://flutter-sound.canardoux.xyz/web_example/assets/extract/06.mp4', // 'assets/samples/sample.mp4',
    'https://flutter-sound.canardoux.xyz/web_example/assets/extract/03.amr', // 'assets/samples/sample.amr', // amrNB
    'https://flutter-sound.canardoux.xyz/web_example/assets/extract/03.amr', // 'assets/samples/sample_xxx.amr', // amrWB
    'https://flutter-sound.canardoux.xyz/web_example/assets/extract/09-pcm8.raw', // 'assets/samples/sample_xxx.pcm', // pcm8
    'https://flutter-sound.canardoux.xyz/web_example/assets/extract/12-pcmfloat.raw', // 'assets/samples/sample_xxx.pcm', // pcmFloat32
    '', // 'assets/samples/sample_xxx.pcm', // pcmWebM
    'https://flutter-sound.canardoux.xyz/web_example/assets/extract/02-opus.webm', // 'assets/samples/sample_opus.webm', // opusWebM
    'https://flutter-sound.canardoux.xyz/web_example/assets/extract/03-vorbis.webm', // 'assets/samples/sample_vorbis.webm', // vorbisWebM
  ];
  bool _isRecording = false;
  StreamSubscription? _recorderSubscription;
  StreamSubscription? _playerSubscription;
  StreamSubscription? _recordingDataSubscription;
  FlutterSoundPlayer player = FlutterSoundPlayer();
  FlutterSoundRecorder recorder = FlutterSoundRecorder();
  String _recorderTxt = '00:00:00';
  String _playerTxt = '00:00:00';
  double? _dbLevel;
  double sliderCurrentPosition = 0.0;
  double maxDuration = 1.0;
  Media? _media = Media.remoteExampleFile;
  Codec _codec = Codec.aacMP4;
  bool? _encoderSupported = true;
  bool _decoderSupported = true;
  StreamController<Food>? recordingDataController;
  IOSink? sink;

  Future<void> _initializeExample() async {
    await player.closePlayer();
    await player.openPlayer();
    await player.setSubscriptionDuration(const Duration(milliseconds: 10));
    await recorder.setSubscriptionDuration(const Duration(milliseconds: 10));
    await initializeDateFormatting(); //Needs to be called to use the Intl package
    await setCodec(_codec);
  }

  Future<void> setCodec(Codec codec) async {
    _encoderSupported = await recorder.isEncoderSupported(codec);
    _decoderSupported = await player.isDecoderSupported(codec);
    setState(() {
      _codec = codec;
    });
  }

  Future<void> openTheRecorder() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    await recorder.openRecorder();
    //TODO: For mobile apps only this block below will not be needed.
    if (!await recorder.isEncoderSupported(_codec) && kIsWeb) {
      _codec = Codec.opusWebM;
    }
  }

  Future<void> copyAssets() async {
    //TODO: Study each line of the code below.
    var dataBuffer =
        (await rootBundle.load('assets/canardo.png')).buffer.asUint8List();
    String path = '${await player.getResourcePath()}/assets';
    if (!await Directory(path).exists()) {
      await Directory(path).create(recursive: true);
    }
    await File('$path/canardo.png').writeAsBytes(dataBuffer);
  }

  Future<void> init() async {
    await openTheRecorder();
    await _initializeExample();
    if (!kIsWeb && Platform.isAndroid) {
      await copyAssets();
    }
    // Configuring the audio session
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
  }

  @override
  void initState() {
    init();
    super.initState(); //TODO: Should this come first or last?
  }

  void cancelRecorderSubscription() {
    if (_recorderSubscription != null) {
      _recorderSubscription!.cancel();
      _recorderSubscription = null;
    }
  }

  void cancelPlayerSubscription() {
    if (_playerSubscription != null) {
      _playerSubscription!.cancel();
      _playerSubscription = null;
    }
  }

  void cancelRecordingDataSubscription() {
    if (_recordingDataSubscription != null) {
      _recorderSubscription!.cancel();
      _recorderSubscription = null;
    }
    recordingDataController = null;
    if (sink != null) {
      sink!.close();
      sink = null;
    }
  }

  @override
  void dispose() {
    cancelPlayerSubscription();
    cancelRecorderSubscription();
    cancelRecordingDataSubscription();
    super.dispose(); //TODO: Should this come first or last?
  }

  Future<void> releaseFlauto() async {
    try {
      await player.closePlayer();
      await recorder.closeRecorder();
    } on Exception {
      player.logger.e(
          'Release unsuccessful'); //TODO: Why only keep this in player logger
    }
  }

  void startRecorder() async {
    try {
      // Request microphone permission if needed
      if (!kIsWeb) {
        var status = await Permission.microphone.request();
        if (status != PermissionStatus.granted) {
          throw RecordingPermissionException(
              'Microphone permission not granted');
        }
      }
      String path = '';
      if (!kIsWeb) {
        var tempDir =
            await getTemporaryDirectory(); //TODO: understand this command
        path = '${tempDir.path}/flutter_sound${ext[_codec.index]}';
      } else {
        path = '_flutter_sound${ext[_codec.index]}';
      }
      if (_media == Media.stream) {
        assert(_codec == Codec.pcm16); //TODO: Understand why
        if (!kIsWeb) {
          var outputFile = File(path);
          if (outputFile.existsSync()) {
            await outputFile.delete();
          }
          sink = outputFile.openWrite();
        } else {
          sink = null; //TODO: Not implemented by package author
        }
        recordingDataController = StreamController<Food>();
        _recordingDataSubscription =
            recordingDataController!.stream.listen((event) {
          if (event is FoodData) {
            sink!.add(event.data!);
          }
        });
        await recorder.startRecorder(
          toStream: recordingDataController!.sink,
          codec: _codec,
          numChannels: 1,
          sampleRate: kStreamSampleRate,
        );
      } else {
        await recorder.startRecorder(
          toFile: path,
          codec: _codec,
          bitRate: 8000,
          numChannels: 1,
          sampleRate: (_codec == Codec.pcm16) ? kStreamSampleRate : kSampleRate,
        );
      }
      recorder.logger.d('startRecorder');
      _recorderSubscription = recorder.onProgress!.listen((event) {
        var date = DateTime.fromMillisecondsSinceEpoch(
            event.duration.inMilliseconds,
            isUtc: true);
        String txt = DateFormat('mm:ss:SS', 'en_GB').format(date);
        setState(() {
          _recorderTxt = txt.substring(0, 8);
          _dbLevel = event.decibels;
        });
      });
      setState(() {
        _isRecording = true;
        _path[_codec.index] = path;
      });
    } on Exception catch (err) {
      recorder.logger.e('starRecorder error: $err');
      setState(() {
        stopRecorder();
        _isRecording = false;
        cancelRecordingDataSubscription();
        cancelRecorderSubscription();
      });
    }
  }

  void stopRecorder() async {
    try {
      await recorder.stopRecorder();
      recorder.logger.d('stopRecorder');
      cancelRecorderSubscription();
      cancelRecordingDataSubscription();
    } on Exception catch (err) {
      recorder.logger.d('stopRecorder error: $err');
    }
    setState(() {
      _isRecording = false;
    });
  }

  Future<bool> fileExists(String path) async {
    return await File(path).exists();
  }

  // In this simple example, we just load a file in memory.This is stupid but just for demonstration  of startPlayerFromBuffer()
  Future<Uint8List?> makeBuffer(String path) async {
    try {
      if (!await fileExists(path)) return null;
      var file = File(path);
      file.openRead();
      var contents = await file.readAsBytes();
      player.logger.i('The file is ${contents.length} bytes long.');
      return contents;
    } on Exception catch (err) {
      player.logger.e(err);
      return null;
    }
  }

  void _addListeners() {
    cancelPlayerSubscription();
    _playerSubscription = player.onProgress!.listen((event) {
      maxDuration = event.duration.inMilliseconds.toDouble();
      if (maxDuration <= 0) maxDuration = 0.0;
      sliderCurrentPosition =
          min(event.position.inMilliseconds.toDouble(), maxDuration);
      if (sliderCurrentPosition < 0.0) sliderCurrentPosition = 0.0;
      var date = DateTime.fromMillisecondsSinceEpoch(
          event.position.inMilliseconds,
          isUtc: true);
      String txt = DateFormat('mm:ss:SS', 'en_GB').format(date);
      setState(() {
        _playerTxt = txt.substring(0, 8);
      });
    });
  }

  Future<Uint8List> _readFileByte(String filePath) async {
    var myUri = Uri.parse(filePath);
    var audioFile = File.fromUri(myUri);
    Uint8List bytes;
    var b = await audioFile.readAsBytes();
    bytes = Uint8List.fromList(b);
    player.logger.d('Reading of bytes completed');
    return bytes;
  }

  Future<Uint8List> getAssetData(String path) async {
    var asset = await rootBundle.load(path);
    return asset.buffer.asUint8List();
  }

  final int blockSize = 4096;
  Future<void> feedHim(String path) async {
    var buffer = await _readFileByte(path);
    var lnData = 0;
    var totalLength = buffer.length;
    while (totalLength > 0 && !player.isStopped) {
      var bSize = totalLength > blockSize ? blockSize : totalLength;
      await player.feedFromStream(buffer.sublist(lnData, lnData + bSize));
      lnData += bSize;
      totalLength -= bSize;
    }
  }

  Future<void> startPlayer() async {
    try {
      Uint8List? dataBuffer;
      String? audioFilePath;
      var codec = _codec;
      if (_media == Media.asset) {
        dataBuffer = (await rootBundle.load(assetSample[codec.index]))
            .buffer
            .asUint8List();
      } else if (_media == Media.file || _media == Media.stream) {
        // Do we want to play from buffer or from file?
        if (kIsWeb || await fileExists(_path[codec.index]!)) {
          audioFilePath = _path[codec.index];
        }
      } else if (_media == Media.buffer) {
        // Do we want to play from buffer or from file?
        if (await fileExists(_path[codec.index]!)) {
          dataBuffer = await makeBuffer(_path[codec.index]!);
        }
        if (dataBuffer == null) {
          throw Exception('Unable to create the buffer');
        }
      } else if (_media == Media.remoteExampleFile) {
        // We have to play an example audio file loaded via a URL
        audioFilePath = remoteSample[_codec.index];
      }
      if (_media == Media.stream) {
        await player.startPlayerFromStream(
          codec: Codec.pcm16,
          numChannels: 1,
          sampleRate: kStreamSampleRate,
        );
        _addListeners();
        setState(() {});
        await feedHim(audioFilePath!);
        await stopPlayer();
        return;
      } else {
        if (audioFilePath != null) {
          await player.startPlayer(
              fromURI: audioFilePath,
              codec: codec,
              sampleRate: kStreamSampleRate,
              whenFinished: () {
                player.logger.d('Play finished');
                setState(() {});
              });
        } else if (dataBuffer != null) {
          if (codec == Codec.pcm16) {
            dataBuffer = await flutterSoundHelper.pcmToWaveBuffer(
                inputBuffer: dataBuffer,
                numChannels: 1,
                sampleRate: (_codec == Codec.pcm16 && _media == Media.asset)
                    ? 48000
                    : kSampleRate);
            codec = Codec.pcm16WAV;
          }
          await player.startPlayer(
              fromDataBuffer: dataBuffer,
              sampleRate: kSampleRate,
              codec: codec,
              whenFinished: () {
                player.logger.d('Play finished');
                setState(() {});
              });
        }
      }
      _addListeners();
      setState(() {});
      player.logger.d('<----startPlayer');
    } on Exception catch (err) {
      player.logger.e('error: $err');
    }
  }

  Future<void> stopPlayer() async {
    try {
      await player.stopPlayer();
      player.logger.d('stopPlayer');
      if (_playerSubscription != null) {
        await _playerSubscription!.cancel();
        _playerSubscription = null;
      }
      sliderCurrentPosition = 0.0;
    } on Exception catch (err) {
      player.logger.e('error: $err');
    }
    setState(() {});
  }

  void pauseResumePlayer() async {
    try {
      if (player.isPlaying) {
        await player.pausePlayer();
      } else {
        await player.resumePlayer();
      }
    } on Exception catch (err) {
      player.logger.e('error: $err');
    }
    setState(() {});
  }

  void pauseResumeRecorder() async {
    try {
      if (recorder.isPaused) {
        await recorder.resumeRecorder();
      } else {
        await recorder.pauseRecorder();
        assert(recorder.isPaused);
      }
    } on Exception catch (err) {
      recorder.logger.e('error: $err');
    }
    setState(() {});
  }

  Future<void> seekToPlayer(int milliSecs) async {
    try {
      if (player.isPlaying) {
        await player.seekToPlayer(Duration(milliseconds: milliSecs));
      }
    } on Exception catch (err) {
      player.logger.e('error: $err');
    }
    setState(() {});
  }

  Widget makeDropdowns(BuildContext context) {
    final mediaDropdown = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: Text('Media:'),
        ),
        DropdownButton<Media>(
          value: _media,
          onChanged: (newMedia) {
            _media = newMedia;
            setState(() {});
          },
          items: const <DropdownMenuItem<Media>>[
            DropdownMenuItem<Media>(
              value: Media.file,
              child: Text('File'),
            ),
            DropdownMenuItem<Media>(
              value: Media.buffer,
              child: Text('Buffer'),
            ),
            DropdownMenuItem<Media>(
              value: Media.asset,
              child: Text('Asset'),
            ),
            DropdownMenuItem<Media>(
              value: Media.remoteExampleFile,
              child: Text('Remote Example File'),
            ),
            DropdownMenuItem<Media>(
              value: Media.stream,
              child: Text('Dart Stream'),
            ),
          ],
        ),
      ],
    );

    final codecDropdown = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: Text('Codec:'),
        ),
        DropdownButton<Codec>(
          value: _codec,
          onChanged: (newCodec) {
            setCodec(newCodec!);
            _codec = newCodec;
            setState(() {});
          },
          items: const <DropdownMenuItem<Codec>>[
            DropdownMenuItem<Codec>(
              value: Codec.aacADTS,
              child: Text('AAC/ADTS'),
            ),
            DropdownMenuItem<Codec>(
              value: Codec.opusOGG,
              child: Text('Opus/OGG'),
            ),
            DropdownMenuItem<Codec>(
              value: Codec.opusCAF,
              child: Text('Opus/CAF'),
            ),
            DropdownMenuItem<Codec>(
              value: Codec.mp3,
              child: Text('MP3'),
            ),
            DropdownMenuItem<Codec>(
              value: Codec.vorbisOGG,
              child: Text('Vorbis/OGG'),
            ),
            DropdownMenuItem<Codec>(
              value: Codec.pcm16,
              child: Text('PCM16'),
            ),
            DropdownMenuItem<Codec>(
              value: Codec.pcm16WAV,
              child: Text('PCM16/WAV'),
            ),
            DropdownMenuItem<Codec>(
              value: Codec.pcm16AIFF,
              child: Text('PCM16/AIFF'),
            ),
            DropdownMenuItem<Codec>(
              value: Codec.pcm16CAF,
              child: Text('PCM16/CAF'),
            ),
            DropdownMenuItem<Codec>(
              value: Codec.flac,
              child: Text('FLAC'),
            ),
            DropdownMenuItem<Codec>(
              value: Codec.aacMP4,
              child: Text('AAC/MP4'),
            ),
            DropdownMenuItem<Codec>(
              value: Codec.amrNB,
              child: Text('AMR-NB'),
            ),
            DropdownMenuItem<Codec>(
              value: Codec.amrWB,
              child: Text('AMR-WB '),
            ),
            DropdownMenuItem<Codec>(
              value: Codec.pcm8,
              child: Text('PCM8 '),
            ),
            DropdownMenuItem<Codec>(
              value: Codec.pcmFloat32,
              child: Text('PCM Float32 '),
            ),
            DropdownMenuItem<Codec>(
              value: Codec.pcmWebM,
              child: Text('PCM/WebM '),
            ),
            DropdownMenuItem<Codec>(
              value: Codec.opusWebM,
              child: Text('Opus/WebM '),
            ),
            DropdownMenuItem<Codec>(
              value: Codec.vorbisWebM,
              child: Text('Vorbis/WebM '),
            ),
          ],
        ),
      ],
    );
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: mediaDropdown,
          ),
          codecDropdown,
        ],
      ),
    );
  }

  void Function()? onPauseResumePlayerPressed() {
    if (player.isPaused || player.isPlaying) {
      return pauseResumePlayer;
    }
    return null;
  }

  void Function()? onPauseResumeRecorderPressed() {
    if (recorder.isPaused || recorder.isRecording) {
      return pauseResumeRecorder;
    }
    return null;
  }

  void Function()? onStopPlayerPressed() {
    return (player.isPlaying || player.isPaused) ? stopPlayer : null;
  }

  void Function()? onStartPlayerPressed() {
    if (_media == Media.buffer && kIsWeb) {
      return null;
    }
    if (_media == Media.file ||
        _media == Media.stream ||
        _media == Media.buffer) {
      if (_path[_codec.index] == null)
        return null; // A file must be already recorded to play it
    }
    if (_media == Media.stream && _codec != Codec.pcm16) {
      return null;
    }
    if (!(_decoderSupported || _codec == Codec.pcm16)) {
      return null;
    }
    return (player.isStopped) ? startPlayer : null;
  }

  void startStopRecorder() {
    if (recorder.isRecording || recorder.isPaused) {
      stopRecorder();
    } else {
      startRecorder();
    }
  }

  void Function()? onStartRecorderPressed() {
    // Disable the button if the selected codec is not supported
    if (!_encoderSupported!) return null;
    if (_media == Media.stream && _codec != Codec.pcm16) return null;
    return startStopRecorder;
  }

  Widget recorderStopRecordIcon() {
    if (onStartRecorderPressed() == null) {
      return const Icon(Icons.mic_off);
    }
    return Icon(recorder.isStopped ? Icons.mic : Icons.stop);
  }

  Widget recorderPauseResumeIcon() {
    if (onPauseResumeRecorderPressed() == null) {
      return Container();
    }
    return Icon(recorder.isPaused ? Icons.play_arrow : Icons.pause);
  }

  Widget playerPauseResumeIcon() {
    if (onPauseResumePlayerPressed() == null) {
      return Container();
    }
    return Icon(player.isPaused ? Icons.play_arrow : Icons.pause);
  }

  @override
  Widget build(BuildContext context) {
    final dropdowns = makeDropdowns(context);

    Widget recorderSection = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 12.0, bottom: 16.0),
          child: Text(
            _recorderTxt,
            style: const TextStyle(
              fontSize: 35.0,
              color: Colors.black,
            ),
          ),
        ),
        _isRecording
            ? LinearProgressIndicator(
                value: 100.0 / 160.0 * (_dbLevel ?? 1) / 100,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                backgroundColor: Colors.red)
            : Container(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 56.0,
              height: 50.0,
              child: TextButton(
                onPressed: onStartRecorderPressed(),
                child: recorderStopRecordIcon(),
              ),
            ),
            SizedBox(
              width: 56.0,
              height: 50.0,
              child: TextButton(
                onPressed: onPauseResumeRecorderPressed(),
                child: recorderPauseResumeIcon(),
              ),
            ),
          ],
        ),
      ],
    );

    Widget playerSection = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 12.0, bottom: 16.0),
          child: Text(
            _playerTxt,
            style: const TextStyle(
              fontSize: 35.0,
              color: Colors.black,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 56.0,
              height: 50.0,
              child: TextButton(
                onPressed: onStartPlayerPressed(),
                child: onStartPlayerPressed() != null
                    ? const Icon(Icons.play_arrow)
                    : Container(),
              ),
            ),
            SizedBox(
              width: 56.0,
              height: 50.0,
              child: TextButton(
                onPressed: onPauseResumePlayerPressed(),
                child: playerPauseResumeIcon(),
              ),
            ),
            SizedBox(
              width: 56.0,
              height: 50.0,
              child: TextButton(
                onPressed: onStopPlayerPressed(),
                child: onStopPlayerPressed() != null
                    ? const Icon(Icons.stop)
                    : Container(),
              ),
            ),
            SizedBox(
              height: 30.0,
              child: Slider(
                value: min(sliderCurrentPosition, maxDuration),
                min: 0.0,
                max: maxDuration,
                onChanged: (value) async {
                  await seekToPlayer(value.toInt());
                },
                divisions: maxDuration == 0 ? 1 : maxDuration.toInt(),
              ),
            ),
          ],
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter sound demo'),
      ),
      body: ListView(
        children: [
          recorderSection,
          playerSection,
          dropdowns,
        ],
      ),
    );
  }
}
