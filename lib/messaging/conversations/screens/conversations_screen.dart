import 'package:bbk_final_ana/auth/controller/auth_controller.dart';
import 'package:bbk_final_ana/common/widgets/screen_basic_structure.dart';
import 'package:bbk_final_ana/messaging/group/screens/create_group_screen.dart';
import 'package:bbk_final_ana/messaging/select_contacts/screens/select_contact_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/constants/constants.dart';
import '../widgets/conversation_list.dart';

class ConversationsScreen extends ConsumerStatefulWidget {
  const ConversationsScreen({Key? key}) : super(key: key);
  static const String id = '/conversations';

  @override
  ConsumerState<ConversationsScreen> createState() =>
      _ConversationsScreenState();
}

class _ConversationsScreenState extends ConsumerState<ConversationsScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // The following code update the user status (online/offline)
    // when the app is open, paused, closed.
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserState(true);
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
        ref.read(authControllerProvider).setUserState(false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBasicStructure(
      appBar: AppBar(
        title: const Text(
          'Chats',
          style: TextStyle(color: kBlackOlive),
        ),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.chevron_left,
            color: kBlackOlive,
          ),
        ),
        actions: [
          PopupMenuButton(
            icon: const Icon(
              Icons.more_vert,
              color: kBlackOlive,
            ),
            color: kAntiqueWhite,
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () => Future(
                    () => Navigator.pushNamed(context, CreateGroupScreen.id)),
                child: const Text(
                  'Create group',
                  style: TextStyle(color: kBlackOlive),
                ),
              ),
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.pushNamed(context, SelectContactScreen.id);
        },
        backgroundColor: kDarkOrange,
        child: const Icon(
          Icons.comment,
          color: kAntiqueWhite,
        ),
      ),
      child: const ConversationsList(), //
    );
  }
}
