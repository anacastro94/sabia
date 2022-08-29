import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/audio_metadata.dart';
import '../controller/player_controller.dart';

class FavoriteIcon extends ConsumerWidget {
  const FavoriteIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerController = ref.read(audioPlayerControllerProvider);
    return ValueListenableBuilder<AudioMetadata>(
        valueListenable: playerController.currentAudioMetadataNotifier,
        builder: (context, metadata, _) {
          return Icon(
            metadata.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: Colors.redAccent,
          );
        });
  }
}
