import 'package:bbk_final_ana/common/enums/message_enum.dart';
import 'package:bbk_final_ana/common/providers/message_reply_provider.dart';
import 'package:bbk_final_ana/common/screens/loader_screen.dart';
import 'package:bbk_final_ana/messaging/chat/controller/chat_controller.dart';
import 'package:bbk_final_ana/messaging/chat/widgets/my_message_card.dart';
import 'package:bbk_final_ana/messaging/chat/widgets/sender_message_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/message.dart';

class ChatList extends ConsumerStatefulWidget {
  const ChatList({
    Key? key,
    required this.receiverId,
    required this.isGroupChat,
  }) : super(key: key);
  final String receiverId;
  final bool isGroupChat;

  @override
  ConsumerState<ChatList> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageScrollController = ScrollController();
  late final Stream<List<Message>> messageStream;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    messageStream = widget.isGroupChat
        ? ref.read(chatControllerProvider).getGroupChatStream(widget.receiverId)
        : ref.read(chatControllerProvider).getChatStream(widget.receiverId);
  }

  @override
  void dispose() {
    super.dispose();
    messageScrollController.dispose();
  }

  void onMessageSwipe(String message, bool isMe, MessageEnum messageEnum) {
    ref
        .read(messageReplyProvider.state)
        .update((state) => MessageReply(message, isMe, messageEnum));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
      stream: messageStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoaderScreen();
        }

        SchedulerBinding.instance.addPostFrameCallback((_) {
          messageScrollController
              .jumpTo(messageScrollController.position.maxScrollExtent);
        });

        if (!snapshot.hasData) return const SizedBox(); //TODO: No messages

        return ListView.builder(
          controller: messageScrollController,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final messageData = snapshot.data![index];
            var timeSent = DateFormat.Hm().format(messageData.timeSent);
            if (!messageData.isSeen &&
                (messageData.receiverId == firebaseAuth.currentUser!.uid)) {
              ref.read(chatControllerProvider).setChatMessageSeen(
                    context,
                    widget.receiverId,
                    messageData.messageId,
                  );
            }
            if (messageData.senderId == firebaseAuth.currentUser!.uid) {
              return MyMessageCard(
                  message: messageData.text,
                  date: timeSent,
                  type: messageData.type,
                  onLeftSwipe: () => onMessageSwipe(
                        messageData.text,
                        true,
                        messageData.type,
                      ),
                  repliedText: messageData.repliedMessage,
                  userName: messageData.repliedTo,
                  repliedMessageType: messageData.repliedMessageType,
                  isSeen: messageData.isSeen);
            }
            return SenderMessageCard(
                message: messageData.text,
                date: timeSent,
                type: messageData.type,
                onRightSwipe: () => onMessageSwipe(
                      messageData.text,
                      false,
                      messageData.type,
                    ),
                repliedText: messageData.repliedMessage,
                userName: messageData.repliedTo,
                repliedMessageType: messageData.repliedMessageType);
          },
        );
      },
    );
  }
}
