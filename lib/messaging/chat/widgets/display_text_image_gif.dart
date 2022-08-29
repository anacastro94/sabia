import 'package:bbk_final_ana/common/enums/message_enum.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../common/widgets/standard_circular_progress_indicator.dart';

class DisplayTextImageGIF extends StatelessWidget {
  const DisplayTextImageGIF({
    Key? key,
    required this.message,
    required this.type,
  }) : super(key: key);
  final String message;
  final MessageEnum type;

  @override
  Widget build(BuildContext context) {
    return type == MessageEnum.text
        ? Text(
            message,
            style: const TextStyle(fontSize: 16.0),
          )
        : type == MessageEnum.audio
            ? const Text(
                '📙 New story available 🎵',
                style: TextStyle(fontSize: 16.0),
              )
            : CachedNetworkImage(
                imageUrl: message,
                placeholder: (context, url) =>
                    const StandardCircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(
                  Icons.error,
                  color: Colors.redAccent,
                ),
              );
  }
}
