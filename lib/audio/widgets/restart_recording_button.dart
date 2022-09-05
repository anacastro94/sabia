import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/constants/constants.dart';
import '../controller/recorder_controller.dart';
import '../enums/recorder_enum.dart';

class RestartRecordingButton extends ConsumerWidget {
  const RestartRecordingButton({
    Key? key,
    this.iconColor = kAntiqueWhite,
    this.backgroundColor = kBlackOlive,
  }) : super(key: key);
  final Color iconColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recorderController = ref.read(recorderControllerProvider);
    return CircleAvatar(
      radius: 36.0,
      backgroundColor: kBlackOlive.withOpacity(0.2),
      child: ValueListenableBuilder<RecorderStateEnum>(
          valueListenable: recorderController.recordButtonNotifier,
          builder: (context, recorderState, _) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
              ),
              height: 60.0,
              width: 60.0,
              child: FittedBox(
                child: FloatingActionButton(
                  heroTag: 'btn2',
                  backgroundColor: backgroundColor,
                  splashColor: kAntiqueWhite.withOpacity(0.2),
                  onPressed: recorderState == RecorderStateEnum.recorded
                      ? () => recorderController.restart()
                      : null,
                  elevation: 0.0,
                  child: Icon(
                    Icons.refresh,
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
