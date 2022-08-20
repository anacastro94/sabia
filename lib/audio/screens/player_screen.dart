import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:bbk_final_ana/audio/controller/player_controller.dart';
import 'package:bbk_final_ana/audio/enums/play_button_enum.dart';
import 'package:bbk_final_ana/common/constants/constants.dart';
import 'package:bbk_final_ana/common/widgets/screen_basic_structure.dart';
import 'package:flutter/material.dart';

import '../../common/widgets/standard_circular_progress_indicator.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({Key? key}) : super(key: key);
  static const String id = '/player';

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final String storyTitle = 'A long story title';
  final String senderName = 'Sender Name';
  late final AudioPlayerController _playerController;

  @override
  void initState() {
    super.initState();
    _playerController = AudioPlayerController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _playerController.dispose();
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
                        ValueListenableBuilder(
                            valueListenable: _playerController.progressNotifier,
                            builder: (context, value, _) {
                              return ProgressBar(
                                progress: value.current,
                                buffered: value.buffered,
                                total: value.total,
                                onSeek: _playerController.seek,
                                baseBarColor: kDarkOrange.withOpacity(0.2),
                                thumbColor: kDarkOrange,
                                bufferedBarColor: kDarkOrange.withOpacity(0.5),
                                progressBarColor: kDarkOrange,
                              );
                            }),
                        ValueListenableBuilder<PlayerButtonState>(
                            valueListenable: _playerController.buttonNotifier,
                            builder: (context, value, _) {
                              switch (value) {
                                case PlayerButtonState.loading:
                                  return Container(
                                    margin: const EdgeInsets.all(8.0),
                                    width: 32.0,
                                    height: 32.0,
                                    child:
                                        const StandardCircularProgressIndicator(),
                                  );
                                case PlayerButtonState.paused:
                                  return IconButton(
                                    icon: const Icon(Icons.play_arrow),
                                    iconSize: 32.0,
                                    onPressed: _playerController.play,
                                  );
                                case PlayerButtonState.playing:
                                  return IconButton(
                                    icon: const Icon(Icons.pause),
                                    iconSize: 32.0,
                                    onPressed: _playerController.pause,
                                  );
                              }
                            }),
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
