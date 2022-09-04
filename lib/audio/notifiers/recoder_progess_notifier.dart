import 'package:bbk_final_ana/audio/notifiers/recorder_progress_state.dart';
import 'package:flutter/material.dart';

class RecorderProgressNotifier extends ValueNotifier<RecorderProgressState> {
  RecorderProgressNotifier() : super(_initialValue);
  static const _initialValue =
      RecorderProgressState(maxDuration: Duration.zero);
}
