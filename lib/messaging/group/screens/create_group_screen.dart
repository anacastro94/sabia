import 'dart:io';

import 'package:bbk_final_ana/common/widgets/screen_basic_structure.dart';
import 'package:bbk_final_ana/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/constants/constants.dart';
import '../controller/group_controller.dart';
import '../widgets/select_contacts_group.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);
  static const String id = '/create-group';

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  final TextEditingController groupNameController = TextEditingController();
  File? image;

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void createGroup() {
    if (groupNameController.text.trim().isNotEmpty && image != null) {
      ref.read(groupControllerProvider).createGroup(
            context,
            groupNameController.text.trim(),
            image!,
            ref.read(selectedGroupContacts),
          );
      ref.read(selectedGroupContacts.state).update((state) => []);
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    super.dispose();
    groupNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenBasicStructure(
      appBar: AppBar(
        title: const Text(
          'Create group',
          style: TextStyle(color: kBlackOlive),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.chevron_left,
            color: kBlackOlive,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createGroup,
        backgroundColor: kDarkOrange,
        child: const Icon(
          Icons.done,
          color: kAntiqueWhite,
        ),
      ),
      child: Flexible(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 24.0,
            ),
            Stack(
              children: [
                image == null
                    ? const CircleAvatar(
                        backgroundImage: AssetImage('assets/images/logo.png'),
                        radius: 60.0,
                        backgroundColor: kAntiqueWhite,
                      )
                    : CircleAvatar(
                        backgroundImage: FileImage(image!),
                        radius: 60.0,
                        backgroundColor: kAntiqueWhite,
                      ),
                Positioned(
                  bottom: -12.0,
                  left: 66.0,
                  child: IconButton(
                    onPressed: selectImage,
                    icon: const Icon(
                      Icons.add_a_photo,
                      color: kAntiqueWhite,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 24.0,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: groupNameController,
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Enter group name'),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(12.0),
              child: const Text(
                'Select contacts',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                  color: kAntiqueWhite,
                ),
              ),
            ),
            const SelectContactsGroup(),
          ],
        ),
      ),
    );
  }
}
