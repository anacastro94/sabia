import 'package:bbk_final_ana/messaging/chat/controller/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/constants/constants.dart';
import '../../../common/screens/loader_screen.dart';
import '../../../landing/screens/welcome_screen.dart';
import '../../../models/group.dart';
import 'no_active_conversations.dart';

class ConversationsListView extends ConsumerStatefulWidget {
  const ConversationsListView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConversationsListView> createState() =>
      _ConversationsListViewState();
}

class _ConversationsListViewState extends ConsumerState<ConversationsListView> {
  late Stream<List<Group>> groupChatStream;

  @override
  void initState() {
    super.initState();
    groupChatStream = ref.watch(chatControllerProvider).getChatGroups();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          StreamBuilder<List<Group>>(
            stream: groupChatStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoaderScreen();
              }
              if (!snapshot.hasData) {
                return const NoActiveConversationsMessage();
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var chatContactData = snapshot.data![index];
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, WelcomeScreen.id); //TODO: Chat screen
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: ListTile(
                            title: Text(
                              chatContactData.name,
                              style: const TextStyle(
                                fontSize: 18.0,
                                color: kBlackOlive,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Text(chatContactData
                                  .lastMessage), // TODO: Change for chatContactData.lastMessage
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }
}
