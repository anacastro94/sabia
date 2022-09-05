import 'package:bbk_final_ana/audio/widgets/recorder_button.dart';
import 'package:bbk_final_ana/audio/widgets/recorder_secondary_buttons_bar.dart';
import 'package:bbk_final_ana/audio/widgets/recorder_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/recorder_controller.dart';
import '../enums/recorder_enum.dart';

class RecorderUI extends ConsumerWidget {
  const RecorderUI({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recorderController = ref.read(recorderControllerProvider);
    return ValueListenableBuilder<RecorderStateEnum>(
        valueListenable: recorderController.recordButtonNotifier,
        builder: (context, recorderState, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const RecorderTimer(),
              const SizedBox(height: 48.0),
              const RecorderButton(),
              const SizedBox(height: 24.0),
              recorderState == RecorderStateEnum.stopped ||
                      recorderState == RecorderStateEnum.notInitialized ||
                      recorderState == RecorderStateEnum.recording
                  ? const SizedBox()
                  : const RecorderSecondaryButtonsBar()
            ],
          );
        });
  }
}
