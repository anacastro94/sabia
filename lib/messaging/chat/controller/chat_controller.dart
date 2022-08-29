import 'dart:io';

import 'package:bbk_final_ana/auth/controller/auth_controller.dart';
import 'package:bbk_final_ana/messaging/chat/repository/chat_repository.dart';
import 'package:bbk_final_ana/models/audio_metadata.dart';
import 'package:bbk_final_ana/models/chat_contact.dart';
import 'package:bbk_final_ana/models/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/enums/message_enum.dart';
import '../../../common/providers/message_reply_provider.dart';
import '../../../models/group.dart';

final chatControllerProvider = Provider((ref) {
  var chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(chatRepository: chatRepository, ref: ref);
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;
  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  Stream<List<ChatContact>> getChatContacts() {
    return chatRepository.getChatContacts();
  }

  Stream<List<Group>> getChatGroups() {
    return chatRepository.getChatGroups();
  }

  Stream<List<Message>> getChatStream(String receiverId) {
    return chatRepository.getChatStream(receiverId);
  }

  Stream<List<Message>> getGroupChatStream(String groupId) {
    return chatRepository.getGroupChatStream(groupId);
  }

  void sendTextMessage(
    BuildContext context,
    String text,
    String receiverId,
    bool isGroupChat,
  ) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData((value) =>
        chatRepository.sendTextMessage(
            context: context,
            text: text,
            receiverId: receiverId,
            sender: value!,
            messageReply: messageReply,
            isGroupChat: isGroupChat));
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  void sendAudioMessage(
    BuildContext context,
    File audioFile,
    String receiverId,
    MessageEnum messageEnum,
    bool isGroupChat,
    AudioMetadata metadata,
  ) {
    final messageReply = ref.read(messageReplyProvider);
    ref
        .read(userDataAuthProvider)
        .whenData((value) => chatRepository.sendAudioMessage(
              context: context,
              audioFile: audioFile,
              receiverId: receiverId,
              sender: value!,
              ref: ref,
              messageEnum: messageEnum,
              messageReply: messageReply,
              isGroupChat: isGroupChat,
              metadata: metadata,
            ));
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  void sendGifMessage(
    BuildContext context,
    String gifUrl,
    String receiverId,
    bool isGroupChat,
  ) {
    final messageReply = ref.read(messageReplyProvider);
    int gifUrlPartIndex = gifUrl.lastIndexOf('-') + 1;
    String gifUrlPart = gifUrl.substring(gifUrlPartIndex);
    String newGifUrl = 'https://i.giphy.com/media/$gifUrlPart/200.gif';
    ref.read(userDataAuthProvider).whenData((value) =>
        chatRepository.sendGifMessage(
            context: context,
            gifUrl: newGifUrl,
            receiverId: receiverId,
            sender: value!,
            messageReply: messageReply,
            isGroupChat: isGroupChat));
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  void setChatMessageSeen(
      BuildContext context, String senderId, String messageId) {
    chatRepository.setChatMessageSeen(
      context: context,
      senderId: senderId,
      messageId: messageId,
    );
  }
}
