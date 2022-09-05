import 'dart:io';

import 'package:bbk_final_ana/audio/controller/recorded_audio_handler.dart';
import 'package:bbk_final_ana/common/widgets/screen_basic_structure.dart';
import 'package:bbk_final_ana/models/user_model.dart';
import 'package:bbk_final_ana/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/constants/constants.dart';
import '../../common/widgets/field_title.dart';
import '../../messaging/chat/controller/chat_controller.dart';
import '../../messaging/group/widgets/select_user_contact_group.dart';
import 'initial_decision_screen.dart';
import 'library_screen.dart';

class SendToScreen extends ConsumerWidget {
  const SendToScreen({Key? key}) : super(key: key);
  static const String id = '/send-to';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordedAudioHandler = ref.read(recordedAudioHandlerProvider);
    final chatController = ref.read(chatControllerProvider);
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    void sendRecording() {
      List<UserModel> selectedUsers = ref.read(selectedGroupUserContacts);
      if (selectedUsers.isEmpty) return;
      try {
        final path = recordedAudioHandler.audioMetadata.url;
        final audioFile = File.fromUri(Uri.parse(path));
        for (var user in selectedUsers) {
          chatController.sendAudioMessage(
              context: context,
              audioFile: audioFile,
              receiverId: user.uid,
              isGroupChat: false,
              metadata: recordedAudioHandler.audioMetadata);
        }
        ref.read(selectedGroupUserContacts.state).update((state) => []);
        Navigator.pushNamed(context, LibraryScreen.id);
      } catch (e) {
        showSnackBar(context: context, content: e.toString());
      }
    }

    return ScreenBasicStructure(
      backgroundColor: kGreenLight,
      appBar: AppBar(
        title: const Text('Send story to'),
        backgroundColor: kGreenOlivine,
      ),
      floatingActionButton: FloatingActionButton(
          heroTag: 'btn5',
          backgroundColor: kDarkOrange,
          onPressed: sendRecording,
          child: const Icon(
            Icons.send,
            color: kAntiqueWhite,
          )),
      child: Stack(
        children: [
          Positioned(
            top: screenHeight * 0.0,
            left: 0.0,
            right: 0.0,
            height: screenHeight * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: screenWidth * 0.20),
                    SizedBox(
                      height: screenHeight * 0.3,
                      child: Image.asset(
                          'assets/images/bottom_vertical_decoration1.png'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: const [
              //Text(recordedAudioHandler.audioMetadata.toMap().toString()),
              SizedBox(height: 24.0),
              FieldTitle(title: 'Select recipients'),
              SizedBox(height: 24.0),
              SelectUserContactsGroup(),
            ],
          ),
        ],
      ),
    );
  }
}
