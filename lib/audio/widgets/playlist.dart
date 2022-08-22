import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/player_controller.dart';

class Playlist extends ConsumerWidget {
  const Playlist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerController = ref.read(audioPlayerControllerProvider);
    return Expanded(
      child: ValueListenableBuilder<List<String>>(
        valueListenable: playerController.playListNotifier,
        builder: (context, playlistTitles, _) {
          return ListView.builder(
              itemCount: playlistTitles.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(playlistTitles[index]),
                );
              });
        },
      ),
    );
  }
}
