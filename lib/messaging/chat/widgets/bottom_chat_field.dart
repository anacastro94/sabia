import 'package:bbk_final_ana/common/constants/constants.dart';
import 'package:bbk_final_ana/messaging/chat/controller/chat_controller.dart';
import 'package:bbk_final_ana/messaging/chat/widgets/message_reply_preview.dart';
import 'package:bbk_final_ana/utils/utils.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/providers/message_reply_provider.dart';

class BottomChatField extends ConsumerStatefulWidget {
  const BottomChatField({
    Key? key,
    required this.isGroupChat,
    required this.receiverId,
  }) : super(key: key);
  final String receiverId;
  final bool isGroupChat;

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isShownSendButton = false;
  final TextEditingController messageController = TextEditingController();
  bool isShownEmojiContainer = false;
  FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  void sendTextMessage() async {
    if (isShownSendButton) {
      ref.read(chatControllerProvider).sendTextMessage(
            context,
            messageController.text.trim(),
            widget.receiverId,
            widget.isGroupChat,
          );
      setState(() {
        messageController.text = '';
      });
    }
  }

  void selectGif() async {
    final gif = await pickGif(context);
    if (gif != null) {
      if (!mounted) return;
      ref.read(chatControllerProvider).sendGifMessage(
            context,
            gif.url,
            widget.receiverId,
            widget.isGroupChat,
          );
    }
  }

  void hideEmojiContainer() {
    setState(() {
      isShownEmojiContainer = false;
    });
  }

  void showEmojiContainer() {
    setState(() {
      isShownEmojiContainer = true;
    });
  }

  void showKeyboard() => focusNode.requestFocus();
  void hideKeyboard() => focusNode.unfocus();

  void toggleEmojiKeyboardContainer() {
    if (isShownEmojiContainer) {
      showKeyboard();
      hideEmojiContainer();
    } else {
      hideKeyboard();
      showEmojiContainer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final messageReply = ref.watch(messageReplyProvider);
    final isShownMessageReply = messageReply != null;
    return Column(
      children: [
        isShownMessageReply ? const MessageReplyPreview() : const SizedBox(),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                focusNode: focusNode,
                controller: messageController,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      isShownSendButton = true;
                    });
                  } else {
                    setState(() {
                      isShownSendButton = false;
                    });
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: kAntiqueWhite,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: SizedBox(
                      width: 102.0,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: toggleEmojiKeyboardContainer,
                            icon: const Icon(
                              Icons.emoji_emotions,
                              color: kGrey,
                            ),
                          ),
                          IconButton(
                            onPressed: selectGif,
                            icon: const Icon(
                              Icons.gif,
                              color: kGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  hintText: 'Type a message',
                  contentPadding: const EdgeInsets.all(12.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.0),
                    borderSide: const BorderSide(
                      width: 0.0,
                      style: BorderStyle.none,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 12.0,
                right: 3.0,
                left: 3.0,
              ),
              child: CircleAvatar(
                backgroundColor: kDarkOrange,
                radius: 24.0,
                child: GestureDetector(
                  onTap: sendTextMessage,
                  child: const Icon(
                    Icons.send,
                    color: kAntiqueWhite,
                  ),
                ),
              ),
            )
          ],
        ),
        isShownEmojiContainer
            ? SizedBox(
                height: 330.0,
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    setState(() {
                      messageController.text =
                          messageController.text + emoji.emoji;
                    });
                    if (!isShownSendButton) {
                      setState(() {
                        isShownSendButton = true;
                      });
                    }
                  },
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
