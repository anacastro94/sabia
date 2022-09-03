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

import '../../../auth/controller/auth_controller.dart';
import '../../../models/message.dart';
import '../../../models/user_model.dart';

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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    messageStream = widget.isGroupChat
        ? ref
            .watch(chatControllerProvider)
            .getGroupChatStream(widget.receiverId)
        : ref.watch(chatControllerProvider).getChatStream(widget.receiverId);
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
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Container(
            constraints: BoxConstraints(maxHeight: constraints.maxHeight),
            child: StreamBuilder<List<Message>>(
              stream: messageStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoaderScreen();
                }
                // To scroll down to the most recent message when it is received
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  messageScrollController
                      .jumpTo(messageScrollController.position.maxScrollExtent);
                });

                return ListView.builder(
                  shrinkWrap: true,
                  controller: messageScrollController,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final messageData = snapshot.data![index];
                    var timeSent = DateFormat.Hm().format(messageData.timeSent);
                    if (!messageData.isSeen &&
                        (messageData.receiverId ==
                            firebaseAuth.currentUser!.uid)) {
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
                          repliedTo: messageData.repliedTo,
                          repliedMessageType: messageData.repliedMessageType,
                          isSeen: messageData.isSeen);
                    }
                    return StreamBuilder<UserModel>(
                        stream: ref
                            .watch(authControllerProvider)
                            .getUserDataById(messageData.senderId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox();
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
                            repliedTo: messageData.repliedTo,
                            repliedMessageType: messageData.repliedMessageType,
                            isGroupChat: widget.isGroupChat,
                            senderName: snapshot.data!.name,
                          );
                        });
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
