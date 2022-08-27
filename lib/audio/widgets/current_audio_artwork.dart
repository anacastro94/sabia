import 'package:bbk_final_ana/models/audio_metadata.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/constants/constants.dart';
import '../../common/widgets/circular_cached_network_image.dart';
import '../controller/player_controller.dart';

class CurrentAudioArtwork extends ConsumerWidget {
  const CurrentAudioArtwork({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerController = ref.read(audioPlayerControllerProvider);
    return ValueListenableBuilder<AudioMetadata>(
      valueListenable: playerController.currentAudioMetadataNotifier,
      builder: (context, audioMetadata, _) {
        return Center(
          child: CircleAvatar(
            backgroundColor: kAntiqueWhite,
            radius: 50.0,
            child: CircularCachedNetworkImage(
              imageUrl: audioMetadata.artwork,
              radius: 48.0,
            ),
          ),
        );
      },
    );
  }
}
