import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/player_controller.dart';

class AddRemoveToPlaylist extends ConsumerWidget {
  const AddRemoveToPlaylist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerController = ref.read(audioPlayerControllerProvider);
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            onPressed: playerController.addSong,
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: playerController.removeSong,
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
