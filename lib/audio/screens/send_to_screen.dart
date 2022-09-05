import 'package:bbk_final_ana/audio/controller/recorded_audio_handler.dart';
import 'package:bbk_final_ana/common/widgets/screen_basic_structure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../messaging/chat/controller/chat_controller.dart';

class SendToScreen extends ConsumerWidget {
  const SendToScreen({Key? key}) : super(key: key);
  static const String id = '/send-to';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordedAudioHandler = ref.read(recordedAudioHandlerProvider);
    final chatController = ref.read(chatControllerProvider);
    return ScreenBasicStructure(
      appBar: AppBar(
        title: const Text('Send story to'),
        backgroundColor: Colors.transparent,
      ),
      child: SizedBox(
        child: Text(recordedAudioHandler.audioMetadata.artUrl),
      ),
    );
  }
}
