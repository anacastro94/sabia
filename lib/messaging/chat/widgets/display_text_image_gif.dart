import 'package:bbk_final_ana/common/enums/message_enum.dart';
import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
        : CachedNetworkImage(
            imageUrl: message,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(
              Icons.error,
              color: Colors.redAccent,
            ),
          );
  }
}
