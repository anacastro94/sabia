import 'package:bbk_final_ana/audio/widgets/playlist.dart';
import 'package:bbk_final_ana/common/constants/constants.dart';
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
      child: Container(
        decoration: const BoxDecoration(
          color: kGreenLight,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.0),
            topRight: Radius.circular(12.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: playerController.addAudioToPlaylist,
              icon: const Icon(Icons.add),
            ),
            IconButton(
              onPressed: playerController.removeAudioFromPlaylist,
              icon: const Icon(Icons.remove),
            ),
            IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => const Playlist(),
                  );
                },
                icon: const Icon(
                  Icons.featured_play_list_outlined,
                ))
          ],
        ),
      ),
    );
  }
}
