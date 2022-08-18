import 'package:bbk_final_ana/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/constants/constants.dart';
import '../../../common/screens/error_screen.dart';
import '../../../common/screens/loader_screen.dart';
import '../../../common/widgets/screen_basic_structure.dart';
import '../../chat/screens/chat_screen.dart';
import '../controller/select_contact_controller.dart';

class SelectUserContactScreen extends ConsumerWidget {
  const SelectUserContactScreen({Key? key}) : super(key: key);
  static const String id = '/select-user';

  void selectContact(
      WidgetRef ref, UserModel selectedUserContact, BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
        context,
        ChatScreen.id,
        arguments: {
          'name': selectedUserContact.name,
          'uid': selectedUserContact.uid,
          'isGroupChat': false,
          'profilePicture': selectedUserContact.profilePicture,
        },
        (route) => false);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenBasicStructure(
      appBar: AppBar(
        title: const Text(
          'Select contact',
          style: kTextStyleAppBarTitle,
        ),
      ),
      child: ref.watch(getUserContactsProvider).when(
          data: (userContactsList) => ListView.builder(
                itemCount: userContactsList.length,
                itemBuilder: (context, index) {
                  final userContact = userContactsList[index];
                  return InkWell(
                    onTap: () =>
                        selectContact(ref, userContactsList[index], context),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: Material(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0)),
                        color: Colors.white.withOpacity(0.2),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(
                                userContact.name,
                                style: const TextStyle(
                                    fontSize: 18.0, color: kBlackOlive),
                              ),
                              leading: CircleAvatar(
                                backgroundColor: kAntiqueWhite,
                                backgroundImage:
                                    NetworkImage(userContact.profilePicture),
                                radius: 30.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
          error: (err, trace) => ErrorScreen(error: err.toString()),
          loading: () => const LoaderScreen()),
    );
  }
}
