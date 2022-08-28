import 'package:bbk_final_ana/common/widgets/standar_circular_profile_avatar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SquareCachedNetworkImage extends StatelessWidget {
  const SquareCachedNetworkImage({
    Key? key,
    required this.imageUrl,
    required this.side,
  }) : super(key: key);

  final String imageUrl;
  final double side;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        width: side,
        height: side,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => StandardCircularProfileAvatar(
        radius: side / 2,
      ),
      errorWidget: (context, url, error) =>
          Image.asset('assets/images/logo.png'),
    );
  }
}
