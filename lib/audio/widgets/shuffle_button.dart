import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/player_controller.dart';

class ShuffleButton extends ConsumerWidget {
  const ShuffleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerController = ref.read(audioPlayerControllerProvider);
    return ValueListenableBuilder<bool>(
      valueListenable: playerController.isShuffleModeEnabledNotifier,
      builder: (context, isEnabled, _) {
        return IconButton(
          onPressed: playerController.onShuffleButtonPressed,
          icon: isEnabled
              ? const Icon(Icons.shuffle)
              : const Icon(
                  Icons.shuffle,
                  color: Colors.grey,
                ),
        );
      },
    );
  }
}
