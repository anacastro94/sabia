import 'package:bbk_final_ana/audio/enums/recorder_enum.dart';
import 'package:flutter/material.dart';

class RecordButtonNotifier extends ValueNotifier<RecorderStateEnum> {
  RecordButtonNotifier() : super(_initialValue);
  static const _initialValue = RecorderStateEnum.notInitialized;
}
