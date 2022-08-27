import 'dart:io';

import 'package:bbk_final_ana/audio/screens/library_screen.dart';
import 'package:bbk_final_ana/common/constants/constants.dart';
import 'package:bbk_final_ana/common/widgets/standar_circular_profile_avatar.dart';
import 'package:bbk_final_ana/common/widgets/standard_circular_progress_indicator.dart';
import 'package:bbk_final_ana/messaging/conversations/screens/conversations_screen.dart';
import 'package:bbk_final_ana/messaging/group/screens/create_group_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/controller/auth_controller.dart';
import '../../auth/screens/edit_user_info_screen.dart';
import '../../models/user_model.dart';
import 'circular_cached_network_image.dart';

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
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0),
              bottomLeft: Radius.circular(24.0))),
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
              ? CircularCachedNetworkImage(
                  imageUrl: user!.profilePicture,
                  radius: 42.0,
                )
              : const StandardCircularProfileAvatar(radius: 42.0),
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
