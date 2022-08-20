import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:bbk_final_ana/audio/controller/player_controller.dart';
import 'package:bbk_final_ana/audio/enums/play_button_enum.dart';
import 'package:bbk_final_ana/common/constants/constants.dart';
import 'package:bbk_final_ana/common/widgets/screen_basic_structure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/widgets/standard_circular_progress_indicator.dart';
import '../provider/player_buttton_state_provider.dart';
import '../provider/progress_bar_state_provider.dart';

class PlayerScreen extends ConsumerStatefulWidget {
  const PlayerScreen({Key? key}) : super(key: key);
  static const String id = '/player';

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {
  final String storyTitle = 'A long story title';
  final String senderName = 'Sender Name';
  late final AudioPlayerController _playerController;
  late final StateController<PlayerProgressState>
      _playerProgressStateController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _playerController = ref.watch(audioPlayerControllerProvider);
    _playerProgressStateController =
        ref.watch(_playerController.playerProgressStateProvider.notifier);
  }

  @override
  void dispose() {
    super.dispose();
    _playerController.dispose();
  }

  Widget getPlayerButton() {
    switch (ref.watch(_playerController.playerButtonStateProvider)) {
      case PlayerButtonState.loading:
        return Container(
          margin: const EdgeInsets.all(8.0),
          width: 32.0,
          height: 32.0,
          child: const StandardCircularProgressIndicator(),
        );
      case PlayerButtonState.paused:
        return IconButton(
          icon: const Icon(Icons.play_arrow),
          iconSize: 32.0,
          onPressed: () {
            _playerController.play();
          },
        );
      case PlayerButtonState.playing:
        return IconButton(
          icon: const Icon(Icons.pause),
          iconSize: 32.0,
          onPressed: () {
            _playerController.pause();
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return ScreenBasicStructure(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      child: Stack(
        children: [
          Positioned(
            top: screenHeight * 0.3,
            left: 0.0,
            right: 0.0,
            height: screenHeight * 0.7,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.0),
                border: Border.all(
                  color: kGreenLight,
                  width: 2.0,
                ),
                color: kGreenLight,
              ),
            ),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            top: screenHeight * 0.1,
            height: screenHeight * 0.36,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(36.0),
                color: kAntiqueWhite,
              ),
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.1),
                  Text(
                    storyTitle.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: kBlackOlive,
                    ),
                  ),
                  Text(
                    senderName,
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: kGrey,
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 36.0),
                    child: Column(
                      children: [
                        StreamBuilder<PlayerProgressState>(
                          stream: _playerProgressStateController.stream,
                          builder: (context, snapshot) => ProgressBar(
                            progress: snapshot.data?.current ?? Duration.zero,
                            buffered: snapshot.data?.buffered ?? Duration.zero,
                            total: snapshot.data?.total ?? Duration.zero,
                            baseBarColor: kDarkOrange.withOpacity(0.2),
                            thumbColor: kDarkOrange,
                            bufferedBarColor: kDarkOrange.withOpacity(0.5),
                            progressBarColor: kDarkOrange,
                          ),
                        ),
                        getPlayerButton(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.02,
            left: (screenWidth - 120) * 0.5,
            right: (screenWidth - 120) * 0.5,
            height: 120,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.0),
                border: Border.all(
                  color: kAntiqueWhite,
                  width: 2.0,
                ),
                color: kGreenLight,
              ),
              child: const Center(
                child: CircleAvatar(
                  backgroundColor: kAntiqueWhite,
                  radius: 50.0,
                  child: CircleAvatar(
                    backgroundColor: kAntiqueWhite,
                    backgroundImage: AssetImage('assets/images/covers/c1.png'),
                    radius: 48.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
