import 'package:bbk_final_ana/audio/controller/player_controller.dart';
import 'package:bbk_final_ana/audio/widgets/current_audio_title.dart';
import 'package:bbk_final_ana/common/constants/constants.dart';
import 'package:bbk_final_ana/common/widgets/screen_basic_structure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/add_remove_to_playlist_buttons.dart';
import '../widgets/audio_control_buttons.dart';
import '../widgets/audio_progress_bar.dart';
import '../widgets/current_audio_artwork.dart';
import '../widgets/current_audio_author.dart';
import '../widgets/player_bottom_bar.dart';

class PlayerScreen extends ConsumerStatefulWidget {
  const PlayerScreen({Key? key}) : super(key: key);
  static const String id = '/player';

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {
  final String senderName =
      'Sender Name'; //TODO: Replace by controller pattern (same for the title)
  late final AudioPlayerController _playerController;

  @override
  void initState() {
    super.initState();
    _playerController = ref.read(audioPlayerControllerProvider);
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
      bottomNavigationBar: const PlayerBottomBar(),
      child: Stack(
        children: [
          Positioned(
            top: screenHeight * 0.3,
            left: 0.0,
            right: 0.0,
            height: screenHeight * 0.6,
            child: Container(
              decoration: const BoxDecoration(
                color: kGreenLight,
              ),
              alignment: Alignment.bottomCenter,
              //child: const AddRemoveToPlaylist(),
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
                  const CurrentAudioTitle(),
                  const CurrentAudioAuthorSubtitle(),
                  const SizedBox(height: 24.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 36.0),
                    child: Column(
                      children: const [
                        AudioProgressBar(),
                        AudioControlButtons(),
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
              child: const CurrentAudioArtwork(),
            ),
          ),
        ],
      ),
    );
  }
}
