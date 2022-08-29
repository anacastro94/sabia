import 'package:bbk_final_ana/audio/widgets/list_header.dart';
import 'package:bbk_final_ana/common/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/player_controller.dart';

class PlayerSpeedList extends ConsumerWidget {
  const PlayerSpeedList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerController = ref.read(audioPlayerControllerProvider);
    final speedOptions = [0.5, 0.8, 1.0, 1.2, 1.5, 2.0];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ListHeader(title: 'Change playback speed'),
        ValueListenableBuilder<double>(
          valueListenable: playerController.playerSpeedNotifier,
          builder: (context, speed, _) {
            return Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: speedOptions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () =>
                          playerController.setPlayerSpeed(speedOptions[index]),
                      title: Text(
                        '${speedOptions[index].toStringAsFixed(1)}x',
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: kBlackOlive,
                        ),
                      ),
                      trailing: speedOptions[index] == speed
                          ? const Icon(
                              Icons.check,
                              color: kDarkOrange,
                            )
                          : null,
                    );
                  }),
            );
          },
        ),
      ],
    );
  }
}
