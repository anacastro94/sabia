import 'package:bbk_final_ana/audio/widgets/play_button.dart';
import 'package:bbk_final_ana/audio/widgets/previous_audio_button.dart';
import 'package:bbk_final_ana/audio/widgets/repeat_button.dart';
import 'package:bbk_final_ana/audio/widgets/shuffle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/player_controller.dart';
import 'next_audio_button.dart';

class AudioControlButtons extends StatelessWidget {
  const AudioControlButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          RepeatButton(),
          PreviousAudioButton(),
          PlayButton(),
          NextAudioButton(),
          ShuffleButton(),
        ],
      ),
    );
  }
}
