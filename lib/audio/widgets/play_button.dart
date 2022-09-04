import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/widgets/standard_circular_progress_indicator.dart';
import '../controller/player_controller.dart';
import '../enums/play_button_enum.dart';

class PlayButton extends ConsumerWidget {
  const PlayButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerController = ref.read(audioPlayerControllerProvider);
    return ValueListenableBuilder<PlayerStateEnum>(
        valueListenable: playerController.playButtonNotifier,
        builder: (context, value, _) {
          switch (value) {
            case PlayerStateEnum.loading:
              return Container(
                margin: const EdgeInsets.all(8.0),
                width: 32.0,
                height: 32.0,
                child: const StandardCircularProgressIndicator(),
              );
            case PlayerStateEnum.paused:
              return IconButton(
                icon: const Icon(Icons.play_arrow),
                iconSize: 32.0,
                onPressed: playerController.play,
              );
            case PlayerStateEnum.playing:
              return IconButton(
                icon: const Icon(Icons.pause),
                iconSize: 32.0,
                onPressed: playerController.pause,
              );
          }
        });
  }
}
