import 'package:bbk_final_ana/audio/repository/playlist_repository.dart';
import 'package:bbk_final_ana/common/widgets/screen_basic_structure.dart';
import 'package:bbk_final_ana/models/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StreamTestScreen extends ConsumerWidget {
  const StreamTestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlistRepository = ref.read(playListRepositoryProvider2);
    return ScreenBasicStructure(
      child: StreamBuilder<List<Message>>(
          stream: playlistRepository.getAudioMessagesStream(),
          builder: (context, messages) {
            var message = messages.hasData
                ? messages.data![0].metadata!.url
                : 'deu merda';
            return Center(
              child: Text(message),
            );
          }),
    );
  }
}
