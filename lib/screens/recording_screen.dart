import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../common/widgets/stream_clock.dart';
import '../models/audio_player.dart';
import '../models/audio_recorder.dart';
import '../models/time.dart';

class RecordingScreen extends StatelessWidget {
  const RecordingScreen({Key? key}) : super(key: key);

  //TODO: Think about where to include the dispose of the recorder and player

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioRecorder>(
        builder: (BuildContext context, AudioRecorder recorder, Widget? child) {
      return Consumer<AudioPlayer>(
          builder: (BuildContext context, AudioPlayer player, Widget? child) {
        String timeRecording = Time.fromSeconds(0).toString();
        String timePlaying = Time.fromSeconds(0).toString();

        void Function()? getRecorderFn() {
          if (!recorder.isInitialized || !player.isStopped) {
            return null;
          }
          return () async {
            if (recorder.isStopped) {
              recorder.record();
            } else {
              // Adding a delay to make sure the very end of the audio is captured
              await Future.delayed(const Duration(seconds: 1));
              recorder.stop();
            }
          };
        }

        void Function()? getPlayerFn() {
          if (!player.isInitialized ||
              !recorder.playbackIsReady ||
              !recorder.isStopped) {
            return null;
          }
          return () =>
              player.isStopped ? player.play(recorder.path) : player.stop();
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Simple recorder'),
          ),
          body: Column(
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
                      child: Text(recorder.isRecording ? 'Stop' : 'Record'),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(recorder.isRecording
                            ? 'Recording in progress'
                            : 'Recorder is stopped'),
                        const SizedBox(height: 8.0),
                        recorder.onProgress != null
                            ? StreamClock(
                                stream: recorder.onProgress, isRecording: true)
                            : Container(),
                      ],
                    ),
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
                      onPressed: getPlayerFn(),
                      child: Text(player.isPlaying ? 'Stop' : 'Play'),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(player.isPlaying
                            ? 'Playback in progress'
                            : 'Player is stopped'),
                        const SizedBox(height: 8.0),
                        player.onProgress != null
                            ? StreamClock(
                                stream: player.onProgress, isRecording: false)
                            : Container(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      });
    });
  }
}
