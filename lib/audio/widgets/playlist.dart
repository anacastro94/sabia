import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/constants/constants.dart';
import '../../common/widgets/square_cached_network_image.dart';
import '../../models/audio_metadata.dart';
import '../controller/player_controller.dart';
import 'list_header.dart';

class Playlist extends StatelessWidget {
  const Playlist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        ListHeader(title: 'Now playing'),
        NowPlayingTile(),
        ListHeader(title: 'Playlist from your library'),
        ListViewPlaylist(),
      ],
    );
  }
}

class ListViewPlaylist extends ConsumerWidget {
  const ListViewPlaylist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerController = ref.read(audioPlayerControllerProvider);
    return ValueListenableBuilder<List<AudioMetadata>>(
      valueListenable: playerController.playListNotifier,
      builder: (context, playlist, _) {
        return Expanded(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: playlist.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () => playerController.skipToQueueItem(index),
                  title: Text(playlist[index].title),
                  subtitle: Text(playlist[index].author),
                  trailing: IconButton(
                      onPressed: () =>
                          playerController.removeAudioFromPlaylist(index),
                      icon: const Icon(
                        Icons.remove_circle,
                        color: Colors.red,
                      )),
                );
              }),
        );
      },
    );
  }
}

class NowPlayingTile extends ConsumerWidget {
  const NowPlayingTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerController = ref.read(audioPlayerControllerProvider);
    return ValueListenableBuilder<AudioMetadata>(
      valueListenable: playerController.currentAudioMetadataNotifier,
      builder: (context, audioMetadata, _) {
        return ListTile(
          leading: SquareCachedNetworkImage(
            imageUrl: audioMetadata.artUrl,
            side: 40.0,
          ),
          title: Text(
            audioMetadata.title,
            style: const TextStyle(fontSize: 16.0, color: kBlackOlive),
          ),
          subtitle: Text(
            audioMetadata.author,
            style: const TextStyle(
              color: kGrey,
            ),
          ),
        );
      },
    );
  }
}
