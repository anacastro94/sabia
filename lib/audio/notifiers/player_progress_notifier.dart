import 'package:bbk_final_ana/audio/notifiers/player_progress_state.dart';
import 'package:flutter/material.dart';

class PlayerProgressNotifier extends ValueNotifier<PlayerProgressState> {
  PlayerProgressNotifier() : super(_initialValue);
  static const _initialValue = PlayerProgressState(
    current: Duration.zero,
    buffered: Duration.zero,
    total: Duration.zero,
  );
}
