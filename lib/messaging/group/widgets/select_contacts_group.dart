import 'package:bbk_final_ana/common/constants/constants.dart';
import 'package:bbk_final_ana/common/screens/error_screen.dart';
import 'package:bbk_final_ana/common/screens/loader_screen.dart';
import 'package:bbk_final_ana/messaging/select_contacts/controller/select_contact_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedGroupContacts = StateProvider<List<Contact>>((ref) => []);

class SelectContactsGroup extends ConsumerStatefulWidget {
  const SelectContactsGroup({Key? key}) : super(key: key);

  @override
  ConsumerState<SelectContactsGroup> createState() =>
      _SelectContactsGroupState();
}

class _SelectContactsGroupState extends ConsumerState<SelectContactsGroup> {
  List<int> selectedContactsIndex = [];

  void selectContact(int index, Contact contact) {
    if (selectedContactsIndex.contains(index)) {
      selectedContactsIndex.remove(index);
    } else {
      selectedContactsIndex.add(index);
    }
    setState(() {});
    ref
        .read(selectedGroupContacts.state)
        .update((state) => [...state, contact]);
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getContactsProvider).when(
        data: (contactsList) => Expanded(
              child: ListView.builder(
                itemCount: contactsList.length,
                itemBuilder: (context, index) {
                  final contact = contactsList[index];
                  return InkWell(
                    onTap: () => selectContact(index, contact),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 3.0),
                      child: ListTile(
                        tileColor: kAntiqueWhite,
                        title: Text(
                          contact.displayName,
                          style: const TextStyle(
                              fontSize: 18.0, color: kBlackOlive),
                        ),
                        leading: selectedContactsIndex.contains(index)
                            ? const Icon(
                                Icons.check_circle,
                                color: kDarkOrange,
                              )
                            : const Icon(
                                Icons.radio_button_unchecked,
                                color: kDarkOrange,
                              ),
                      ),
                    ),
                  );
                },
              ),
            ),
        error: (err, trace) => ErrorScreen(error: err.toString()),
        loading: () => const LoaderScreen());
  }
}
