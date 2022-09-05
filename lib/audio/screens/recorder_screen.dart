import 'dart:io';

import 'package:bbk_final_ana/audio/controller/recorder_controller.dart';
import 'package:bbk_final_ana/audio/enums/recorder_enum.dart';
import 'package:bbk_final_ana/common/widgets/screen_basic_structure.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/constants/constants.dart';
import '../../messaging/chat/controller/chat_controller.dart';
import '../notifiers/recorder_progress_state.dart';

class RecorderScreen extends ConsumerStatefulWidget {
  const RecorderScreen({Key? key}) : super(key: key);
  static const String id = '/recorder';

  @override
  ConsumerState<RecorderScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<RecorderScreen> {
  late RecorderController _recorderController;

  @override
  void initState() {
    super.initState();
    initializeIntlPackage();
  }

  @override
  void didChangeDependencies() {
    _recorderController = ref.watch(recorderControllerProvider);
    _recorderController.initRecorder(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _recorderController.disposeRecorder();
    super.dispose();
  }

  void initializeIntlPackage() async {
    await initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return ScreenBasicStructure(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      child: Stack(
        children: [
          Positioned(
            top: screenHeight * 0.34,
            left: 0.0,
            right: 0.0,
            height: screenHeight * 0.56,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(24.0),
                  topLeft: Radius.circular(24.0),
                ),
                color: kGreenLight.withOpacity(0.8),
              ),
              alignment: Alignment.bottomRight,
              child: SizedBox(
                  height: 240.0,
                  child: Image.asset('assets/images/bottom_decoration3.png')),
            ),
          ),
          Positioned(
            top: screenHeight * 0.05,
            left: 0.0,
            right: 0.0,
            height: screenHeight * 0.6,
            child: const RecorderUI(),
          ),
        ],
      ),
    );
  }
}

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
    final chatController = ref.read(chatControllerProvider);

    void Function()? getButtonFunction(RecorderStateEnum recorderState) {
      if (recorderState != RecorderStateEnum.recorded) return null;
      return () {
        recorderController.sendRecordingData(
            title: 'My recording', author: 'Ana Castro', artUrl: kLogoUrl);
        final audioMetadata =
            recorderController.currentAudioMetadataNotifier.value;
        final audioFile = File.fromUri(Uri.parse(audioMetadata.url));
        chatController.sendAudioMessage(
            context: context,
            audioFile: audioFile,
            receiverId: '400HEskT5ARdIvCUGsIriEiaqA22',
            isGroupChat: false,
            metadata: audioMetadata);
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
