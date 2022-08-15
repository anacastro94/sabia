import 'dart:io';

import 'package:bbk_final_ana/auth/controller/auth_controller.dart';
import 'package:bbk_final_ana/common/constants/constants.dart';
import 'package:bbk_final_ana/models/user_model.dart';
import 'package:bbk_final_ana/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

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
  bool isEditing = true;

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
    if (user == null) return;
    isEditing = false;
    nameController.text = user!.name;
    image = await _fileFromImageUrl(user!.profilePicture);
    setState(() {});
  }

  Future<File> _fileFromImageUrl(String url) async {
    final response = await http.get(Uri.parse(url));

    final documentDirectory = await getApplicationDocumentsDirectory();

    final file = File('${documentDirectory.path}/profile_pic.png');

    file.writeAsBytesSync(response.bodyBytes);

    return file;
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
      toggleEditingMode();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false);
    }
  }

  void toggleEditingMode() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ScreenBasicStructure(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              image == null
                  ? user == null
                      ? const CircleAvatar(
                          radius: 60.0,
                          backgroundColor: kAntiqueWhite,
                          backgroundImage:
                              AssetImage('assets/images/avatar.png'),
                        )
                      : CircleAvatar(
                          radius: 60.0,
                          backgroundColor: kAntiqueWhite,
                          backgroundImage: FileImage(image!),
                        )
                  : CircleAvatar(
                      radius: 60.0,
                      backgroundColor: kAntiqueWhite,
                      backgroundImage: FileImage(image!),
                    ),
              Positioned(
                bottom: -12.0,
                left: 66.0,
                child: isEditing
                    ? IconButton(
                        onPressed: selectImage,
                        icon: const Icon(
                          Icons.add_a_photo,
                          color: kBlackOlive,
                          size: 30.0,
                        ),
                      )
                    : Container(),
              ),
            ],
          ),
          Row(
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(24.0),
                  width: size.width * 0.85,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    enabled: isEditing,
                    controller: nameController,
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter you name'),
                  ),
                ),
              ),
              CircleAvatar(
                backgroundColor: kAntiqueWhite,
                child: IconButton(
                  color: kBlackOlive,
                  onPressed:
                      isEditing ? () => storeUserData() : toggleEditingMode,
                  icon: Icon(isEditing ? Icons.done : Icons.edit),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
