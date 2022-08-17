import 'package:bbk_final_ana/auth/controller/auth_controller.dart';
import 'package:bbk_final_ana/common/screens/loader_screen.dart';
import 'package:bbk_final_ana/common/widgets/screen_basic_structure.dart';
import 'package:bbk_final_ana/messaging/chat/widgets/bottom_chat_field.dart';
import 'package:bbk_final_ana/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/constants/constants.dart';
import '../widgets/chat_list.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({
    Key? key,
    required this.name,
    required this.uid,
    required this.isGroupChat,
    required this.profilePicture,
  }) : super(key: key);
  static const String id = '/chat';
  final String name;
  final String uid;
  final bool isGroupChat;
  final String profilePicture;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenBasicStructure(
      backgroundColor: kAntiqueWhite,
      appBar: AppBar(
        title: isGroupChat
            ? Text(name)
            : StreamBuilder<UserModel>(
                stream: ref.watch(authControllerProvider).getUserDataById(uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox();
                  }
                  return Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(profilePicture),
                        backgroundColor: kAntiqueWhite,
                      ),
                      const SizedBox(width: 24.0),
                      Column(
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          Text(
                            snapshot.data!.isOnline ? 'online' : 'offline',
                            style: const TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
        centerTitle: false,
      ),
      child: Column(
        children: [
          Expanded(
            child: ChatList(receiverId: uid, isGroupChat: isGroupChat), //TODO
          ),
          BottomChatField(isGroupChat: isGroupChat, receiverId: uid),
        ],
      ),
    );
  }
}
