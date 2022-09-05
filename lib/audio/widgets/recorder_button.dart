import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/constants/constants.dart';
import '../controller/recorder_controller.dart';
import '../enums/recorder_enum.dart';

class RecorderButton extends ConsumerWidget {
  const RecorderButton({
    Key? key,
    this.iconColor = kAntiqueWhite,
    this.backgroundColor = kDarkOrange,
  }) : super(key: key);
  final Color iconColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recorderController = ref.read(recorderControllerProvider);

    IconData getRecordButtonIcon(RecorderStateEnum recorderState) {
      switch (recorderState) {
        case RecorderStateEnum.recording:
          return Icons.stop;
        case RecorderStateEnum.recorded:
          return Icons.play_arrow;
        case RecorderStateEnum.playingPlayback:
          return Icons.pause;
        default:
          return Icons.mic;
      }
    }

    void Function()? getRecordButtonFunction(RecorderStateEnum recorderState) {
      switch (recorderState) {
        case RecorderStateEnum.playingPlayback:
          return () => recorderController.pausePlayback();
        case RecorderStateEnum.recorded:
          return () => recorderController.playRecord();
        case RecorderStateEnum.recording:
          return () => recorderController.stopRecorder();
        case RecorderStateEnum.stopped:
          return () => recorderController.record();
        case RecorderStateEnum.notInitialized:
          return null;
      }
    }

    return CircleAvatar(
      radius: 80.0,
      backgroundColor: kAntiqueWhite.withOpacity(0.2),
      child: ValueListenableBuilder<RecorderStateEnum>(
          valueListenable: recorderController.recordButtonNotifier,
          builder: (context, recorderState, _) {
            if (recorderState == RecorderStateEnum.notInitialized) {
              recorderController.initRecorder(context);
            }
            return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(66.0),
                  border: Border.all(
                    width: 6.0,
                    color: kGreenLight,
                  )),
              height: 132.0,
              width: 132.0,
              child: FittedBox(
                child: FloatingActionButton(
                  heroTag: 'btn1',
                  backgroundColor:
                      recorderState == RecorderStateEnum.notInitialized
                          ? Colors.grey
                          : backgroundColor,
                  splashColor: kAntiqueWhite.withOpacity(0.2),
                  onPressed: getRecordButtonFunction(recorderState),
                  elevation: 0.0,
                  child: Icon(
                    getRecordButtonIcon(recorderState),
                    size: 30.0,
                    color: iconColor,
                  ),
                ),
              ),
            );
          }),
    );
  }
}
