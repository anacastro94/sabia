import 'package:bbk_final_ana/messaging/chat/controller/chat_controller.dart';
import 'package:bbk_final_ana/models/chat_contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StreamTestWindow extends ConsumerWidget {
  const StreamTestWindow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) => Container(
        constraints: BoxConstraints(maxHeight: constraints.maxHeight),
        child: StreamBuilder<List<ChatContact>>(
          stream: ref.watch(chatControllerProvider).getChatContacts(),
          builder: (context, snapshot) {
            return Center(
              child: Text(
                snapshot.hasData.toString(),
                style: const TextStyle(fontSize: 24.0),
              ),
            );
          },
        ),
      ),
    );
  }
}
