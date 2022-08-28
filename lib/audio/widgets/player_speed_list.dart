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
        const Padding(
          padding: EdgeInsets.only(left: 12.0, top: 24.0, bottom: 12.0),
          child: Text(
            'Change playback speed',
            style: TextStyle(
              fontSize: 18.0,
              color: kBlackOlive,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ValueListenableBuilder<double>(
          valueListenable: playerController.playerSpeedNotifier,
          builder: (context, speed, _) {
            return ListView.builder(
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
                });
          },
        ),
      ],
    );
  }
}
