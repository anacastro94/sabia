import 'package:bbk_final_ana/audio/enums/play_button_enum.dart';
import 'package:flutter/material.dart';

class PlayButtonNotifier extends ValueNotifier<PlayerButtonState> {
  PlayButtonNotifier() : super(_initialValue);
  static const _initialValue = PlayerButtonState.paused;
}
