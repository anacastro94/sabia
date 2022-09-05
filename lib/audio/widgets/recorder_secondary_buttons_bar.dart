import 'package:bbk_final_ana/audio/widgets/restart_recording_button.dart';
import 'package:flutter/material.dart';

import 'done_recording_button.dart';

class RecorderSecondaryButtonsBar extends StatelessWidget {
  const RecorderSecondaryButtonsBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          RestartRecordingButton(),
          SizedBox(width: 80.0),
          DoneRecordingButton(),
        ],
      ),
    );
  }
}
