import 'dart:io';

import 'package:bbk_final_ana/models/audio_player.dart';
import 'package:bbk_final_ana/models/audio_recorder.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FeatureButtonsView extends StatefulWidget {
  const FeatureButtonsView({Key? key, required this.onUploadComplete})
      : super(key: key);

  final Function() onUploadComplete;
  @override
  State<FeatureButtonsView> createState() => _FeatureButtonsViewState();
}

class _FeatureButtonsViewState extends State<FeatureButtonsView> {
  late bool _isPlaying;
  late bool _isUploading;
  late bool _isRecorded;
  late bool _isRecording;

  late AudioPlayer _player;
  late String _filePath;
  late AudioRecorder _recorder;

  @override
  void initState() {
    super.initState();
    _isPlaying = false;
    _isUploading = false;
    _isRecorded = false;
    _isRecording = false;
    _player = AudioPlayer.create();
    _recorder = AudioRecorder.create();
  }

  @override
  void dispose() {
    super.dispose();
    _player.close();
    _recorder.close();
  }

  Future<void> _onFileUploadButtonPressed() async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    setState(() {
      _isUploading = true;
    });
    try {
      await firebaseStorage
          .ref('audio')
          .child(
              _filePath.substring(_filePath.lastIndexOf('/'), _filePath.length))
          .putFile(File(_filePath));
      widget.onUploadComplete;
    } catch (e) {
      print('Error occurred while uploading to Firebase ${e.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error occurred while uploading'),
        ),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _onRecordAgainButtonPressed() {
    setState(() {
      _isRecorded = false;
    });
  }

  Future<void> _onRecordButtonPressed() async {
    if (_isRecording) {
      _recorder.stop();
      _isRecording = false;
      _isRecorded = true; //_recorder.playbackIsReady
    } else {
      _isRecorded = false;
      _isRecording = true;
      await _startRecording();
    }
    setState(() {});
  }

  Future<void> _startRecording() async {
    if (!_recorder.isInitialized) {
      return;
    } //TODO: Improve how the lack of permission will be handled
    Directory directory = await getApplicationDocumentsDirectory();
    String filePath =
        '${directory.path}/${DateTime.now().microsecondsSinceEpoch.toString()}.mp4'; //TODO: We might need to used the extension .aac
    _recorder.path = filePath;
    _recorder.record();
    _filePath = filePath;
    setState(() {});
  }

  void _onPlayButtonPressed() {
    if (!_isPlaying) {
      _isPlaying = true;
      _player.play(_filePath);
      _isPlaying = false; //TODO: WILL GO WRONG
      setState(() {});
    } else {
      _player.stop();
      _isPlaying = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isRecorded
          ? _isUploading
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: LinearProgressIndicator()),
                    Text('Uploading to Firebase'),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.replay),
                      onPressed: _onRecordAgainButtonPressed,
                    ),
                    IconButton(
                      icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                      onPressed: _onPlayButtonPressed,
                    ),
                    IconButton(
                      icon: const Icon(Icons.upload_file),
                      onPressed: _onFileUploadButtonPressed,
                    ),
                  ],
                )
          : IconButton(
              icon: _isRecording
                  ? const Icon(Icons.pause)
                  : const Icon(Icons.fiber_manual_record),
              onPressed: _onRecordButtonPressed,
            ),
    );
  }
}
