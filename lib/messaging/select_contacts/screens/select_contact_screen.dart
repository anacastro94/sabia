import 'package:bbk_final_ana/common/constants/constants.dart';
import 'package:bbk_final_ana/common/screens/error_screen.dart';
import 'package:bbk_final_ana/common/screens/loader_screen.dart';
import 'package:bbk_final_ana/common/widgets/screen_basic_structure.dart';
import 'package:bbk_final_ana/messaging/select_contacts/controller/select_contact_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectContactScreen extends ConsumerWidget {
  const SelectContactScreen({Key? key}) : super(key: key);
  static const String id = '/select-contact';

  void selectContact(
      WidgetRef ref, Contact selectedContact, BuildContext context) {
    ref
        .read(selectedContactControllerProvider)
        .selectContact(selectedContact, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenBasicStructure(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.chevron_left,
            color: kBlackOlive,
          ),
        ),
        title: const Text(
          'Select contact',
          style: TextStyle(color: kBlackOlive),
        ),
      ),
      child: ref.watch(getContactsProvider).when(
          data: (contactsList) => ListView.builder(
                itemCount: contactsList.length,
                itemBuilder: (context, index) {
                  final contact = contactsList[index];
                  return InkWell(
                    onTap: () => selectContact(ref, contact, context),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ListTile(
                        title: Text(
                          contact.displayName,
                          style: const TextStyle(fontSize: 18.0),
                        ),
                        leading: contact.photo == null
                            ? null
                            : CircleAvatar(
                                backgroundColor: kAntiqueWhite,
                                backgroundImage: MemoryImage(contact.photo!),
                                radius: 30.0,
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
