import 'package:bbk_final_ana/common/widgets/standar_circular_profile_avatar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CircularCachedNetworkImage extends StatelessWidget {
  const CircularCachedNetworkImage({
    Key? key,
    required this.imageUrl,
    required this.radius,
  }) : super(key: key);

  final String imageUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => StandardCircularProfileAvatar(
        radius: radius,
      ),
      errorWidget: (context, url, error) =>
          Image.asset('assets/images/avatar.png'),
    );
  }
}
