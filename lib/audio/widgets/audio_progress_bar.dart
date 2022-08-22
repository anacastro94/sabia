import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/constants/constants.dart';
import '../controller/player_controller.dart';

class AudioProgressBar extends ConsumerWidget {
  const AudioProgressBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerController = ref.read(audioPlayerControllerProvider);
    return ValueListenableBuilder(
        valueListenable: playerController.progressNotifier,
        builder: (context, value, _) {
          return ProgressBar(
            progress: value.current,
            buffered: value.buffered,
            total: value.total,
            onSeek: playerController.seek,
            baseBarColor: kDarkOrange.withOpacity(0.2),
            thumbColor: kDarkOrange,
            bufferedBarColor: kDarkOrange.withOpacity(0.5),
            progressBarColor: kDarkOrange,
          );
        });
  }
}
