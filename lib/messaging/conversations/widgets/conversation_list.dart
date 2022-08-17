import 'package:bbk_final_ana/messaging/chat/controller/chat_controller.dart';
import 'package:bbk_final_ana/messaging/chat/screens/chat_screen.dart';
import 'package:bbk_final_ana/models/chat_contact.dart';
import 'package:bbk_final_ana/models/group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../common/constants/constants.dart';
import '../../../common/screens/loader_screen.dart';
import 'no_active_conversations.dart';

class ConversationsList extends ConsumerWidget {
  const ConversationsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: Column(
          children: [
            Container(
              constraints: BoxConstraints(maxHeight: constraints.maxHeight),
              child: StreamBuilder<List<Group>>(
                stream: ref.watch(chatControllerProvider).getChatGroups(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LoaderScreen();
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var groupData = snapshot.data![index];
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, ChatScreen.id,
                                  arguments: {
                                    'name': groupData.name,
                                    'uid': groupData.groupId,
                                    'isGroupChat': true,
                                    'profilePicture': groupData.groupPicture,
                                  });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 9.0),
                              child: ListTile(
                                title: Text(
                                  groupData.name,
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    color: kBlackOlive,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Text(
                                    groupData.lastMessage,
                                    style: const TextStyle(fontSize: 15.0),
                                  ),
                                ),
                                leading: CircleAvatar(
                                  backgroundColor: kAntiqueWhite,
                                  backgroundImage:
                                      NetworkImage(groupData.groupPicture),
                                  radius: 30.0,
                                ),
                                trailing: Text(
                                  DateFormat.Hm().format(groupData.timeSent),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Divider(indent: 85.0)
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              constraints: BoxConstraints(maxHeight: constraints.maxHeight),
              child: StreamBuilder<List<ChatContact>>(
                  stream: ref.watch(chatControllerProvider).getChatContacts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const LoaderScreen();
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
                                Navigator.pushNamed(context, ChatScreen.id,
                                    arguments: {
                                      'name': chatContactData.name,
                                      'uid': chatContactData.contactId,
                                      'isGroupChat': false,
                                      'profilePicture':
                                          chatContactData.profilePicture,
                                    });
                              },
                              child: ListTile(
                                title: Text(
                                  chatContactData.name,
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.white,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Text(
                                    chatContactData.lastMessage,
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      color: kBlackOlive,
                                    ),
                                  ),
                                ),
                                leading: CircleAvatar(
                                  backgroundColor: kAntiqueWhite,
                                  backgroundImage: NetworkImage(
                                      chatContactData.profilePicture),
                                  radius: 30.0,
                                ),
                                trailing: Text(
                                  DateFormat.Hm()
                                      .format(chatContactData.timeSent),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.0,
                                  ),
                                ),
                              ),
                            ),
                            const Divider(indent: 85.0)
                          ],
                        );
                      },
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
