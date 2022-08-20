import 'dart:io';

import 'package:bbk_final_ana/audio/screens/library_screen.dart';
import 'package:bbk_final_ana/common/constants/constants.dart';
import 'package:bbk_final_ana/messaging/conversations/screens/conversations_screen.dart';
import 'package:bbk_final_ana/messaging/group/screens/create_group_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/controller/auth_controller.dart';
import '../../auth/screens/edit_user_info_screen.dart';
import '../../models/user_model.dart';

class DrawerMenu extends ConsumerWidget {
  const DrawerMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void logCurrentUserOut() {
      ref.read(authControllerProvider).logCurrentUserOut(context);
    }

    return Drawer(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      backgroundColor: kAntiqueWhite,
      child: ListView(
        children: [
          const StandardDrawerHeader(),
          ListTile(
            leading: const Icon(Icons.menu_book_outlined),
            title: const Text(
              'Library',
              style: kTextStyleMenuItem,
            ),
            onTap: () => Navigator.pushNamed(context, LibraryScreen.id),
          ),
          ListTile(
            leading: const Icon(Icons.comment),
            title: const Text(
              'Chat',
              style: kTextStyleMenuItem,
            ),
            onTap: () => Navigator.pushNamed(context, ConversationsScreen.id),
          ),
          ListTile(
            leading: const Icon(Icons.group_add),
            title: const Text(
              'Create group',
              style: kTextStyleMenuItem,
            ),
            onTap: () => Navigator.pushNamed(context, CreateGroupScreen.id),
          ),
          ListTile(
            leading: const Icon(Icons.manage_accounts),
            title: const Text(
              'Profile',
              style: kTextStyleMenuItem,
            ),
            onTap: () =>
                Navigator.pushNamed(context, EditUserInformationScreen.id),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text(
              'Logout',
              style: kTextStyleMenuItem,
            ),
            onTap: logCurrentUserOut,
          ),
        ],
      ),
    );
  }
}

class StandardDrawerHeader extends ConsumerStatefulWidget {
  const StandardDrawerHeader({Key? key}) : super(key: key);

  @override
  ConsumerState<StandardDrawerHeader> createState() =>
      _StandardDrawerHeaderState();
}

class _StandardDrawerHeaderState extends ConsumerState<StandardDrawerHeader> {
  UserModel? user;
  File? image;

  void getUserData() async {
    user = await ref.read(authControllerProvider).getCurrentUserData();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      child: Column(
        children: [
          user != null
              ? CircleAvatar(
                  radius: 42.0,
                  backgroundColor: kAntiqueWhite,
                  backgroundImage: NetworkImage(user!.profilePicture),
                )
              : const CircleAvatar(
                  radius: 42.0,
                  backgroundColor: kAntiqueWhite,
                  backgroundImage: AssetImage('assets/images/avatar.png'),
                ),
          const SizedBox(
            height: 12.0,
          ),
          Text(
            user?.name ?? '',
            style: const TextStyle(color: kBlackOlive, fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
