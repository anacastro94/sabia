import 'package:bbk_final_ana/audio/notifier/player_progress_state.dart';
import 'package:flutter/material.dart';

class ProgressNotifier extends ValueNotifier<PlayerProgressState> {
  ProgressNotifier() : super(_initialValue);
  static const _initialValue = PlayerProgressState(
    current: Duration.zero,
    buffered: Duration.zero,
    total: Duration.zero,
  );
}
