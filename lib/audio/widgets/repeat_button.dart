import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/player_controller.dart';
import '../enums/repeat_button_enum.dart';

class RepeatButton extends ConsumerWidget {
  const RepeatButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerController = ref.read(audioPlayerControllerProvider);
    return ValueListenableBuilder<RepeatState>(
      valueListenable: playerController.repeatButtonNotifier,
      builder: (context, value, _) {
        late final Icon icon;
        switch (value) {
          case RepeatState.off:
            icon = const Icon(Icons.repeat, color: Colors.grey);
            break;
          case RepeatState.repeatSong:
            icon = const Icon(Icons.repeat_one);
            break;
          case RepeatState.repeatPlaylist:
            icon = const Icon(Icons.repeat);
            break;
        }
        return IconButton(
          onPressed: playerController.onRepeatButtonPressed,
          icon: icon,
        );
      },
    );
  }
}
