import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/constants/constants.dart';
import '../../common/widgets/square_cached_network_image.dart';
import '../../models/audio_metadata.dart';
import '../controller/player_controller.dart';

class Playlist extends ConsumerWidget {
  const Playlist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerController = ref.read(audioPlayerControllerProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ListHeader(title: 'Now playing'),
        NowPlayingTile(playerController: playerController),
        const ListHeader(title: 'Playlist from your library'),
        ListViewPlaylist(playerController: playerController),
      ],
    );
  }
}

class ListViewPlaylist extends StatelessWidget {
  const ListViewPlaylist({
    Key? key,
    required this.playerController,
  }) : super(key: key);

  final AudioPlayerController playerController;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<AudioMetadata>>(
      valueListenable: playerController.playListNotifier,
      builder: (context, playlist, _) {
        return Expanded(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: playlist.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(
                    Icons.radio_button_unchecked,
                    color: kGrey,
                  ),
                  onTap: () => playerController.skipToQueueItem(index),
                  title: Text(playlist[index].title),
                  subtitle: Text(playlist[index].author),
                );
              }),
        );
      },
    );
  }
}

class NowPlayingTile extends StatelessWidget {
  const NowPlayingTile({
    Key? key,
    required this.playerController,
  }) : super(key: key);

  final AudioPlayerController playerController;

  @override
  Widget build(BuildContext context) {
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

class ListHeader extends StatelessWidget {
  const ListHeader({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, top: 24.0, bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18.0,
          color: kBlackOlive,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
