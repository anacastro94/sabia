import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../common/constants/constants.dart';
import '../controller/recorder_controller.dart';
import '../notifiers/recorder_progress_state.dart';

class RecorderTimer extends ConsumerWidget {
  const RecorderTimer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recorderController = ref.read(recorderControllerProvider);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        color: kGreenLight.withOpacity(0.2),
      ),
      child: ValueListenableBuilder<RecorderProgressState>(
          valueListenable: recorderController.progressNotifier,
          builder: (context, progressState, _) {
            final recordingDuration = DateTime.fromMillisecondsSinceEpoch(
              progressState.maxDuration.inMilliseconds,
              isUtc: true,
            );
            final formattedDuration =
                DateFormat('mm:ss').format(recordingDuration);
            return Text(
              formattedDuration,
              style: const TextStyle(
                fontSize: 72.0,
                color: kAntiqueWhite,
                fontWeight: FontWeight.bold,
              ),
            );
          }),
    );
  }
}
