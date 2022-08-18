import 'package:bbk_final_ana/common/constants/constants.dart';
import 'package:bbk_final_ana/common/screens/error_screen.dart';
import 'package:bbk_final_ana/messaging/select_contacts/controller/select_contact_controller.dart';
import 'package:bbk_final_ana/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedGroupUserContacts = StateProvider<List<UserModel>>((ref) => []);

class SelectUserContactsGroup extends ConsumerStatefulWidget {
  const SelectUserContactsGroup({Key? key}) : super(key: key);

  @override
  ConsumerState<SelectUserContactsGroup> createState() =>
      _SelectContactsGroupState();
}

class _SelectContactsGroupState extends ConsumerState<SelectUserContactsGroup> {
  List<int> selectedContactsIndex = [];

  void selectContact(int index, UserModel contact) {
    if (selectedContactsIndex.contains(index)) {
      selectedContactsIndex.remove(index);
    } else {
      selectedContactsIndex.add(index);
    }
    setState(() {});
    ref
        .read(selectedGroupUserContacts.state)
        .update((state) => [...state, contact]);
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getUserContactsProvider).when(
          data: (userContactsList) => LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(maxHeight: constraints.maxHeight),
                child: ListView.builder(
                  clipBehavior: Clip.hardEdge,
                  shrinkWrap: true,
                  itemCount: userContactsList.length,
                  itemBuilder: (context, index) {
                    final userContact = userContactsList[index];
                    return InkWell(
                      onTap: () => selectContact(index, userContact),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 3.0),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0)),
                          tileColor: Colors.white.withOpacity(0.2),
                          title: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: kAntiqueWhite,
                                backgroundImage:
                                    NetworkImage(userContact.profilePicture),
                                radius: 18.0,
                              ),
                              const SizedBox(width: 12.0),
                              Text(
                                userContact.name,
                                style: const TextStyle(
                                    fontSize: 18.0, color: kBlackOlive),
                              ),
                            ],
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
            ),
          ),
          error: (err, trace) => ErrorScreen(error: err.toString()),
          loading: () => const CircularProgressIndicator(
            backgroundColor: kAntiqueWhite,
            color: kDarkOrange,
          ),
        );
  }
}
