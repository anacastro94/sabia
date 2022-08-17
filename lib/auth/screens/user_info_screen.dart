import 'dart:io';

import 'package:bbk_final_ana/auth/controller/auth_controller.dart';
import 'package:bbk_final_ana/common/constants/constants.dart';
import 'package:bbk_final_ana/models/user_model.dart';
import 'package:bbk_final_ana/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/widgets/screen_basic_structure.dart';
import '../../screens/home_screen.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  const UserInformationScreen({Key? key}) : super(key: key);
  static const String id = '/user-information';

  @override
  ConsumerState<UserInformationScreen> createState() =>
      _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  final TextEditingController nameController = TextEditingController();
  File? image;
  UserModel? user;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void getUserData() async {
    user = await ref.read(authControllerProvider).getCurrentUserData();
  }

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void storeUserData() async {
    String name = nameController.text.trim();
    if (name.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .saveUserDataToFirebase(context, name, image);
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ScreenBasicStructure(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                image == null
                    ? const CircleAvatar(
                        radius: 60.0,
                        backgroundColor: kAntiqueWhite,
                        backgroundImage: AssetImage('assets/images/avatar.png'),
                      )
                    : CircleAvatar(
                        radius: 60.0,
                        backgroundColor: kAntiqueWhite,
                        backgroundImage: FileImage(image!),
                      ),
                Positioned(
                  bottom: -12.0,
                  left: 66.0,
                  child: IconButton(
                    onPressed: selectImage,
                    icon: const Icon(
                      Icons.add_a_photo,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 24.0,
            ),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(24.0),
                  width: size.width * 0.85,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: nameController,
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter you name'),
                  ),
                ),
                Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(24.0),
                  child: CircleAvatar(
                    backgroundColor: kDarkOrange,
                    radius: 24.0,
                    child: IconButton(
                      color: kAntiqueWhite,
                      onPressed: () => storeUserData(),
                      icon: const Icon(Icons.done),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
