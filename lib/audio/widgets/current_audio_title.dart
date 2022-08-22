import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/constants/constants.dart';
import '../controller/player_controller.dart';

class CurrentAudioTitle extends ConsumerWidget {
  const CurrentAudioTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerController = ref.read(audioPlayerControllerProvider);
    return ValueListenableBuilder<String>(
      valueListenable: playerController.currentAudioTitleNotifier,
      builder: (context, title, _) {
        return Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: kBlackOlive,
          ),
        );
      },
    );
  }
}
