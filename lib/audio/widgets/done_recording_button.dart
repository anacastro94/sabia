import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/constants/constants.dart';
import '../controller/recorder_controller.dart';
import '../enums/recorder_enum.dart';
import '../screens/author_title_cover_screen.dart';

class DoneRecordingButton extends ConsumerWidget {
  const DoneRecordingButton({
    Key? key,
    this.iconColor = kBlackOlive,
    this.backgroundColor = kAntiqueWhite,
  }) : super(key: key);
  final Color iconColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recorderController = ref.read(recorderControllerProvider);

    void Function()? getButtonFunction(RecorderStateEnum recorderState) {
      if (recorderState != RecorderStateEnum.recorded) return null;
      return () {
        recorderController.restart();
        Navigator.pushNamed(context, AuthorTitleCoverScreen.id);

        //TODO: Move to send to screen
        // final audioMetadata =
        //     recorderController.currentAudioMetadataNotifier.value;
        // final audioFile = File.fromUri(Uri.parse(audioMetadata.url));
        // chatController.sendAudioMessage(
        //     context: context,
        //     audioFile: audioFile,
        //     receiverId: '400HEskT5ARdIvCUGsIriEiaqA22',
        //     isGroupChat: false,
        //     metadata: audioMetadata);
      };
    }

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
                  heroTag: 'btn3',
                  backgroundColor: backgroundColor,
                  splashColor: kAntiqueWhite.withOpacity(0.2),
                  onPressed: getButtonFunction(recorderState),
                  elevation: 0.0,
                  child: Icon(
                    Icons.done,
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
