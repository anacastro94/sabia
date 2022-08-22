import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/player_controller.dart';

class PreviousAudioButton extends ConsumerWidget {
  const PreviousAudioButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerController = ref.read(audioPlayerControllerProvider);
    return ValueListenableBuilder<bool>(
      valueListenable: playerController.isFirstAudioNotifier,
      builder: (context, isFirst, _) {
        return IconButton(
          onPressed:
              isFirst ? null : playerController.onPreviousAudioButtonPressed,
          icon: const Icon(Icons.skip_previous),
        );
      },
    );
  }
}
