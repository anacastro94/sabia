import 'package:bbk_final_ana/common/constants/constants.dart';
import 'package:bbk_final_ana/common/enums/message_enum.dart';
import 'package:bbk_final_ana/messaging/chat/widgets/display_text_image_gif.dart';
import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';

class MyMessageCard extends StatelessWidget {
  const MyMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.type,
    required this.onLeftSwipe,
    required this.repliedText,
    required this.userName,
    required this.repliedMessageType,
    required this.isSeen,
  }) : super(key: key);
  final String message;
  final String date;
  final MessageEnum type;
  final void Function() onLeftSwipe;
  final String repliedText;
  final String userName;
  final MessageEnum repliedMessageType;
  final bool isSeen;

  @override
  Widget build(BuildContext context) {
    final isReplying = repliedText.isNotEmpty;
    return SwipeTo(
      onLeftSwipe: onLeftSwipe,
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 45.0),
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9.0)),
            color: kGreenOlivine,
            margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
            child: Stack(
              children: [
                Padding(
                  padding: type == MessageEnum.text
                      ? const EdgeInsets.only(
                          left: 10.0,
                          right: 30.0,
                          top: 5.0,
                          bottom: 20.0,
                        )
                      : const EdgeInsets.only(
                          left: 5.0,
                          right: 5.0,
                          top: 5.0,
                          bottom: 25.0,
                        ),
                  child: Column(
                    children: [
                      if (isReplying) ...[
                        Text(
                          userName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 3.0),
                        Container(
                          padding: const EdgeInsets.all(9.0),
                          decoration: BoxDecoration(
                            color: kAntiqueWhite.withOpacity(0.5),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(6.0)),
                          ),
                          child: DisplayTextImageGIF(
                            message: repliedText,
                            type: repliedMessageType,
                          ),
                        ),
                        const SizedBox(height: 9.0),
                      ],
                      DisplayTextImageGIF(message: message, type: type),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 4.0,
                  right: 10.0,
                  child: Row(
                    children: [
                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 13.0,
                          color: kAntiqueWhite,
                        ),
                      ),
                      const SizedBox(width: 5.0),
                      Icon(
                        isSeen ? Icons.done_all : Icons.done,
                        size: 20.0,
                        color: isSeen ? Colors.blue : kAntiqueWhite,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
