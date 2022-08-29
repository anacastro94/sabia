import 'package:bbk_final_ana/audio/widgets/player_speed_list.dart';
import 'package:bbk_final_ana/audio/widgets/playlist.dart';
import 'package:bbk_final_ana/common/constants/constants.dart';
import 'package:bbk_final_ana/models/audio_metadata.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/player_controller.dart';
import 'favorite_icon.dart';

class PlayerBottomBar extends ConsumerWidget {
  const PlayerBottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerController = ref.read(audioPlayerControllerProvider);
    void onItemTapped(int index) {
      switch (index) {
        case (0):
          showModalBottomSheet(
            backgroundColor: Colors.white.withOpacity(0.9),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            context: context,
            builder: (context) => const PlayerSpeedList(),
          );
          break;
        case (1):
          break;
        case (2):
          playerController.addAudioToPlaylist();
          break;
        case (3):
          showModalBottomSheet(
            backgroundColor: Colors.white.withOpacity(0.9),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            context: context,
            builder: (context) => const Playlist(),
          );
          break;
      }
    }

    return BottomNavigationBar(
      elevation: 0.0,
      selectedItemColor: kBlackOlive,
      unselectedItemColor: kBlackOlive,
      onTap: onItemTapped,
      items: [
        BottomNavigationBarItem(
            icon: ValueListenableBuilder<double>(
              valueListenable: playerController.playerSpeedNotifier,
              builder: (context, speed, _) {
                return Text(
                  speed.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: kBlackOlive,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            label: '    x'),
        const BottomNavigationBarItem(
          icon: FavoriteIcon(),
          label: 'Favorite',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Add',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.featured_play_list_outlined),
          label: 'Playlist',
        ),
      ],
    );
  }
}
