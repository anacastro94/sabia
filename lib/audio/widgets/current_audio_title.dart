import 'package:bbk_final_ana/models/audio_metadata.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/constants/constants.dart';
import '../controller/player_controller.dart';

class CurrentAudioTitle extends ConsumerWidget {
  const CurrentAudioTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerController = ref.read(audioPlayerControllerProvider);
    return ValueListenableBuilder<AudioMetadata>(
      valueListenable: playerController.currentAudioMetadataNotifier,
      builder: (context, audioMetadata, _) {
        return Text(
          audioMetadata.title.toUpperCase(),
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
