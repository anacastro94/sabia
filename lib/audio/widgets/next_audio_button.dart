import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/player_controller.dart';

class NextAudioButton extends ConsumerWidget {
  const NextAudioButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerController = ref.read(audioPlayerControllerProvider);
    return ValueListenableBuilder<bool>(
      valueListenable: playerController.isLastAudioNotifier,
      builder: (context, isLast, _) {
        return IconButton(
          onPressed: isLast ? null : playerController.onNextAudioButtonPressed,
          icon: const Icon(Icons.skip_next),
        );
      },
    );
  }
}
